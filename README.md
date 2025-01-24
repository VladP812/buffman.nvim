<h1 align="center">Buffman</h1>

<p>Buffman is a very simple Neovim plugin for switching between and deleting opened buffers. It integrates very well with builtin netrw file explorer and if you are one of those minimalists who likes to keeps things simple, you may find it useful.</p>

<h1 align="center">Installation</h1>

- Using **Packer** - add this to your init.lua (or any other file where you setup packer)
```lua
return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- buffer manager
  use {
    "VladP812/buffman.nvim",
    as = "buffman"
  }
end)
```
- Using **Lazy** - add this to your init.lua (or any other file where you setup lazy)
```lua
require("lazy").setup({
  {
    "VladP812/buffman.nvim",
    as = "buffman"
  }
})
```
- Then, once installed using any plugin manager, you need to bind a keymap to the open function. It can be done in your `remaps.lua` file (or any other file where you setup key bindings) by appending following line:
```lua
vim.keymap.set("n", "<leader>wo", require("buffman").open_buffman) -- defaults to <leader>+w+o
```

<h1 align="center">Usage</h1>

- Once installed you can open the Buffman window with the keymap you specified (more later in [Configuring section](#keymaps)) or if you are using the default one press `Leader+W+O`
- In the opened window you will see a list of filenames which represent currently opened buffers.
- Use `k` and `j` to choose a buffer (simply by moving cursor over it's name).
- To switch to that buffer press `<CR> (return i.e. Enter)`.
- To delete that buffer press `d` (by default). The file will be saved automatically.
- To close Buffman window press `q` or run `:bd` command.

<h1 align="center">Configuring</h1>

Since Buffman's aim is to provide only neccessary functionality and to stay as lightweight as possible, there are a few options to configure.

First of all, create a file called `buffman.lua` in the `after` directory. You can then configure Buffman there. 
But before changing anything we need to retrieve the Buffman table where all the configurable values are stored, 
to do it simply add this one line at the top of your `buffman.lua` file:
```lua
local buffman = require("buffman")
```

All further configuration must be done in the same file. Just keep appending lines in the `buffman.lua` file.

<h3 align="center" id="keymaps">Keymaps</h3>

- Delete selected buffer
```lua
buffman.keymaps.delete_selected_buffer = "d" -- defaults to d
```
- Open selected buffer
```lua
buffman.keymaps.open_selected_buffer = "<CR>" -- defaults to Return i.e. Enter
```
- Quit Buffman
```lua
buffman.keymaps.quit = "q" -- defaults to q
```

<h3 align="center">Config values</h3>

- Show full file paths to files opened in buffers instead of just file names.
```lua
buffman.config.full_buffer_names = false -- defaults to false
```
