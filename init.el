;; -*- lexical-binding: t -*-
;;(setq debug-on-error t)


(package-initialize)

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(setq exec-path (cons "/usr/local/bin" exec-path))


(require 'init-utils)
(require 'init-elpa)
(require 'init-kuma)
(require 'init-term)
(require 'init-csv)
(require 'init-dired)
(require 'init-docker)
(require 'init-company)
(require 'init-ivy)
(require 'init-python)
(require 'init-flycheck)
(require 'init-flyspell)
(require 'init-org)
;;(require 'init-session)
(require 'init-themes)
(require 'init-jira)
(require 'init-ibuffer)
(require 'init-exec-path)
(require 'init-markdown)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (sanityinc-tomorrow-bright)))
 '(custom-safe-themes
   (quote
    ("1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" default)))
 '(package-selected-packages
   (quote
    (org-jira zenburn-theme undo-tree jedi 0blayout company-jedi flycheck-color-mode-line flycheck company-anaconda anaconda-mode pip-requirements ivy-xref projectile counsel ivy-historian diminish ivy company docker-compose-mode dockerfile-mode docker diff-hl diredfl csv-mode ag multi-term magit sr-speedbar fullframe)))
 '(session-use-package t nil (session))
 '(term-default-bg-color "#000000")
 '(term-default-fg-color "#dddd00"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(provide 'init)
(put 'downcase-region 'disabled nil)

