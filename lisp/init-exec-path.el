;; -*- lexical-binding: t -*-
;;; init-exec-path.el --- PATH configuration -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(require-package 'exec-path-from-shell)

(after-load 'exec-path-from-shell
  (dolist (var '("SSH_AUTH_SOCK" "SSH_AGENT_PID" "GPG_AGENT_INFO" "LANG" "LC_CTYPE"))
    (add-to-list 'exec-path-from-shell-variables var)))


;; (when (memq window-system '(mac ns x))
;;   (exec-path-from-shell-initialize))
;; (exec-path-from-shell-copy-envs '("GOPATH" "LANG" "GPG_AGENT_INFO" "SSH_AUTH_SOCK"))
(when (and (or (memq window-system '(mac ns))
               (daemonp))
           (require 'exec-path-from-shell nil t))
  ;; (setq exec-path-from-shell-debug t)
  (exec-path-from-shell-initialize)
  (exec-path-from-shell-copy-envs '("LANG" "GPG_AGENT_INFO" "SSH_AUTH_SOCK" "GOPATH" "GOBIN" "GOMODCACHE" "GOPROXY"))
  (message "Initialized PATH and other variables from SHELL."))

;; Add Go bin directory to exec-path for gopls and other Go tools
(let ((gopath (or (getenv "GOPATH") (expand-file-name "~/Documents/go"))))
  (unless (getenv "GOPATH")
    (setenv "GOPATH" gopath))
  (unless (getenv "GOMODCACHE")
    (setenv "GOMODCACHE" (expand-file-name "pkg/mod" gopath)))
  (unless (getenv "GOPROXY")
    (setenv "GOPROXY" "https://goproxy.cn,direct"))
  (let ((gobin (or (getenv "GOBIN") (expand-file-name "bin" gopath))))
    (when (file-directory-p gobin)
      (add-to-list 'exec-path gobin)
      (setenv "PATH" (concat gobin ":" (getenv "PATH"))))))

(setq exec-path-from-shell-check-startup-files nil) 
(provide 'init-exec-path)
;;; init-exec-path.el ends here
