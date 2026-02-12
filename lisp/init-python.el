;; -*- lexical-binding: t -*-
;;; init-python.el --- Python configuration -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(use-package lsp-pyright
  :ensure t
  :custom (lsp-pyright-langserver-command "pyright") ;; or basedpyright
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp-deferred))))

(add-hook 'python-mode-hook 'py-autopep8-mode)
(setq py-autopep8-options '("--max-line-length=120"))

(setq auto-mode-alist
      (append '(("SConstruct\\'" . python-mode)
                ("SConscript\\'" . python-mode))
              auto-mode-alist))


(provide 'init-python)
;;; init-python.el ends here
