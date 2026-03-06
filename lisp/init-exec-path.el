;; -*- lexical-binding: t -*-
;;; init-exec-path.el --- PATH configuration -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(require-package 'exec-path-from-shell)

(after-load 'exec-path-from-shell
  (dolist (var '("SSH_AUTH_SOCK" "SSH_AGENT_PID" "GPG_AGENT_INFO" "LANG" "LC_CTYPE"))
    (add-to-list 'exec-path-from-shell-variables var)))

(defun byron/import-login-shell-env ()
  "Import all environment variables from the user's login shell."
  (let ((shell (or (getenv "SHELL") shell-file-name))
        env-output)
    (when shell
      (with-temp-buffer
        (when (eq 0 (call-process shell nil t nil "-lc" "env"))
          (setq env-output (buffer-string)))))
    (when env-output
      (dolist (line (split-string env-output "\n" t))
        (when (string-match "\\`\\([^=]+\\)=\\(.*\\)\\'" line)
          (let ((name (match-string 1 line))
                (value (match-string 2 line)))
            (unless (member name '("_" "PWD" "OLDPWD" "SHLVL"))
              (setenv name value)))))
      (let ((path (getenv "PATH")))
        (when path
          (setq exec-path (append (parse-colon-path path)
                                  (list exec-directory))))))))

;; (when (memq window-system '(mac ns x))
;;   (exec-path-from-shell-initialize))
;; (exec-path-from-shell-copy-envs '("GOPATH" "LANG" "GPG_AGENT_INFO" "SSH_AUTH_SOCK"))
(when (and (or (memq window-system '(mac ns))
               (daemonp))
           (require 'exec-path-from-shell nil t))
  ;; (setq exec-path-from-shell-debug t)
  (exec-path-from-shell-initialize)
  (byron/import-login-shell-env)
  (message "Initialized PATH and environment from login shell."))

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
