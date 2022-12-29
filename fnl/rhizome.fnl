(module rhizome
  {autoload {a aniseed.core
             string aniseed.string}})

(local *config* {:roots []
                 :default_label_fn (fn [root]
                                     (a.last (string.split (. root :path) "/")))})

(defn known_roots []
  (. *config* :roots))

(fn default_label [root]
  ((. *config* :deafult_label_fn) root))

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

(fn derive_root*
  [known_roots input_path]
  (or (find_in_known_roots known_roots input_path)
      {:path input_path}))

(fn derive_root
  [input_path]
  (derive_root* (. *config* :roots) input_path))

(fn open
  [cmd cwd entrypoint]
  (vim.cmd {:cmd cmd :args [entrypoint]})
  (vim.cmd {:cmd :tcd :args [cwd]}))

(fn open_root
  [cmd root]
  (open cmd (. root :path) (or (string.join "/" [(. root :path) (. root :entrypoint)])
                               (. root :path))))

(defn label_for_root [root]
  (or (. root :label)
      (default_label root)))

(fn label* [input_path]
  (label_for_root (derive_root input_path)))

(defn label_for_tabnr [tabnr]
  (label* (vim.fn.getcwd -1 tabnr)))

(defn open_in_current_tab
  [input_path]
  (open_root :edit (derive_root input_path)))

(defn open_in_new_tab
  [input_path]
  (open_root :tabedit (derive_root input_path)))

(defn setup
  [opts]
  (a.merge! *config* opts))

(comment
  (setup {:roots [{:path "~/Source/fuadsaud/Monrovia"}
                  {:path "~/Source/fuadsaud/fuadsaud.github.io"}
                  {:path "~/.ditmas"}
                  {:path "~/.config/nvim"}
                  {:path "~/.config/zsh" :entrypoint ".zshrc"}]})
  (. *config* :roots)
  (local zsh_path "/Users/fuad/.config/zsh")
  (local zsh_root (derive_root zsh_path))
  (label* zsh_path)
  (open_in_new_tab zsh_path))
