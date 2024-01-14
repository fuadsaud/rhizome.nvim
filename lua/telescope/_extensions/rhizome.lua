-- [nfnl] Compiled from fnl/telescope/_extensions/rhizome.fnl by https://github.com/Olical/nfnl, do not edit.
local telescope = require("telescope")
local pickers = require("telescope._extensions.rhizome.pickers")
local function _1_(ext_config, config)
end
return telescope.register_extension({setup = _1_, exports = {roots = pickers.roots}})
