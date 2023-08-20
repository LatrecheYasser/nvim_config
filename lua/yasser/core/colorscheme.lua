local status, _ = pcall(vim.cmd,"colorscheme nightfly")
if not status then 
    print("colorscheme nightfly not found")
    return 
end 
