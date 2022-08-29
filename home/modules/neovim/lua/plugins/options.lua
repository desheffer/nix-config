-- Keep cursor position while moving across search matches.
vim.g["asterisk#keeppos"] = 1

-- Set indentation marker character.
vim.g.indent_blankline_char = "▏"

-- Hide indentation marker for certain file types.
vim.g.indent_blankline_filetype_exclude = {"dashboard", "help", "lsp-installer", "NvimTree"}

-- Set the border characters for register picker.
vim.g.registers_window_border = "rounded"

-- Disable default Tmux mappings.
vim.g.tmux_navigator_no_mappings = 1
