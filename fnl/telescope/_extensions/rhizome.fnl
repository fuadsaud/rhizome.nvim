(let [telescope (require :telescope)
      pickers (require :telescope._extensions.rhizome.pickers)]
  (telescope.register_extension {:setup (fn [ext_config config])
                                 :exports {:roots pickers.roots}}))
