local function set_highlight_state(enabled)
    local util = require("love2d-treesitter.util")
    local configModule = require("love2d-treesitter.config")
    local new_state
    if type(enabled) == "boolean" then
        new_state = enabled
    else
        new_state = not configModule.config.enable_on_start
    end

    configModule.config.enable_on_start = new_state

    if new_state == true then
        vim.g.love2d_treesitter_conceallevel = 2
    else
        vim.g.love2d_treesitter_conceallevel = 0
    end

    util.load()
    if configModule.config.notifications == true then
        local msg = configModule.config.enable_on_start and "Enabled" or "Disabled"
        local level = configModule.config.enable_on_start and vim.log.levels.INFO or vim.log.levels.WARN
        vim.notify("LÖVE2D Highlights " .. msg, level, { title = "LÖVE2D treesitter" })
    end
end

vim.api.nvim_create_user_command("LOVEHighlightEnable", function()
    set_highlight_state(true)
    if vim.g.love2d_treesitter_conceal == true then
        vim.cmd("doautocmd User LOVEHighlightEnable")
    end
end, {})

vim.api.nvim_create_user_command("LOVEHighlightDisable", function()
    set_highlight_state(false)
    if vim.g.love2d_treesitter_conceal == true then
        vim.cmd("doautocmd User LOVEHighlightDisable")
    end
end, {})

vim.api.nvim_create_user_command("LOVEHighlightToggle", function()
    set_highlight_state()
    if vim.g.love2d_treesitter_conceal == true then
        vim.cmd("doautocmd User LOVEHighlightToggle")
    end
end, {})
