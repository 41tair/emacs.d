;;; init-exec-path.el --- Import the shell environment once -*- lexical-binding: t -*-

(defun byron/import-login-shell-env ()
  "Import exported variables from one interactive login shell.
NUL delimiters preserve multiline values.  A marker discards shell startup
output; values are never logged."
  (let ((shell (or (getenv "SHELL") shell-file-name))
        (marker "\0EMACS_ENV_START\0"))
    (when shell
      (with-temp-buffer
        (if (not (eq 0 (call-process shell nil (list t nil) nil "-lic"
                                    "printf '\\0EMACS_ENV_START\\0'; /usr/bin/env -0")))
            (display-warning 'init "Could not import the login shell environment")
          (goto-char (point-min))
          (unless (search-forward marker nil t)
            (error "Login shell did not produce an environment marker"))
          (dolist (entry (split-string (buffer-substring-no-properties
                                       (point) (point-max)) "\0" t))
            (when (string-match "\\`\\([A-Za-z_][A-Za-z0-9_]*\\)=" entry)
              (let ((name (match-string 1 entry))
                    (value (substring entry (match-end 0))))
                (unless (member name '("_" "PWD" "OLDPWD" "SHLVL"))
                  (setenv name value)))))
          (setq exec-path (append (parse-colon-path (or (getenv "PATH") ""))
                                  (list exec-directory))))))))

(when (or (memq window-system '(mac ns x pgtk)) (daemonp))
  (byron/import-login-shell-env))

;; A shell-provided LIBRARY_PATH must not hide native compiler runtime libraries.
(when (fboundp 'byron/native-compiler-environment)
  (byron/native-compiler-environment))

;; Preserve the existing Go workspace and proxy preferences.
(let ((gopath (or (getenv "GOPATH") (expand-file-name "~/Documents/go"))))
  (unless (getenv "GOPATH") (setenv "GOPATH" gopath))
  (unless (getenv "GOMODCACHE")
    (setenv "GOMODCACHE" (expand-file-name "pkg/mod" gopath)))
  (unless (getenv "GOPROXY") (setenv "GOPROXY" "https://goproxy.cn,direct"))
  (let ((gobin (or (getenv "GOBIN") (expand-file-name "bin" gopath))))
    (when (file-directory-p gobin)
      (add-to-list 'exec-path gobin)
      (setenv "PATH" (mapconcat #'identity
                                (delete-dups (cons gobin (parse-colon-path
                                                         (or (getenv "PATH") ""))))
                                path-separator)))))

(provide 'init-exec-path)
