local check = require("love2d-treesitter.check")

local M = {}

---@alias LoveTreesitterStyleType string
---| '"bold"'
---| '"italic"'
---| '"underline"'
---| '"bold,italic"'
---| '"bold,underline"'
---| '"italic,underline"'
---| '"NONE"'

---@class LoveTreesitterStyle
---@field love LoveTreesitterStyleType Style for 'love' global variable
---@field module LoveTreesitterStyleType Style for LÖVE modules
---@field type LoveTreesitterStyleType Style for LÖVE types/objects
---@field dot LoveTreesitterStyleType Style for LÖVE dot and colon operator
---@field func LoveTreesitterStyleType Style for LÖVE functions
---@field method LoveTreesitterStyleType Style for LÖVE methods
---@field callback LoveTreesitterStyleType Style for LÖVE callbacks (e.g., love.load)
---@field conf LoveTreesitterStyleType Style for LÖVE configuration (love.conf)

---@class LoveTreesitterColors
---@field LOVElove string? HEX color for 'love' global variable
---@field LOVEmodule string? HEX color for LÖVE modules
---@field LOVEtype string? HEX color for LÖVE types/objects
---@field LOVEdot string? HEX color for LÖVE dot and colon operator
---@field LOVEfunction string? HEX color for LÖVE functions
---@field LOVEmethod string? HEX color for LÖVE methods
---@field LOVEcallback string? HEX color for LÖVE callbacks
---@field LOVEconf string? HEX color for LÖVE configuration

---@class LoveTreesitterConfig
---@field enable_on_start boolean Whether to enable highlighting automatically on startup
---@field notifications boolean Whether to enable notifications
---@field style LoveTreesitterStyle Custom font styles (supports combinations like "bold,italic")
---@field colors LoveTreesitterColors Optional table to override default HEX colors

M.defaults = {
    enable_on_start = true,
    notifications = true,
    style = {
        love     = "bold",
        module   = "NONE",
        type     = "NONE",
        dot      = "NONE",
        func     = "NONE",
        method   = "NONE",
        callback = "NONE",
        conf     = "NONE",
    },
    colors = {
        LOVElove     = nil, -- Example: "#E54D95"
        LOVEmodule   = nil,
        LOVEtype     = nil,
        LOVEdot      = nil,
        LOVEfunction = nil,
        LOVEmethod   = nil,
        LOVEcallback = nil,
        LOVEconf     = nil,
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

    for k, v in pairs(M.config) do
        if v == 0 then
            M.config[k] = false
        end
    end
end

return M
