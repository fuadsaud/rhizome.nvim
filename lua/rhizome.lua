local _2afile_2a = "fnl/rhizome.fnl"
local _2amodule_name_2a = "rhizome"
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
local a, action_state, actions, config, finders, pickers = autoload("aniseed.core"), autoload("telescope.actions.state"), autoload("telescope.actions"), autoload("telescope.config"), autoload("telescope.finders"), autoload("telescope.pickers")
do end (_2amodule_locals_2a)["a"] = a
_2amodule_locals_2a["action_state"] = action_state
_2amodule_locals_2a["actions"] = actions
_2amodule_locals_2a["config"] = config
_2amodule_locals_2a["finders"] = finders
_2amodule_locals_2a["pickers"] = pickers
local _2aconfig_2a = {roots = {}, telescope_options = {}}
local function normalize_path(path)
  return vim.fn.resolve(vim.fn.expand(path))
end
local function path_match_3f(path_a, path_b)
  return (normalize_path(path_a) == normalize_path(path_b))
end
local function find_in_known_roots(known_roots, input_path)
  local function _1_(root)
    return path_match_3f(root.path, input_path)
  end
  return a.first(a.filter(_1_, known_roots))
end
local function derive_root(known_roots, input_path)
  return (find_in_known_roots(known_roots, input_path) or {path = input_path})
end
local function open(cmd, cwd, entrypoint)
  vim.cmd({cmd = cmd, args = {entrypoint}})
  return vim.cmd({cmd = "tcd", args = {cwd}})
end
local function open_root(cmd, root)
  return open(cmd, root.path, (a.str(root.path, "/", root.entrypoint) or root.path))
end
local function open_in_current_tab(input_path)
  return open_root("edit", derive_root((_2aconfig_2a).roots, input_path))
end
_2amodule_2a["open_in_current_tab"] = open_in_current_tab
local function open_in_new_tab(input_path)
  return open_root("tabedit", derive_root((_2aconfig_2a).roots, input_path))
end
_2amodule_2a["open_in_new_tab"] = open_in_new_tab
local function open_root_picker()
  local _let_2_ = _2aconfig_2a
  local roots = _let_2_["roots"]
  local telescope_options = _let_2_["telescope_options"]
  local finder
  local function _3_(entry)
    return {value = entry, display = entry.path, ordinal = entry.path}
  end
  finder = finders.new_table({results = roots, entry_maker = _3_})
  local sorter = config.values.generic_sorter(telescope_options)
  local handler
  local function _4_(prompt_bufnr, map)
    local function _5_()
      actions.close(prompt_bufnr)
      local selection = action_state.get_selected_entry()
      return open_in_new_tab(selection.value.path)
    end
    return (actions.select_default):replace(_5_)
  end
  handler = _4_
  local picker = pickers.new(telescope_options, {prompt_title = "Roots", finder = finder, sorter = sorter, attach_mappings = handler})
  return picker:find()
end
_2amodule_2a["open_root_picker"] = open_root_picker
local function setup(_6_)
  local _arg_7_ = _6_
  local roots = _arg_7_["roots"]
  local telescope_options = _arg_7_["telescope_options"]
  _2aconfig_2a["roots"] = roots
  _2aconfig_2a["telescope_options"] = telescope_options
  return nil
end
_2amodule_2a["setup"] = setup
--[[ (local zsh_path "/Users/fuad/.config/zsh") (derive_root (. *config* "roots") zsh_path) (setup {:roots [{:path "~/Source/fuadsaud/Monrovia"}
         {:path "~/Source/fuadsaud/fuadsaud.github.io"}
         {:path "~/.ditmas"}
         {:path "~/.config/nvim"}
         {:entrypoint ".zshrc" :path "~/.config/zsh"}]}) (open_root_picker) (open_in_new_tab zsh_path) ]]
return _2amodule_2a