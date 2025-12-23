;; -*- lexical-binding: t -*-
;;(setq debug-on-error t)


;;(package-initialize)

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(setq exec-path (append (list (expand-file-name "~/.cargo/bin")
                              "/usr/local/bin")
                        exec-path))

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(require 'init-utils)
(require 'init-elpa)
(require 'init-exec-path)
(require 'init-kuma)
(require 'init-themes)
(require 'init-ivy)
(require 'init-lsp)
(require 'init-term)
(require 'init-python)
(require 'init-org)
(require 'init-ibuffer)
(require 'init-lua)
(require 'init-rust)
(require 'init-yasnippet)
(require 'init-flow)

(when (file-exists-p custom-file)
  (load custom-file))

(provide 'init)
