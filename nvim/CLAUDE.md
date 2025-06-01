# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Neovim configuration based on LazyVim, a modern Neovim starter template. The configuration uses the Lazy.nvim plugin manager and includes various language support and development tools.

## Architecture

- **Entry Point**: `init.lua` bootstraps the entire configuration by requiring `config.lazy`
- **Plugin Management**: All plugins are managed through Lazy.nvim with specs defined in `lua/plugins/`
- **Configuration Structure**:
  - `lua/config/` - Core LazyVim configuration overrides (keymaps, options, autocmds)
  - `lua/plugins/` - Custom plugin configurations that extend or override LazyVim defaults
  - LazyVim extras are enabled via `lazyvim.json` for language support and additional features

## Key Configuration Details

- **Color Scheme**: Currently using Kanagawa Wave theme (switched from Catppuccin)
- **Disabled Plugins**: Bufferline and mini.pairs are explicitly disabled in `lua/plugins/disabled.lua`
- **LazyVim Extras**: Configured for TypeScript, Elixir, Docker, Markdown, Tailwind, and other languages
- **Code Formatting**: StyLua is configured with 2-space indentation and 240 column width

## Commands

- **Format Lua Code**: `stylua .` (uses settings from `stylua.toml`)
- **Plugin Management**: Use `:Lazy` in Neovim to manage plugins
- **Plugin Updates**: LazyVim has automatic update checking enabled

## Plugin Structure

Custom plugins in `lua/plugins/` follow LazyVim's plugin spec format. Each file should return a table or array of plugin specifications. The configuration automatically imports all plugins from this directory.

## Notes

- Plugin lazy-loading is disabled by default for custom plugins
- The configuration uses system clipboard integration (`unnamedplus`)
- Performance optimizations disable several unused RTP plugins