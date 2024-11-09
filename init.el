;; -*- lexical-binding: t -*-
;;(setq debug-on-error t)


;;(package-initialize)

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(setq exec-path (cons "/usr/local/bin" exec-path))

(require 'init-utils)
(require 'init-elpa)
(require 'init-kuma)
(require 'init-themes)
(require 'init-ivy)
(require 'init-lsp)
;;(require 'init-term)
;;(require 'init-csv)
;; (require 'init-dired)
;;(require 'init-docker)
;; (require 'init-company)
(require 'init-python)
;; (require 'init-flycheck)
;; (require 'init-flyspell)
(require 'init-org)
;; ;;(require 'init-session)
;; (require 'init-ibuffer)
(require 'init-exec-path)
(require 'init-lua)
;;(add-to-list 'load-path (expand-file-name "leetcode.el" "/Users/byronwang/Documents/lisp-project"))
;;(require 'leetcode)
;;(require 'init-ivypos)
;; (require 'init-markdown)
;; ;;(require 'init-mu4e)
;; (require 'init-yasnippet)
;; (require 'init-erc)
;; (require 'init-jenkins)
;; (require 'init-org-export)
;;(require 'init-dev)
(provide 'init)
;;(put 'downcase-region 'disabled nil)



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(sanityinc-tomorrow-bright))
 '(custom-safe-themes
   '("b11edd2e0f97a0a7d5e66a9b82091b44431401ac394478beb44389cf54e6db28" "1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" default))
 '(package-selected-packages
   '(lua-mode exec-path-from-shell org-pomodoro writeroom-mode org-cliplink grab-mac-link company-anaconda anaconda-mode pip-requirements ivy-xref swiper projectile diminish counsel ivy-historian ivy dimmer color-theme-sanityinc-tomorrow color-theme-sanityinc-solarized gnu-elpa-keyring-update fullframe seq ledger-mode yaml-mode python-mode lsp-pyright company-go window-number htmlize window-numbering json-mode smex transient tablist ivy-posframe elpy nginx-mode docker-compose-mode dockerfile-mode protobuf-mode py-autopep8 flycheck company-jedi lsp-mode go-guru ag helm-ag go-mode magit-popup magit))
 '(python-shell-interpreter "/usr/bin/python3"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
