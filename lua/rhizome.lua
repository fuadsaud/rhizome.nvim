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
local a, string = autoload("aniseed.core"), autoload("aniseed.string")
do end (_2amodule_locals_2a)["a"] = a
_2amodule_locals_2a["string"] = string
local _2aconfig_2a
local function _1_(root)
  return a.last(string.split(root.path, "/"))
end
_2aconfig_2a = {roots = {}, default_label_fn = _1_}
local function known_roots()
  return (_2aconfig_2a).roots
end
_2amodule_2a["known_roots"] = known_roots
local function default_label(root)
  return (_2aconfig_2a).default_label_fn(root)
end
local function normalize_path(path)
  return vim.fn.resolve(vim.fn.expand(path))
end
local function path_match_3f(path_a, path_b)
  return (normalize_path(path_a) == normalize_path(path_b))
end
local function find_in_known_roots(known_roots0, input_path)
  local function _2_(root)
    return path_match_3f(root.path, input_path)
  end
  return a.first(a.filter(_2_, known_roots0))
end
local function derive_root_2a(known_roots0, input_path)
  return (find_in_known_roots(known_roots0, input_path) or {path = input_path})
end
local function derive_root(input_path)
  return derive_root_2a((_2aconfig_2a).roots, input_path)
end
local function open2(cwd, callback)
  vim.cmd({cmd = "tcd", args = {cwd}})
  return callback()
end
local function open_entrypoint(cmd, root)
  if root.entrypoint then
    return vim.cmd({cmd = cmd, args = {string.join("/", {root.path, root.entrypoint})}})
  else
    return vim.cmd({cmd = "Telescope", args = {"find_files"}})
  end
end
local function open(cmd, cwd, entrypoint)
  vim.cmd({cmd = cmd, args = {entrypoint}})
  return vim.cmd({cmd = "tcd", args = {cwd}})
end
local function open_root(cmd, root)
  local function _4_()
    return open_entrypoint(cmd, root)
  end
  return open2(root.path, _4_)
end
local function label_for_root(root)
  return (root.label or default_label(root))
end
_2amodule_2a["label_for_root"] = label_for_root
local function label_2a(input_path)
  return label_for_root(derive_root(input_path))
end
local function label_for_tabnr(tabnr)
  return label_2a(vim.fn.getcwd(-1, tabnr))
end
_2amodule_2a["label_for_tabnr"] = label_for_tabnr
local function open_in_current_tab(input_path)
  return open_root("edit", derive_root(input_path))
end
_2amodule_2a["open_in_current_tab"] = open_in_current_tab
local function open_in_new_tab(input_path)
  return open_root("tabedit", derive_root(input_path))
end
_2amodule_2a["open_in_new_tab"] = open_in_new_tab
local function setup(opts)
  return a["merge!"](_2aconfig_2a, opts)
end
_2amodule_2a["setup"] = setup
--[[ (setup {:roots [{:path "~/Source/fuadsaud/Monrovia"}
         {:path "~/Source/fuadsaud/fuadsaud.github.io"}
         {:path "~/.ditmas"}
         {:path "~/.config/nvim"}
         {:entrypoint ".zshrc" :path "~/.config/zsh"}]}) (. *config* "roots") (local zsh_path "/Users/fuad/.config/zsh") (local zsh_root (derive_root zsh_path)) (label* zsh_path) (open_in_new_tab zsh_path) ]]
return _2amodule_2a