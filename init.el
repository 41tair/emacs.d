;; -*- lexical-binding: t -*-
(setq debug-on-error t)


(package-initialize)

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(setq exec-path (cons "/usr/local/bin" exec-path))


(require 'init-utils)
(require 'init-elpa)
(require 'init-kuma)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (magit sr-speedbar fullframe))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
