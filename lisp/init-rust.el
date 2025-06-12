(use-package rust-mode
  :ensure t
  :mode "\\.rs\\'"
  :hook (rust-mode . lsp)
  :config
  (setq rust-format-on-save t))

(use-package lsp-mode
  :ensure t
  :hook ((lsp-mode . lsp-enable-which-key-integration)
         (rust-mode . lsp))
  :commands lsp
  :config
  (setq lsp-rust-server 'rust-analyzer)
  )

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)

(use-package company
  :ensure t
  :hook (after-init . global-company-mode))

(use-package which-key
  :ensure t
  :config (which-key-mode))

(use-package consult-lsp
  :ensure t
  :after (lsp-mode consult))

(provide 'init-rust)
