<h1 align="center">♡&nbsp;&nbsp; <a href="https://love2d.org">LÖVE</a> <a href="https://github.com/nvim-treesitter/nvim-treesitter">Treesitter</a>&nbsp;&nbsp;♡</h1>

[![Generate love2d-treesitter](https://github.com/yorik1984/love2d-treesitter.nvim/actions/workflows/update-love-api.yml/badge.svg)](https://github.com/yorik1984/love2d-treesitter.nvim/actions/workflows/update-love-api.yml)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/yorik1984/love2d-treesitter.nvim/blob/main/LICENSE)
[![Lua](https://img.shields.io/badge/Lua-5.1-blue.svg)](https://www.lua.org/)
[![LÖVE API](https://img.shields.io/badge/L%C3%96VE_API-11.5-EA316E.svg)](https://github.com/love2d-community/love-api)
[![Neovim](https://img.shields.io/badge/Neovim-0.5+-green.svg)](https://neovim.io/)

**Beautiful syntax highlighting 📝 | Treesitter support 🌳**

## ✨ About

**love2d-treesitter.nvim** is a comprehensive plugin for [Neovim](https://neovim.io/) that highlight [LÖVE](http://love2d.org) syntax in your editor.

- 🎨 **Syntax Highlighting** — Colors LÖVE functions, modules, types, and callbacks
- 🌳 **Treesitter Support** — Full integration with Neovim's Treesitter
- 🔧 **Customizable** — Flexible styling options

### Features highlighted:

```lua
-- LÖVE functions light up automatically
love.graphics.rectangle("fill", 100, 100, 200, 200)

-- Callbacks are specially highlighted
function love.load()
end

-- Configuration flags in conf.lua get special treatment
-- work with treesitter too
-- love.conf = function(t)
function love.conf(t)
    t.window.width = 800
    t.window.height = 600
end
```

<!-- TOC -->

## Table of Contents

- [📦 Installation](#-installation)
- [📍 Default settings](#-default-settings)
- [❓ Plugin Help](#-plugin-help)
- [🔄 Rebuilding the API](#-rebuilding-the-api)
  - [🤖 Automated Workflow](#-automated-workflow)
  - [✋ Manual Generation (Optional)](#-manual-generation-optional)
- [🎨 Screenshots](#-screenshots)
- [📚 References & Related Projects](#-references--related-projects)
- [©️ Credits](#-credits)

<!-- /TOC -->

## 📦 Installation

#### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
require("lazy").setup({
    "yorik1984/love2d-treesitter.nvim",
    branch = "main", -- default or `branch = "11.5"` for special API version
    ft = "lua",
    opts = {},
})
```

## 📍 Default settings

```lua
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
---@field LOVElove string? HEX color for `love` global variable
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
require("love2d-treesitter").setup({
    enable_on_start = true,
    notifications = true,
    style = {
        love     = "bold",      -- `love` global variable
        module   = "NONE",      -- LÖVE modules (graphics, audio, etc.)
        type     = "NONE",      -- LÖVE types/objects
        dot      = "NONE",      -- Dot and colon operators
        func     = "NONE",      -- LÖVE functions
        method   = "NONE",      -- LÖVE methods
        callback = "NONE",      -- Callbacks (load, update, draw)
        conf     = "NONE",      -- Configuration flags
    },
    colors = {
        LOVElove     = nil,     -- Example: "#E54D95"
        LOVEmodule   = nil,
        LOVEtype     = nil,
        LOVEdot      = nil,
        LOVEfunction = nil,
        LOVEmethod   = nil,
        LOVEcallback = nil,
        LOVEconf     = nil,
    },
})
```

> [!TIP]
> Add configuration for enhanced LÖVE development with  built-in API docs and LÖVE-specific features<br>
> See more in [📚 References & Related Projects](#-references--related-projects)

```lua
{
    "yorik1984/love2d-treesitter.nvim",
    dependencies = {
        { "yorik1984/love2d-docs.nvim" }, -- Built-in LÖVE documentation
        { "S1M0N38/love2d.nvim" },        -- A simple Neovim plugin to build games with LÖVE
    },
    ft = "lua",
    opts = {
        enable_on_start = false,
        ...
    },
    config = function(_, opts)
        require("love2d-treesitter").setup(opts)

        -- Autodetect LÖVE project
        local group = vim.api.nvim_create_augroup("Love2DAutoStart", { clear = true })
        vim.api.nvim_create_autocmd({ "VimEnter", "BufReadPost" }, {
            group = group,
            pattern = { "*.lua" },
            callback = function()
                local configModule = require("love2d-treesitter.config")
                configModule.setup(opts)
                local config = configModule.config
                config.enable_on_start = true

                local ok, love2d = pcall(require, "love2d")
                if ok and type(love2d.is_love2d_project) == "function" then
                    if love2d.is_love2d_project() then
                        require("love2d-treesitter.util").load(config)
                    end
                end
            end,
        })
    end,
}
```

#### Treesitter Highlight Groups

Configure Treesitter styles using the following defaults:

| Highlight Group                    | HEX Color | Color Variable | Style  |
| ---------------------------------- | --------- | -------------- | ------ |
| `@variable.global.love.lua`        | `#E54D95` | `LOVElove`     | `bold` |
| `@module.bulitin.love.lua`         | `#E54D95` | `LOVEmodule`   | `NONE` |
| `@type.love.lua`                   | `#E54D95` | `LOVEtype`     | `NONE` |
| `@punctuation.dot.love.lua`        | `#E54D95` | `LOVEdot`      | `NONE` |
| `@function.love.lua`               | `#2FA8DC` | `LOVEfunction` | `NONE` |
| `@function.method.love.lua`        | `#2FA8DC` | `LOVEmethod`   | `NONE` |
| `@function.call.love.callback.lua` | `#2FA8DC` | `LOVEcallback` | `NONE` |
| `@function.call.love.conf.lua`     | `#2FA8DC` | `LOVEconf`     | `NONE` |

## Commands

The plugin provides the following user commands to manage highlighting states.

| Command                 | Description                                            |
| ----------------------- | ------------------------------------------------------ |
| `:LOVEHighlightEnable`  | **Enables** LÖVE highlighting for the current session. |
| `:LOVEHighlightDisable` | **Disables** LÖVE highlighting and resets colors.      |
| `:LOVEHighlightToggle`  | **Toggles** the highlighting state (On/Off).           |

#### Recommended Keybindings

Example configuration with [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    "yorik1984/love2d-treesitter",
    keys = {
        { "<leader>Lt", "<cmd>LOVEHighlightToggle<cr>", ft = "lua", desc = "Toggle LÖVE Highlights" },
        { "<leader>Le", "<cmd>LOVEHighlightEnable<cr>", ft = "lua", desc = "Enable LÖVE Highlights" },
        { "<leader>Ld", "<cmd>LOVEHighlightDisable<cr>", ft = "lua", desc = "Disable LÖVE Highlights" },
    },
}
```

### ❓ Plugin Help

Get help on configuring the plugin itself `:help love2d-treesitter`. This opens documentation about available options, commands, and customization.

## 🔄 Rebuilding the API

### 🤖 Automated Workflow

This plugin uses **GitHub Actions** to automatically stay up-to-date with the latest LÖVE API:

| Feature      | Details                                                                   |
| ------------ | ------------------------------------------------------------------------- |
| **Schedule** | Every Monday at 00:30 UTC                                                 |
| **Trigger**  | Manual dispatch via Actions tab                                           |
| **Source**   | [love2d-community/love-api](https://github.com/love2d-community/love-api) |
| **Updates**  | Treesitter queries                       |

**How it works:**

1. 🔄 Fetches the latest LÖVE API specification
2. 🌳 Refreshes Treesitter queries
3. 🚀 Automatically commits changes to the repository
4. 📌 Creates version branches (e.g., `11.5`, `12.0`) for API version tracking

> [!NOTE]
> The badge at the top of this README always shows the current LÖVE API version supported by this plugin.

### ✋ Manual Generation (Optional)

> [!TIP]
> **You don't need to do this!** The automated workflow keeps everything up-to-date.  
> Manual generation is only for:
> - Testing custom modifications
> - Contributing to plugin development
> - Offline environments without GitHub Actions

If you still want to generate files manually:

- Prerequisites:
```
# Ensure these are installed
git --version
lua -v           # Lua 5.1
```

- Configure (optional):
Edit build/env.txt to set custom paths:
```
lua="lua5.1"     # Change to your Lua version
```

- Run the generator:
```bash
# On Linux/Mac
chmod +x build/gen.sh
./build/gen.sh

# On Windows
build/gen.bat
```

- Generated files:
    - 🌳[`after/queries/lua/highlights.scm`](after/queries/lua/highlights.scm) — Treesitter queries
    - 🧪[`test/example/api_full_list.lua`](test/example/api_full_list.lua) — Test preview file with full API-list
    - ⚙️[`test/example/conf.lua`](test/example/conf.lua) — Test preview `love.conf()`

## 🎨 Screenshots

### [newpaper.nvim](https://github.com/yorik1984/newpaper.nvim)

<div align="center">
  <img src="https://raw.githubusercontent.com/yorik1984/love2d-treesitter.nvim/main/pics/screen1.png" alt="Neovim screenshot 1" width="80%">
  <br><br>
  <img src="https://raw.githubusercontent.com/yorik1984/love2d-treesitter.nvim/main/pics/screen2.png" alt="Neovim screenshot 2" width="80%">
</div>

## ⚠️ Known limitation

### Same Methods for Different Types in LÖVE

<div align="center">
  <img src="https://raw.githubusercontent.com/yorik1984/love2d-treesitter.nvim/main/pics/highlight-error.png" alt="Highlight error" width="80%">
  <br>
</div>

```lua
-- Text ✅
local font  = love.graphics.newFont(12)
local text1 = love.graphics.newText(font, "Hello")
text1:getDimensions() -- ✅ Correct: Text has getDimensions()
      ^^^^^^^^^^^^^^
      └── @function.method.love.lua (highlight) - priority 150

-- Texture (valid) ✅
local texture1 = love.graphics.newImage("texture1.png")
texture1:getDimensions() -- ✅ Correct: Texture has getDimensions()
         ^^^^^^^^^^^^^^
         └── @function.method.love.lua (highlight) - priority 150

-- Texture (string) ⚠️
local texture2 = "texture2.png"
texture2:getDimensions() -- ⚠️ Highlighted, but LSP error
         ^^^^^^^^^^^^^^
         ├── @function.method.love.lua (highlight) - priority 150
         └── 🔴 LSP Diagnostic: "undefined field `getDimensions`" (severity: ERROR)

-- Texture (nil) ❌
local texture3
texture3:getDimensions() -- ❌ Highlighted, but error
         ^^^^^^^^^^^^^^
         └── @function.method.love.lua (highlight) - priority 150
```

> [!WARNING]
> **Treesitter highlights the method by name, without checking the variable type!** <br>
> This means the method will be highlighted **even if**:
> - The variable is a `string`, `number`, or `nil`
> - The type doesn't have this method
> - The variable hasn't been defined yet

```lua
local something = "string"
something:method()  -- Will highlight, but will cause an error!
```

> [!TIP]
> Always rely on LSP diagnostics to check correctness.
> Treesitter provides syntax highlighting only. It does not understand types or semantics.
> LSP is responsible for type checking and error detection.

## 📚 References & Related Projects

+ **[love2d-definitions](https://github.com/yorik1984/love2d-definitions)**<br>
[LuaCATS](https://luals.github.io/wiki/annotations/) definition for [LÖVE](https://love2d.org/) framework.
Creates `---@class` and `---@alias` definitions for perfect autocompletion and type checking in IDEs with LuaCATS.
    - **🤖 Automated Updates:** Uses GitHub Actions to stay in sync with the official love-api, just like this plugin.
    - **📦 Ready-to-Use:** Provides a pre-generated `library/` folder that you can directly add to your workspace library.
    - **🧠 Smart Type System:** Intelligently handles type unions, plural forms (e.g., `tables` → `table[]`), optional parameters, and function overloads.
    - **📌 Version Branches:** Includes branches for specific LÖVE versions (e.g., `11.5`), so you can use annotations that match your project.

> [!TIP]
> Use this definition alongside **love2d-treesitter** for the ultimate LÖVE development setup — get beautiful syntax highlighting in your editor and intelligent IDE autocompletion from these LuaCATS annotations.

+ **[love2d-docs.nvim](https://github.com/yorik1984/love2d-docs.nvim)**<br>
Is a comprehensive plugin for [Neovim](https://neovim.io/) and [Vim](https://www.vim.org/) that brings the entire [LÖVE](http://love2d.org) game framework documentation right into your editor.
    - 📖 **Built-in Help** — Complete LÖVE API documentation accessible via `:help LOVE-*`

+ **[love2d-vim-syntax](https://github.com/yorik1984/love2d-vim-syntax)**<br>
Plugin for [Vim](https://www.vim.org/) that highlight [LÖVE](http://love2d.org) syntax in your editor.
    - 🎨 **Syntax Highlighting** — Colors LÖVE functions, modules, types, and callbacks
    - 🔧 **Customizable** — Flexible styling options for Vim

## ©️ Credits

+ Original Author: [Davis Claiborne](https://github.com/davisdude) — Created and maintained the original [vim-love-docs](https://github.com/davisdude/vim-love-docs)
+ Powered by: [love-api](https://github.com/love2d-community/love-api) — Community-maintained LÖVE API specification

<div align="center">
  <sub>
    Built with ♡ for the LÖVE community
    <br>
    <a href="https://github.com/yorik1984/love2d-treesitter/issues">Report Issue</a> ·
    <a href="https://github.com/yorik1984/love2d-treesitter/discussions">Discussion</a> ·
    <a href="https://love2d.org/">LÖVE</a>
  </sub>
</div>
