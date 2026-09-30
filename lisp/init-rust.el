;; -*- lexical-binding: t -*-
;;; init-rust.el --- Rust configuration -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(use-package rust-mode
  :ensure t
  :mode "\\.rs\\'"
  :hook ((rust-mode rust-ts-mode) . lsp-deferred)
  :config
  (setq rust-format-on-save t))

(autoload 'rust-format-buffer "rust-rustfmt" nil t)
(defun byron/rust-ts-format-on-save ()
  "Preserve rustfmt-on-save when using the built-in Rust mode."
  (when (executable-find "rustfmt")
    (add-hook 'before-save-hook #'rust-format-buffer nil t)))
(add-hook 'rust-ts-mode-hook #'byron/rust-ts-format-on-save)

;; rust-analyzer 配置
(with-eval-after-load 'lsp-mode
  (setq lsp-rust-server 'rust-analyzer))

(provide 'init-rust)
;;; init-rust.el ends here
