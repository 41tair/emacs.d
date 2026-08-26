;; -*- lexical-binding: t -*-
;;; init-python.el --- Python configuration -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(use-package lsp-pyright
  :ensure t
  :custom
  (lsp-pyright-langserver-command "pyright")
  :hook
  ((python-mode python-ts-mode)
   . (lambda ()
       (require 'lsp-pyright)
       (lsp-deferred))))

(use-package py-autopep8
  :ensure t
  :hook ((python-mode python-ts-mode) . py-autopep8-mode)
  :custom
  (py-autopep8-options '("--max-line-length=120")))

(setq auto-mode-alist
      (append '(("SConstruct\\'" . python-mode)
                ("SConscript\\'" . python-mode))
              auto-mode-alist))

(provide 'init-python)
;;; init-python.el ends here
