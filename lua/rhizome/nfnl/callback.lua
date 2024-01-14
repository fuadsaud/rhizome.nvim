-- [nfnl] Compiled from fnl/nfnl/callback.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("rhizome.nfnl.module")
local autoload = _local_1_["autoload"]
local core = autoload("rhizome.nfnl.core")
local fs = autoload("rhizome.nfnl.fs")
local nvim = autoload("rhizome.nfnl.nvim")
local compile = autoload("rhizome.nfnl.compile")
local config = autoload("rhizome.nfnl.config")
local api = autoload("rhizome.nfnl.api")
local notify = autoload("rhizome.nfnl.notify")
local function fennel_buf_write_post_callback_fn(root_dir, cfg)
  local function _2_(ev)
    return compile["into-file"]({["root-dir"] = root_dir, cfg = cfg, path = fs["full-path"](ev.file), source = nvim["get-buf-content-as-string"](ev.buf)})
  end
  return _2_
end
local function fennel_filetype_callback(ev)
  local file_path = fs["full-path"](ev.file)
  if not file_path:find("^%w+://") then
    local file_dir = fs.basename(file_path)
    local _let_3_ = config["find-and-load"](file_dir)
    local config0 = _let_3_["config"]
    local root_dir = _let_3_["root-dir"]
    local cfg = _let_3_["cfg"]
    if config0 then
      if cfg({"verbose"}) then
        notify.info("Found nfnl config, setting up autocmds: ", root_dir)
      else
      end
      vim.api.nvim_create_autocmd({"BufWritePost"}, {group = vim.api.nvim_create_augroup(("nfnl-dir-" .. root_dir), {}), buffer = ev.buf, callback = fennel_buf_write_post_callback_fn(root_dir, cfg)})
      local function _5_(_241)
        return api.dofile(core.first(core.get(_241, "fargs")))
      end
      return vim.api.nvim_buf_create_user_command(ev.buf, "NfnlFile", _5_, {desc = "Run the matching Lua file for this Fennel file from disk. Does not recompile the Lua, you must use nfnl to compile your Fennel to Lua first. Calls nfnl.api/dofile under the hood.", force = true, complete = "file", nargs = "?"})
    else
      return nil
    end
  else
    return nil
  end
end
return {["fennel-filetype-callback"] = fennel_filetype_callback}
