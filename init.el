;; -*- lexical-binding: t -*-
;;(setq debug-on-error t)


;;(package-initialize)

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(setq exec-path (append (list (expand-file-name "~/.cargo/bin")
                              "/usr/local/bin")
                        exec-path))

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
(require 'init-ibuffer)
(require 'init-exec-path)
(require 'init-lua)
(require 'init-rust)
;;(add-to-list 'load-path (expand-file-name "leetcode.el" "/Users/byronwang/Documents/lisp-project"))
;;(require 'leetcode)
;;(require 'init-ivypos)
;; (require 'init-markdown)
;; ;;(require 'init-mu4e)
;; (require 'init-yasnippet)
;; (require 'init-erc)
;; (require 'init-org-export)
;;(require 'init-dev)
(require 'init-claude)
(provide 'init)
;;(put 'downcase-region 'disabled nil)



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(sanityinc-tomorrow-bright))
 '(custom-safe-themes
   '("b11edd2e0f97a0a7d5e66a9b82091b44431401ac394478beb44389cf54e6db28"
     "1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e"
     default))
 '(package-selected-packages
   '(ag color-theme-sanityinc-solarized color-theme-sanityinc-tomorrow
	counsel diminish dimmer dockerfile-mode exec-path-from-shell
	fullframe gnu-elpa-keyring-update go-mode grab-mac-link
	ibuffer-vc ivy ivy-historian ivy-xref lua-mode magit
	org-cliplink org-pomodoro pest-mode projectile py-autopep8
	python-mode seq swiper writeroom-mode yaml-mode))
 '(package-vc-selected-packages
   '((claude-code :url "https://github.com/stevemolitor/claude-code.el")))
 '(python-shell-interpreter "/usr/bin/python3"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'erase-buffer 'disabled nil)
