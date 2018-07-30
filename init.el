;; -*- lexical-binding: t -*-
(setq debug-on-error t)


(package-initialize)

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(setq exec-path (cons "/usr/local/bin" exec-path))


(require 'init-utils)
(require 'init-elpa)
(require 'init-kuma)
(require 'init-term)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (csv-mode ag multi-term magit sr-speedbar fullframe)))
 '(term-default-bg-color "#000000")
 '(term-default-fg-color "#dddd00"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(provide 'init)
