# rhizome.nvim

This plugin is inspired by [nvim-contabs](https://github.com/m00qek/nvim-contabs).

Rhizome offers some convenience functionalities for using Neovim tabs to work with multiple directories in the same instance.

## Concepts

### Root

A root represents a directory known to rhizome. It's composed of the following attributes:

| Attribute  | Type             | Description                                                                          | Default Value        |
|------------|------------------|--------------------------------------------------------------------------------------|----------------------|
| path       | string, required | the path to the directory                                                            |                      |
| entrypoint | string, optional | the file to be loaded into a buffer when opening the root, relative to the root path | the directory itself |
| label      | string, optional | a description of that directory (e.g. to be displayed in a tabline)                  | the dirname of path  |

Examples:

```lua
{ path = '~/.config/nvim', entrypoint = 'init.lua', label = 'Neovim Config' }
```

### Known Roots

To open a directory in a tab, rhizome only needs a directory path. However, it can be convenient to specify a list of known roots:

* so that you can specify further details such as an entrypoint or a label
* so that rhizome can give you an interactive menu to open tabs with such roots

Known roots can be specified during [setup](#setup).

## Features

### Open a root in the current tab

```lua
require('rhizome').open_in_current_tab('~/.config/nvim')
```

Attempts to find the root matching the given path; if one is not found, a new one is created on-the-fly with the given path and default values for other attributes. Then, sets the working directory for the current tab and opens a new buffer for the entrypoint.

### Open a root in a new tab

```lua
require('rhizome').open_in_new_tab('~/.config/nvim')
```

Attempts to find the root matching the given path; if one is not found, a new one is created on-the-fly with the given path and default values for other attributes. Then, creates a new tab with the working directory set to the root's path and opens a new buffer for the entrypoint.

### Telescope Integration

First you need to load the extension:

```lua
require('telescope').load_extension('rhizome')
```

Then you can run the following command:

```vim
:Telescope rhizome roots
```

Opens a Telescope picker with the list of known roots.

## Setup

```lua
require('rhizome').setup({
  roots = [
    -- project roots
  ],
  default_label_fn = function(root) {
    -- return the desired label for roots that don't specify one
  }
})
```

## Tips

### Tabline Integration

To label for a given tab can be obtained by passing the tabnr to the `label_for_tabnr`:

```lua
require('rhizome').label_for_tabnr(vim.fn.tabpagenr())
```

### Telescope with buffers belonging to the current working directory

```vim
:Telescope buffers only_cwd=true
```

## License

See [LICENSE](./LICENSE).
