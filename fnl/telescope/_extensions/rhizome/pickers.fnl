(local a (require :nfnl.core))
(local rhizome (require :rhizome))
(local pickers (require :telescope.pickers))
(local finders (require :telescope.finders))
(local actions (require :telescope.actions))
(local action_state (require :telescope.actions.state))
(local config (require :telescope.config))

(fn roots [opts]
  (let [roots (rhizome.known_roots)
        finder (finders.new_table {:results roots
                                   :entry_maker (fn [root]
                                                  {:value root
                                                   :display (a.str (rhizome.label_for_root root) " • " (. root :path))
                                                   :ordinal (. root :path)})})
        sorter (config.values.generic_sorter opts)
        handler (fn [prompt_bufnr map]
                  (actions.select_default:replace
                    (fn []
                      (actions.close prompt_bufnr)

                      (let [selection (action_state.get_selected_entry)]
                        (rhizome.open_in_new_tab (. selection :value :path))))))
        picker (pickers.new opts {:prompt_title "Roots"
                                  :finder finder
                                  :sorter sorter
                                  :attach_mappings handler})]
    (picker:find)))

{: roots}
