local status,lualine = pcall(require,"lualine")
if not status then 
    print("no lunaline")
    return 
end 
lualine.setup()
