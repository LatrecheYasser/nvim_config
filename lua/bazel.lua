local M = {}

local function context()
    local current = require("java").context()
    if not current then
        vim.notify("Open a file inside a Bazel package first", vim.log.levels.WARN)
        return
    end
    local package = current.module:sub(#current.workspace + 2)
    current.target = "//" .. package .. ":all"
    return current
end

function M.run(argv, workspace, on_success)
    vim.cmd("botright 12new")
    local buffer = vim.api.nvim_get_current_buf()
    vim.b[buffer].bazel_command = argv
    vim.fn.jobstart(argv, {
        cwd = workspace,
        term = true,
        on_exit = function(_, code)
            vim.schedule(function()
                if vim.api.nvim_buf_is_valid(buffer) then vim.b[buffer].bazel_exit_code = code end
                if code == 0 and on_success then on_success() end
                vim.notify(code == 0 and "Bazel command passed" or "Bazel command failed (" .. code .. ")",
                    code == 0 and vim.log.levels.INFO or vim.log.levels.ERROR)
            end)
        end,
    })
end

local function has_target(args)
    for _, arg in ipairs(args) do
        if arg:sub(1, 1) ~= "-" then return true end
    end
    return false
end

function M.build(args)
    local current = context()
    if not current then return end
    vim.cmd.update()
    args = args or {}
    if has_target(args) then
        M.run(vim.list_extend({ "bzl", "build" }, args), current.workspace)
        return
    end
    local query = 'kind("java_(library|binary|test) rule", ' .. current.target .. ')'
    vim.system({ "bzl", "query", query, "--output=label" }, { cwd = current.workspace, text = true },
        vim.schedule_wrap(function(result)
            if result.code ~= 0 or vim.trim(result.stdout) == "" then
                vim.notify("Could not find Java targets: " .. result.stderr, vim.log.levels.ERROR)
                return
            end
            local cmd = vim.list_extend({ "bzl", "build" }, vim.split(vim.trim(result.stdout), "\n"))
            M.run(vim.list_extend(cmd, args), current.workspace)
        end))
end

function M.test(args, file_only)
    if file_only and vim.bo.filetype ~= "java" then
        vim.notify("BazelTestFile needs a Java test buffer", vim.log.levels.WARN)
        return
    end
    local current = context()
    if not current then return end
    vim.cmd.update()
    args = args or {}
    local cmd = { "bzl", "test", "--build_tests_only", "--test_output=errors" }
    if not has_target(args) then table.insert(cmd, current.target) end
    if file_only then
        table.insert(cmd, "--test_filter=" .. vim.fn.expand("%:t:r"))
    end
    M.run(vim.list_extend(cmd, args), current.workspace)
end

function M.format()
    local current = context()
    if not current then return end
    local file = vim.api.nvim_buf_get_name(0)
    local filetype = vim.bo.filetype
    vim.cmd.update()
    local cmd
    if filetype == "java" then
        cmd = { "bzl", "run", "//rules/format:format_java", "--", file:sub(#current.workspace + 2) }
    elseif filetype == "bzl" then
        cmd = { "buildifier", file }
    else
        vim.notify("BazelFormat supports Java and Starlark buffers", vim.log.levels.WARN)
        return
    end
    M.run(cmd, current.workspace, function() vim.cmd.checktime() end)
end

function M.setup()
    vim.api.nvim_create_user_command("BazelBuild", function(args) M.build(args.fargs) end, { nargs = "*" })
    vim.api.nvim_create_user_command("BazelTest", function(args) M.test(args.fargs) end, { nargs = "*" })
    vim.api.nvim_create_user_command("BazelTestFile", function(args) M.test(args.fargs, true) end, { nargs = "*" })
    vim.api.nvim_create_user_command("BazelFormat", M.format, {})
    vim.keymap.set("n", "<leader>bb", "<cmd>BazelBuild<CR>", { desc = "Bazel build Java module" })
    vim.keymap.set("n", "<leader>bt", "<cmd>BazelTest<CR>", { desc = "Bazel test module" })
    vim.keymap.set("n", "<leader>bf", "<cmd>BazelTestFile<CR>", { desc = "Bazel test current class" })
end

return M
