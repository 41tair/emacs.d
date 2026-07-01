;; -*- lexical-binding: t -*-
;;; init-python.el --- Python configuration -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(use-package eglot
  :ensure t
  :hook ((python-mode python-ts-mode) . eglot-ensure)
  :config
  (add-to-list 'eglot-server-programs
               '((python-mode python-ts-mode) . ("pyrefly" "lsp"))))

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
