;; -*- lexical-binding: t -*-
;;; init-lsp.el --- LSP configuration -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(setq read-process-output-max (* 1024 1024)
      lsp-diagnostics-provider :flymake)

(use-package go-mode
  :ensure t
  :mode "\\.go\\'")

(use-package yaml-mode
  :ensure t
  :mode "\\.ya?ml\\'")

;; LSP Mode - 核心配置
(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :hook (((go-mode go-ts-mode) . lsp-deferred)
         (lsp-mode . lsp-enable-which-key-integration))
  :config
  ;; gopls 配置
  (lsp-register-custom-settings
   '(("gopls.completeUnimported" t t)
     ("gopls.staticcheck" t t))))

;; LSP UI - 提供更好的界面
(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)

;; Which-key - 显示快捷键提示
(use-package which-key
  :ensure nil
  :config (which-key-mode))

;; Consult-lsp - LSP 与 consult 集成
(use-package consult-lsp
  :ensure t
  :after (lsp-mode consult))

;; Install saving hooks only in buffers with an active LSP workspace.
(defun byron/lsp-go-before-save ()
  "Organize imports and format Go when the language server is ready."
  (when (and (bound-and-true-p lsp-managed-mode) (lsp-workspaces))
    (when (lsp-feature? "textDocument/codeAction")
      (lsp-organize-imports))
    (when (lsp-feature? "textDocument/formatting")
      (lsp-format-buffer))))

(defun lsp-go-install-save-hooks ()
  "Keep the Go save hook in sync with LSP management."
  (when (derived-mode-p 'go-mode 'go-ts-mode)
    (if (bound-and-true-p lsp-managed-mode)
        (add-hook 'before-save-hook #'byron/lsp-go-before-save nil t)
      (remove-hook 'before-save-hook #'byron/lsp-go-before-save t))))
(add-hook 'lsp-managed-mode-hook #'lsp-go-install-save-hooks)

(provide 'init-lsp)
