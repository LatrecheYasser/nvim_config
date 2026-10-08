local M = {}
local pending = {}
local markers = { "MODULE.bazel", "WORKSPACE", "WORKSPACE.bazel" }

function M.context(bufnr)
    local file = vim.api.nvim_buf_get_name(bufnr or 0)
    local workspace = vim.fs.root(file, markers)
    if not workspace then return end
    local module = vim.fs.root(file, { "BUILD.bazel", "BUILD" })
    if not module then return end
    workspace = vim.uv.fs_realpath(workspace) or workspace
    module = vim.uv.fs_realpath(module) or module
    local cache = vim.fs.joinpath(vim.fn.stdpath("cache"), "bazel-java", vim.fn.sha256(module):sub(1, 16))
    return { workspace = workspace, module = module, cache = cache, project = cache .. "/project" }
end

local function java_home()
    for _, path in ipairs({
        vim.env.NVIM_JAVA_HOME or "",
        "/opt/homebrew/opt/openjdk@25/libexec/openjdk.jdk/Contents/Home",
        "/usr/local/opt/openjdk@25/libexec/openjdk.jdk/Contents/Home",
        vim.env.JAVA_HOME or "",
    }) do
        if path ~= "" and vim.fn.executable(path .. "/bin/java") == 1 then return path end
    end
end

local function start(bufnr, context)
    if not vim.api.nvim_buf_is_valid(bufnr) or vim.bo[bufnr].filetype ~= "java" then return end
    if context then
        local current = M.context(bufnr)
        if not current or current.module ~= context.module then return end
    end
    local home = java_home()
    if not home or vim.fn.executable("jdtls") ~= 1 then
        vim.notify("Java support needs jdtls and JDK 25 (brew install jdtls openjdk@25)", vim.log.levels.ERROR)
        return
    end
    local root = context and context.project or vim.fs.root(bufnr, { "pom.xml", "build.gradle", "build.gradle.kts", ".git" })
    if not root then return end
    local cache = context and context.cache or vim.fs.joinpath(vim.fn.stdpath("cache"), "jdtls", vim.fn.sha256(root):sub(1, 16))
    local settings = {
        configuration = { runtimes = { { name = "JavaSE-25", path = home, default = true } } },
        signatureHelp = { enabled = true },
        contentProvider = { preferred = "fernflower" },
    }
    if context then
        settings.import = { maven = { enabled = false }, gradle = { enabled = false } }
        settings.configuration.updateBuildConfiguration = "automatic"
        local formatter = context.workspace .. "/eclipse-java-google-style-format.xml"
        if vim.fn.filereadable(formatter) == 1 then
            settings.format = { settings = { url = vim.uri_from_fname(formatter), profile = "GoogleStyle" } }
        end
    end
    require("jdtls").start_or_attach({
        cmd = { "jdtls", "--java-executable", home .. "/bin/java", "--jvm-arg=-Xmx2g", "-data", cache .. "/workspace" },
        root_dir = root,
        capabilities = require("blink.cmp").get_lsp_capabilities(),
        settings = { java = settings },
        on_attach = function(_, buffer)
            vim.keymap.set("n", "<leader>jo", require("jdtls").organize_imports, { buffer = buffer, desc = "Java organize imports" })
        end,
    }, nil, { bufnr = bufnr })
end

function M.sync(bufnr, targets)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    local context = M.context(bufnr)
    if not context then
        vim.notify("Open a file inside a Bazel package first", vim.log.levels.WARN)
        return
    end
    if pending[context.module] then
        pending[context.module][bufnr] = true
        return
    end
    pending[context.module] = { [bufnr] = true }
    M.last_log = ""
    vim.notify("Resolving Bazel Java dependencies for " .. vim.fs.basename(context.module))
    local cmd = {
        "python3", vim.fn.stdpath("config") .. "/scripts/bazel_java.py",
        "--workspace", context.workspace, "--module", context.module, "--project", context.project,
    }
    vim.list_extend(cmd, targets or {})
    vim.system(cmd, {
        text = true,
        stderr = vim.schedule_wrap(function(_, data)
            if data then
                M.last_log = M.last_log .. data
                if M.log_buffer and vim.api.nvim_buf_is_valid(M.log_buffer) then
                    vim.api.nvim_buf_set_lines(M.log_buffer, 0, -1, false, vim.split(M.last_log, "\n"))
                end
            end
        end),
    }, vim.schedule_wrap(function(result)
        local buffers = pending[context.module]
        pending[context.module] = nil
        M.last_log = M.last_log .. "\n" .. result.stdout
        if result.code ~= 0 then
            vim.notify("Bazel Java sync failed; see :BazelJavaLog", vim.log.levels.ERROR)
            return
        end
        local metadata = vim.json.decode(result.stdout)
        for _, client in ipairs(vim.lsp.get_clients({ name = "jdtls" })) do
            if client.config.root_dir == context.project then
                for buffer in pairs(client.attached_buffers) do buffers[buffer] = true end
                client:stop()
                vim.wait(10000, function() return vim.lsp.get_client_by_id(client.id) == nil end)
            end
        end
        for buffer in pairs(buffers) do start(buffer, context) end
        vim.notify("Bazel Java ready: " .. metadata.libraries .. " dependency jars")
    end))
end

function M.attach(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    local context = M.context(bufnr)
    if context then
        vim.bo[bufnr].expandtab = true
        vim.bo[bufnr].shiftwidth, vim.bo[bufnr].tabstop, vim.bo[bufnr].softtabstop = 2, 2, 2
    end
    if context and vim.fn.filereadable(context.project .. "/.project") == 0 then
        M.sync(bufnr)
    else
        start(bufnr, context)
    end
end

function M.setup()
    vim.api.nvim_create_user_command("BazelJavaSync", function(args) M.sync(nil, args.fargs) end, {
        nargs = "*", desc = "Build Java targets and refresh JDTLS dependencies",
    })
    vim.api.nvim_create_user_command("BazelJavaLog", function()
        vim.cmd("botright new")
        vim.bo.buftype, vim.bo.bufhidden, vim.bo.swapfile = "nofile", "wipe", false
        M.log_buffer = vim.api.nvim_get_current_buf()
        vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(M.last_log or "No sync has finished yet", "\n"))
    end, {})
    vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("BazelJava", { clear = true }),
        pattern = "java", callback = function(args) M.attach(args.buf) end,
    })
    M.attach()
end

return M
