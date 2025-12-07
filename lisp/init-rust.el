;; -*- lexical-binding: t -*-
;;; init-rust.el --- Rust configuration -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(use-package rust-mode
  :ensure t
  :mode "\\.rs\\'"
  :hook (rust-mode . lsp-deferred)
  :config
  (setq rust-format-on-save t))

;; rust-analyzer 配置
(with-eval-after-load 'lsp-mode
  (setq lsp-rust-server 'rust-analyzer))

(provide 'init-rust)
;;; init-rust.el ends here
