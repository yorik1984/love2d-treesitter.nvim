<div align="center">

  <img src="https://raw.githubusercontent.com/yorik1984/love2d-treesitter.nvim/main/pics/conceal.png" alt="Conceal" height="256">
  <br>

<h1>♡&nbsp;&nbsp; <a href="https://love2d.org">LÖVE</a> <a href="https://github.com/nvim-treesitter/nvim-treesitter">Treesitter</a>&nbsp;&nbsp;♡</h1>

[![Generate love2d-treesitter](https://github.com/yorik1984/love2d-treesitter.nvim/actions/workflows/update-love-api.yml/badge.svg)](https://github.com/yorik1984/love2d-treesitter.nvim/actions/workflows/update-love-api.yml)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/yorik1984/love2d-treesitter.nvim/blob/main/LICENSE)
[![Lua](https://img.shields.io/badge/Lua-5.1-blue.svg)](https://www.lua.org/)
[![LÖVE API](https://img.shields.io/badge/L%C3%96VE_API-11.5-EA316E.svg)](https://github.com/love2d-community/love-api)
[![Neovim](https://img.shields.io/badge/Neovim-0.5+-green.svg)](https://neovim.io/)

</div>

**Beautiful syntax highlighting 📝 | Treesitter support 🌳**

## 📜 About

**love2d-treesitter.nvim** is a comprehensive plugin for [Neovim](https://neovim.io/) that highlight [LÖVE](http://love2d.org) syntax in your editor.

- 🎨 **Syntax Highlighting** — Colors LÖVE functions, modules, types, and callbacks
- 🌳 **Treesitter Support** — Full integration with Neovim's Treesitter
- 🔧 **Customizable** — Flexible styling options

<!-- TOC -->

## Table of Contents

- [🚀 Features](#-features)
  - [✨ Highlighting](#-highlighting)
- [📦 Installation](#-installation)
- [📍 Default settings](#-default-settings)
- [💻 Commands](#-commands)
- [❓ Plugin Help](#-plugin-help)
- [🔄 Rebuilding the API](#-rebuilding-the-api)
  - [🤖 Automated Workflow](#-automated-workflow)
  - [✋ Manual Generation (Optional)](#-manual-generation-optional)
- [🎨 Screenshots](#-screenshots)
- [🚨 Known limitation](#-known-limitation)
- [📚 References & Related Projects](#-references--related-projects)
- [🙏 Credits](#-credits)
- [📄 License](#-license)

<!-- /TOC -->

## 🚀 Features

### ✨ Highlighting

<div align="center">
  <img src="https://raw.githubusercontent.com/yorik1984/love2d-treesitter.nvim/main/pics/highlight-feat.png" alt="Highlight error" width="80%">
  <br>
</div>

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
---@field auto_detect_love2d boolean Whether to automatically detect LÖVE projects. Requires installed https://github.com/S1M0N38/love2d.nvim
---@field notifications boolean Whether to enable notifications
---@field style LoveTreesitterStyle Custom font styles (supports combinations like "bold,italic")
---@field colors LoveTreesitterColors Optional table to override default HEX colors

---@class LoveTreesitterConceal
---@field love string|false Character to conceal the `love` global variable. Set to `false` to disable. Defaults to `false`
---@field love_dot string|false Character to conceal the dot operator (e.g., ".") after `love.` . Set to `false` to disable. Defaults to `false`
require("love2d-treesitter").setup({
    enable_on_start    = false,
    auto_detect_love2d = true, -- requires installed https://github.com/S1M0N38/love2d.nvim
    notifications      = false,
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
    conceal = {
        love     = false,       -- `love = ""` or `love = "🩷"`
        love_dot = false,       -- empty `""`
    },
})
```
>[!NOTE]
> `:help 'conceallevel'` for more details. <br>
> `config.conceal` replaces the word `love` and the following dot with a symbol for visual convenience. Does not affect the code in any way. <bf>
> Controls the conceal level for open Lua file windows. Can be managed individually for each window using the editor's built-in commands. However, when using the plugin commands, it switches all windows to the same mode. <br>
> See [💻 Commands](#-commands).


> [!TIP]
> Add configuration for enhanced LÖVE development with  built-in API docs and LÖVE-specific features <br>
> See more in [📚 References & Related Projects](#-references--related-projects) and [love2d-snippets example settings](https://github.com/yorik1984/love2d-snippets/wiki#example-settings)

```lua
require("lazy").setup(
{
    "yorik1984/love2d-treesitter.nvim",
    -- All dependencies are optional
    dependencies = {
        {
            -- LÖVE VS Code-compatible snippet                "yorik1984/love2d-snippets",
            "yorik1984/love2d-snippets",
            branch = "main", -- default or `branch = "11.5"` for special API version
            ft = "lua",
            dependencies = "L3MON4D3/LuaSnip",
            config = function()
                require("luasnip.loaders.from_vscode").lazy_load()
            end
        },
        {
            -- Built-in LÖVE documentation
            "yorik1984/love2d-docs.nvim"
        },
        {
            -- A simple Neovim plugin to build games with LÖVE
            "S1M0N38/love2d.nvim",
            -- optional: add custom definitions
            -- Disable automatic LSP configuration by this plugin
            -- NOTE: You will need to manually configure lua_ls (Lua Language Server)
            -- Example:
            -- Lua = {
            --     runtime = { version = "LuaJIT" },
            --     diagnostics = { disable = { "duplicate-set-field" } },
            --     workspace = { checkThirdParty = false },
            -- },
            ft = "lua",
            opts = {
                lsp = false
            },
            dependencies = {
                {
                    "folke/lazydev.nvim",
                    ft = "lua",
                    dependencies = { "yorik1984/love2d-definitions", "LuaCATS/luasocket" },
                    opts = {
                        library = {
                            {
                                path = vim.fn.stdpath("data") .. "/lazy/love2d-definitions/library",
                                files = { "main.lua", "conf.lua" },
                            },
                            {
                                path = vim.fn.stdpath("data") .. "/lazy/luasocket/library",
                                words = { "socket", "http", "url", "ftp", "smtp" },
                            },
                        },
                    }
                },
            },
        },
    },
    ft = "lua",
    opts = {
        enable_on_start = false,
        auto_detect_love2d = true, -- requires installed https://github.com/S1M0N38/love2d.nvim or set to `false`
        ...
    },
}
)
```

#### Treesitter Highlight Groups

Configure Treesitter styles using the following defaults:

| Highlight Group                       | HEX Color | Color Variable | Style  |
| ------------------------------------- | --------- | -------------- | ------ |
| `@variable.global.love.lua`           | `#E54D95` | `LOVElove`     | `bold` |
| `@module.bulitin.love.lua`            | `#E54D95` | `LOVEmodule`   | `NONE` |
| `@type.love.lua`                      | `#E54D95` | `LOVEtype`     | `NONE` |
| `@punctuation.dot.love.lua`           | `#E54D95` | `LOVEdot`      | `NONE` |
| `@function.love.lua`                  | `#2FA8DC` | `LOVEfunction` | `NONE` |
| `@function.method.love.lua`           | `#2FA8DC` | `LOVEmethod`   | `NONE` |
| `@function.call.love.callback.lua`    | `#2FA8DC` | `LOVEcallback` | `NONE` |
| `@function.call.love.conf.lua`        | `#2FA8DC` | `LOVEconf`     | `NONE` |
| `@function.call.love.conf.module.lua` | `#2FA8DC` | `LOVEconf`     | `NONE` |

## 💻 Commands

The plugin provides the following user commands to manage highlighting and conceal states.

| Command                 | Description                                            |
| ----------------------- | ------------------------------------------------------ |
| `:LOVEHighlightDisable` | **Disables** LÖVE highlighting and conceal. Resets colors.      |
| `:LOVEHighlightEnable`  | **Enables** LÖVE highlighting and conceal for the current session. |
| `:LOVEHighlightToggle`  | **Toggles** the highlighting and conceal state (On/Off).           |

#### Recommended Keybindings

Example configuration with [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    "yorik1984/love2d-treesitter",
    keys = {
        { "<leader>Lhd", "<cmd>LOVEHighlightDisable<cr>", ft = "lua", desc = "LÖVE Highlights Disable" },
        { "<leader>Lhe", "<cmd>LOVEHighlightEnable<cr>",  ft = "lua", desc = "LÖVE Highlights Enable " },
        { "<leader>Lht", "<cmd>LOVEHighlightToggle<cr>",  ft = "lua", desc = "LÖVE Highlights Toggle " },
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

## 🚨 Known limitation

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

+ **[love2d-snippets](https://github.com/yorik1984/love2d-snippets)** <br>
    A snippet generator and collection for the LÖVE framework, compatible with VS Code, Neovim (via LuaSnip), and any editor that supports VS Code-style snippets.
    *   **🤖 Automated Updates:** GitHub Actions parses the official love-api and generates up-to-date snippets whenever the API changes.
    *   **📦 Full API Coverage:** Includes snippets for all modules, functions, callbacks, type methods, constructors, getters/setters, enums, and `conf.lua`.
    *   **⌨️ Tabs for Indentation:** Uses tab characters (`\t`) for indentation, allowing each developer to configure their preferred display width (2, 4, 8 spaces, etc.) without changing the actual files.
    *   **📌 Version Branches:** Repository branches match LÖVE versions (e.g., branch `11.5` for LÖVE 11.5), while the `main` branch always contains the latest API.

+ **[love2d-definitions](https://github.com/yorik1984/love2d-definitions)** <br>
    [LuaCATS](https://luals.github.io/wiki/annotations/) definition for [LÖVE](https://love2d.org/) framework.
    Creates `---@class` and `---@alias` definitions for perfect autocompletion and type checking in IDEs with LuaCATS.
    - **🤖 Automated Updates:** Uses GitHub Actions to stay in sync with the official love-api, just like this plugin.
    - **📦 Ready-to-Use:** Provides a pre-generated `library/` folder that you can directly add to your workspace library.
    - **🧠 Smart Type System:** Intelligently handles type unions, plural forms (e.g., `tables` → `table[]`), optional parameters, and function overloads.
    - **📌 Version Branches:** Includes branches for specific LÖVE versions (e.g., `11.5`), so you can use annotations that match your project.

> [!TIP]
> Use **love2d-definitions** and **love2d-snippets** alongside **love2d-treesitter** for the ultimate LÖVE development setup — get beautiful syntax highlighting in your editor and intelligent IDE autocompletion from these LuaCATS annotations.

+ **[love2d-docs.nvim](https://github.com/yorik1984/love2d-docs.nvim)** <br>
    Is a comprehensive plugin for [Neovim](https://neovim.io/) and [Vim](https://www.vim.org/) that brings the entire [LÖVE](http://love2d.org) game framework documentation right into your editor.
    - 📖 **Built-in Help** — Complete LÖVE API documentation accessible via `:help LOVE-*`

+ **[love2d-vim-syntax](https://github.com/yorik1984/love2d-vim-syntax)** <br>
    Plugin for [Vim](https://www.vim.org/) that highlight [LÖVE](http://love2d.org) syntax in your editor.
    - 🎨 **Syntax Highlighting** — Colors LÖVE functions, modules, types, and callbacks
    - 🔧 **Customizable** — Flexible styling options for Vim

## 🙏 Credits

+ Original Author: [Davis Claiborne](https://github.com/davisdude) — Created and maintained the original [vim-love-docs](https://github.com/davisdude/vim-love-docs)
+ Powered by: [love-api](https://github.com/love2d-community/love-api) — Community-maintained LÖVE API specification

## 📄 License

This project is licensed under the [MIT License](LICENSE) - see the [LICENSE](LICENSE) file for details.

<div align="center">
  <sub>
    Built with ♡ for the LÖVE community
    <br>
    <a href="https://github.com/yorik1984/love2d-treesitter/issues">Report Issue</a> •
    <a href="https://github.com/yorik1984/love2d-treesitter/discussions">Discussion</a> •
    <a href="https://love2d.org/">LÖVE</a>
  </sub>
</div>
