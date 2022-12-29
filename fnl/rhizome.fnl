(module rhizome
  {autoload {a aniseed.core
             pickers telescope.pickers
             finders telescope.finders
             actions telescope.actions
             action_state telescope.actions.state
             config telescope.config}})

(local *config* {:roots []
                 :telescope_options {}})

(defn known_roots []
  (. *config* :roots))

(fn normalize_path
  [path]
  (-> path
      vim.fn.expand
      vim.fn.resolve))

(fn path_match?
  [path_a path_b]
  (= (normalize_path path_a)
     (normalize_path path_b)))

(fn find_in_known_roots
  [known_roots input_path]
  (a.first (a.filter (fn [root] (path_match? root.path input_path)) known_roots)))

(fn derive_root
  [known_roots input_path]
  (or (find_in_known_roots known_roots input_path)
      {:path input_path}))

(fn open
  [cmd cwd entrypoint]
  (vim.cmd {:cmd cmd :args [entrypoint]})
  (vim.cmd {:cmd :tcd :args [cwd]}))

(fn open_root
  [cmd root]
  (open cmd (. root :path) (or (a.str (. root :path) "/" (. root :entrypoint))
                               (. root :path))))

(defn open_in_current_tab
  [input_path]
  (open_root :edit (derive_root (. *config* :roots) input_path)))

(defn open_in_new_tab
  [input_path]
  (open_root :tabedit (derive_root (. *config* :roots) input_path)))

(defn setup
  [{:roots roots
    :telescope_options telescope_options}]
  (tset *config* :roots roots)
  (tset *config* :telescope_options telescope_options))

(comment
  (local zsh_path "/Users/fuad/.config/zsh")
  (derive_root (. *config* :roots) zsh_path)
  (setup {:roots [{:path "~/Source/fuadsaud/Monrovia"}
                  {:path "~/Source/fuadsaud/fuadsaud.github.io"}
                  {:path "~/.ditmas"}
                  {:path "~/.config/nvim"}
                  {:path "~/.config/zsh" :entrypoint ".zshrc"}]})
  (open_in_new_tab zsh_path))
