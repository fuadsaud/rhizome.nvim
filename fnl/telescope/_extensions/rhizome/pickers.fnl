(module telescope._extensions.rhizome.pickers
  {autoload {a aniseed.core
             rhizome rhizome
             pickers telescope.pickers
             finders telescope.finders
             actions telescope.actions
             action_state telescope.actions.state
             config telescope.config}})

(defn roots [opts]
  (let [roots (rhizome.known_roots)
        finder (finders.new_table {:results roots
                                   :entry_maker (fn [entry]
                                                  {:value entry
                                                   :display (. entry :path)
                                                   :ordinal (. entry :path)})})
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

(comment
  (roots))
