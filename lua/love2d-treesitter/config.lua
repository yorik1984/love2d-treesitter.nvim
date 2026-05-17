local check = require("love2d-treesitter.check")

local M = {}

---@alias LoveTreesitterStyleType string
---| "bold"
---| "italic"
---| "underline"
---| "bold,italic"
---| "bold,underline"
---| "italic,underline"
---| "NONE"

---@class LoveTreesitterStyle
---@field love LoveTreesitterStyleType Style for `love` global variable
---@field module LoveTreesitterStyleType Style for LÖVE modules
---@field type LoveTreesitterStyleType Style for LÖVE types/objects
---@field dot LoveTreesitterStyleType Style for LÖVE dot and colon operator
---@field func LoveTreesitterStyleType Style for LÖVE functions
---@field method LoveTreesitterStyleType Style for LÖVE methods
---@field callback LoveTreesitterStyleType Style for LÖVE callbacks (e.g., love.load)
---@field conf LoveTreesitterStyleType Style for LÖVE configuration (love.conf)

---@class LoveTreesitterColors
---@field LOVElove string|fun():string? HEX color for `love` global variable
---@field LOVEmodule string|fun():string? HEX color for LÖVE modules
---@field LOVEtype string|fun():string? HEX color for LÖVE types/objects
---@field LOVEdot string|fun():string? HEX color for LÖVE dot and colon operator
---@field LOVEfunction string|fun():string? HEX color for LÖVE functions
---@field LOVEmethod string|fun():string? HEX color for LÖVE methods
---@field LOVEcallback string|fun():string? HEX color for LÖVE callbacks
---@field LOVEconf string|fun():string? HEX color for LÖVE configuration

---@class LoveTreesitterConfig
---@field enable_on_start boolean Whether to enable highlighting automatically on startup
---@field auto_detect_love2d boolean Whether to automatically detect LÖVE projects. Requires installed https://github.com/S1M0N38/love2d.nvim
---@field notifications boolean Whether to enable notifications
---@field style LoveTreesitterStyle Custom font styles (supports combinations like "bold,italic")
---@field colors LoveTreesitterColors Optional table to override default HEX colors

---@class LoveTreesitterConceal
---@field love string|false Character to conceal the `love` global variable. Set to `false` to disable. Defaults to `false`
---@field love_dot string|false Character to conceal the dot operator (e.g., ".") after `love.` . Set to `false` to disable. Defaults to `false`
M.defaults = {
    enable_on_start    = false,
    auto_detect_love2d = true, -- requires installed https://github.com/S1M0N38/love2d.nvim
    notifications      = false,
    style              = {
        love     = "bold",
        module   = "NONE",
        type     = "NONE",
        dot      = "NONE",
        func     = "NONE",
        method   = "NONE",
        callback = "NONE",
        conf     = "NONE",
    },
    colors             = {
        LOVElove     = nil, -- "#E54D95"
        LOVEmodule   = nil, -- function() return (vim.o.background == "dark") and "#EA70AA" or "#E54D95" end,
        LOVEtype     = nil,
        LOVEdot      = nil,
        LOVEfunction = nil,
        LOVEmethod   = nil,
        LOVEcallback = nil,
        LOVEconf     = nil,
    },
    conceal            = {
        love     = false, -- `love = ""` or `love = "🩷"`
        love_dot = false, -- empty `" "`
    },
}

M.config = vim.deepcopy(M.defaults)

---@param user_settings table?
function M.setup(user_settings)
    user_settings = user_settings or {}

    check.validateUserSettings(user_settings)

    check.typeError(user_settings)

    check.keyExistsError(user_settings, M.defaults, "Option")

    M.config = vim.tbl_deep_extend("force", {}, M.defaults, user_settings)

    if M.config.auto_detect_love2d then
        M.config.auto_detect_love2d = check.requiresPluginError("love2d",
            "`auto_detect_love2d` option requires `https://github.com/S1M0N38/love2d.nvim` or set to `false` to disable autodetecting love2d projects",
            2)
    end

    for k, v in pairs(M.config) do
        if v == 0 then
            M.config[k] = false
        end
    end
end

return M
