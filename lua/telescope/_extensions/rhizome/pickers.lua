-- [nfnl] Compiled from fnl/telescope/_extensions/rhizome/pickers.fnl by https://github.com/Olical/nfnl, do not edit.
local a = require("nfnl.core")
local rhizome = require("rhizome")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local config = require("telescope.config")
local function roots(opts)
  local roots0 = rhizome.known_roots()
  local finder
  local function _1_(root)
    return {value = root, display = a.str(rhizome.label_for_root(root), " \226\128\162 ", root.path), ordinal = root.path}
  end
  finder = finders.new_table({results = roots0, entry_maker = _1_})
  local sorter = config.values.generic_sorter(opts)
  local handler
  local function _2_(prompt_bufnr, map)
    local function _3_()
      actions.close(prompt_bufnr)
      local selection = action_state.get_selected_entry()
      return rhizome.open_in_new_tab(selection.value.path)
    end
    return (actions.select_default):replace(_3_)
  end
  handler = _2_
  local picker = pickers.new(opts, {prompt_title = "Roots", finder = finder, sorter = sorter, attach_mappings = handler})
  return picker:find()
end
return {roots = roots}
