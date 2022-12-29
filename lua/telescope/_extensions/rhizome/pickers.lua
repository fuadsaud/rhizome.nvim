local _2afile_2a = "fnl/telescope/_extensions/rhizome/pickers.fnl"
local _2amodule_name_2a = "telescope._extensions.rhizome.pickers"
local _2amodule_2a
do
  package.loaded[_2amodule_name_2a] = {}
  _2amodule_2a = package.loaded[_2amodule_name_2a]
end
local _2amodule_locals_2a
do
  _2amodule_2a["aniseed/locals"] = {}
  _2amodule_locals_2a = (_2amodule_2a)["aniseed/locals"]
end
local autoload = (require("aniseed.autoload")).autoload
local a, action_state, actions, config, finders, pickers, rhizome = autoload("aniseed.core"), autoload("telescope.actions.state"), autoload("telescope.actions"), autoload("telescope.config"), autoload("telescope.finders"), autoload("telescope.pickers"), autoload("rhizome")
do end (_2amodule_locals_2a)["a"] = a
_2amodule_locals_2a["action_state"] = action_state
_2amodule_locals_2a["actions"] = actions
_2amodule_locals_2a["config"] = config
_2amodule_locals_2a["finders"] = finders
_2amodule_locals_2a["pickers"] = pickers
_2amodule_locals_2a["rhizome"] = rhizome
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
_2amodule_2a["roots"] = roots
--[[ (roots) ]]
return _2amodule_2a