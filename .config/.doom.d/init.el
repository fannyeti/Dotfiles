(doom! :completion
       company
       (vertico +orderless +icons)

       :ui
       hydra
       doom
       doom-dashboard
       indent-guides
       modeline
       nav-flash
       ophints
       (popup +defaults)
       vc-gutter
       zen

       :editor
       (evil +everywhere)
       fold
       (format +onsave)
       snippets

       :emacs
       dired
       ibuffer
       electric
       vc

       :checkers
       (syntax +childframe)
       ;; spell

       :tools
       biblio
       (debugger +lsp)
       direnv
       (eval +overlay)
       (lookup +docsets +dictionary)
       lsp

       :lang
       data
       emacs-lisp
       (latex +latexmk)
       markdown
       (org +dnd)
       sh
       web

       :config
       (default +bindings +smartparens))
