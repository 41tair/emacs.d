(require-package 'exec-path-from-shell)

(after-load 'exec-path-from-shell
  (dolist (var '("SSH_AUTH_SOCK" "SSH_AGENT_PID" "GPG_AGENT_INFO" "LANG" "LC_CTYPE"))
    (add-to-list 'exec-path-from-shell-variables var)))

(exec-path-from-shell-copy-env "EMACS_JENKINS_API_TOKEN")
(exec-path-from-shell-copy-env "EMACS_JENKINS_URL")
(exec-path-from-shell-copy-env "EMACS_JENKINS_USERNAME")


;; (when (memq window-system '(mac ns x))
;;   (exec-path-from-shell-initialize))
;; (exec-path-from-shell-copy-envs '("GOPATH" "LANG" "GPG_AGENT_INFO" "SSH_AUTH_SOCK"))
(when (and (memq window-system '(mac ns))
           (require 'exec-path-from-shell nil t))
  ;; (setq exec-path-from-shell-debug t)
  (exec-path-from-shell-initialize)
  (exec-path-from-shell-copy-envs '("LANG" "GPG_AGENT_INFO" "SSH_AUTH_SOCK" "GOPATH"))
  (message "Initialized PATH and other variables from SHELL."))

(when (eq system-type 'darwin)
  (add-to-list 'load-path "/usr/local/Cellar/mu/HEAD/share/emacs/site-lisp/mu4e"))

(setq exec-path-from-shell-check-startup-files nil) 
(provide 'init-exec-path)
