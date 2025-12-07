;; -*- lexical-binding: t -*-
;;; init-lsp.el --- LSP configuration -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; LSP Mode - 核心配置
(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :hook ((go-mode . lsp-deferred)
         (lsp-mode . lsp-enable-which-key-integration))
  :config
  ;; gopls 配置
  (setq lsp-register-custom-settings
        '(("gopls.completeUnimported" t t)
          ("gopls.staticcheck" t t))))

;; LSP UI - 提供更好的界面
(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)

;; Company - 补全框架
(use-package company
  :ensure t
  :hook (after-init . global-company-mode)
  :config
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 1))

;; Which-key - 显示快捷键提示
(use-package which-key
  :ensure t
  :config (which-key-mode))

;; Consult-lsp - LSP 与 consult 集成
(use-package consult-lsp
  :ensure t
  :after (lsp-mode consult))

;; Go mode 保存时格式化
(defun lsp-go-install-save-hooks ()
  "Set up before-save hooks for Go."
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

(provide 'init-lsp)
;;; init-lsp.el ends here
