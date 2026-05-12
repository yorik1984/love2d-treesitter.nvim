local check        = require("love2d-treesitter.check")
local colors       = require("love2d-treesitter.colors")
local conceal      = require("love2d-treesitter.conceal")
local configModule = require("love2d-treesitter.config")
local style        = require("love2d-treesitter.style")
local theme        = require("love2d-treesitter.theme")
local M            = {}

function M.syntax(syntax)
    for group, color in pairs(syntax) do
        M.highlight(group, color)
    end
end

function M.syntaxClear(syntax)
    for group, _ in pairs(syntax) do
        vim.api.nvim_set_hl(0, group, {})
    end
end

function M.highlight(group, color)
    if color.style then
        if type(color.style) == "table" then
            color = vim.tbl_extend("force", color, color.style)
        elseif color.style:lower() ~= "none" then
            -- handle old string style definitions
            for s in string.gmatch(color.style, "([^,]+)") do
                color[s] = true
            end
        end
        color.style = nil
    end

    vim.api.nvim_set_hl(0, group, color)
end

function M.setup(userConfig)
    local config = configModule.setup(userConfig)
    M.load(config)
end

function M.load(configApply)
    local config = configModule.config

    if configApply then
        configModule.setup(configApply)
        config = configModule.config
    end

    local configColors = colors.setup(config)
    local configStyle = style.setupStyle(config)
    conceal.setConceal(config)

    if config.enable_on_start == true then
        vim.g.love2d_treesitter_conceallevel = 2
        M.syntax(theme.setup(configColors, configStyle))
        M.autocmds(theme.setup(configColors, configStyle))
    else
        vim.g.love2d_treesitter_conceallevel = 0
        -- force set to 0 (not revert to default `vim.o.conceallevel`) to hide love concealed symbols
        M.setConceal(0)
        M.syntaxClear(theme.setup(configColors, configStyle))
        vim.api.nvim_create_augroup("love2d-treesitter", { clear = true })
    end
end

function M.setConceal(level)
    vim.schedule(function()
        local cur_win = vim.fn.winnr()
        vim.cmd("windo if &ft == 'lua' | setlocal conceallevel=" .. level .. " | endif")
        vim.cmd(cur_win .. "wincmd w")
    end)
end

function M.autocmds(syntax)
    vim.api.nvim_create_autocmd({ "VimEnter", "BufWinEnter", "WinEnter" }, {
        group = vim.api.nvim_create_augroup("love2d-treesitter", {}),
        pattern = { "*.lua" },
        callback = function()
            require("love2d-treesitter.util").syntax(syntax)
        end,
    })
    if vim.g.love2d_treesitter_conceal == true and vim.g.love2d_treesitter_conceallevel == 2 then
        local group = vim.api.nvim_create_augroup("love2d-treesitter-conceal", {})

        vim.api.nvim_create_autocmd("User", {
            pattern = { "LOVEHighlightEnable", "LoveProjectEnter" },
            group = group,
            callback = function()
                require("love2d-treesitter.util").setConceal(2)
            end,
        })

        vim.api.nvim_create_autocmd("User", {
            pattern = { "LOVEHighlightDisable", "LoveProjectLeave" },
            group = group,
            callback = function()
                require("love2d-treesitter.util").setConceal(0)
            end,
        })

        vim.api.nvim_create_autocmd("User", {
            pattern = "LOVEHighlightToggle",
            group = group,
            callback = function()
                require("love2d-treesitter.util").setConceal(vim.g.love2d_treesitter_conceallevel)
            end,
        })
    end
end

return M
