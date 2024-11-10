(use-package lsp-pyright
  :ensure t
  :custom (lsp-pyright-langserver-command "pyright") ;; or basedpyright
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp))))  ; or lsp-deferred

(add-hook 'python-mode-hook 'py-autopep8-mode)
(setq py-autopep8-options '("--max-line-length=120"))

(setq elpy-rpc-virtualenv-path 'current)

(setq auto-mode-alist
      (append '(("SConstruct\\'" . python-mode)
                ("SConscript\\'" . python-mode))
              auto-mode-alist))


(provide 'init-pythonnew)
