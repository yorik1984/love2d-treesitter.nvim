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
    if configModule.config.auto_detect_love2d == true then
        configModule.config.enable_on_start = true
        M.autocmdsAutodetect()
    end

    M.autocmdColorscheme(config)
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
        M.syntax(theme.setup(configColors, configStyle))
        M.autocmds(theme.setup(configColors, configStyle))
    else
        -- force set to 0 (not revert to default `vim.o.conceallevel`) to hide love concealed symbols
        M.setConceal(0)
        vim.api.nvim_create_augroup("love2d-treesitter", { clear = true })
        M.syntaxClear(theme.setup(configColors, configStyle))
    end
end

function M.setConceal(level)
    vim.schedule(function()
        local wins = vim.api.nvim_tabpage_list_wins(0)
        for _, win in ipairs(wins) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].filetype == "lua" then
                vim.api.nvim_win_call(win, function()
                    vim.wo.conceallevel = level
                end)
            end
        end
    end)
end

function M.autocmdColorscheme(config)
    local augroup = vim.api.nvim_create_augroup("love2d-treesitter-colorscheme", {})
    vim.api.nvim_create_autocmd("ColorScheme", {
        group = augroup,
        callback = function()
            require("love2d-treesitter.util").load(config)
        end
    })
end

function M.autocmdsAutodetect()
    local love2d_treesitter_autodetect = vim.api.nvim_create_augroup("love2d-treesitter-autodetect", {})
    vim.api.nvim_create_autocmd("User", {
        pattern = "LoveProjectEnter",
        group = love2d_treesitter_autodetect,
        callback = function()
            vim.schedule(function()
                vim.cmd("LOVEHighlightEnable")
            end)
        end,
    })

    vim.api.nvim_create_autocmd("User", {
        pattern = "LoveProjectLeave",
        group = love2d_treesitter_autodetect,
        callback = function()
            vim.schedule(function()
                vim.cmd("LOVEHighlightDisable")
            end)
        end,
    })
end

function M.autocmds(syntax)
    local love2d_treesitter = vim.api.nvim_create_augroup("love2d-treesitter", {})
    vim.api.nvim_create_autocmd({ "VimEnter", "BufWinEnter", "WinEnter" }, {
        group = love2d_treesitter,
        pattern = { "*.lua" },
        callback = function()
            vim.schedule(function()
                require("love2d-treesitter.util").syntax(syntax)
            end)
        end,
    })

    if vim.g.love2d_treesitter_conceal == true then
        local group = vim.api.nvim_create_augroup("love2d-treesitter-conceal", {})
        vim.api.nvim_create_autocmd("User", {
            pattern = "LOVEHighlightEnable",
            group = group,
            callback = function()
                require("love2d-treesitter.util").setConceal(2)
            end,
        })

        vim.api.nvim_create_autocmd("User", {
            pattern = "LOVEHighlightDisable",
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
