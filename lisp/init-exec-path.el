(require-package 'exec-path-from-shell)

(after-load 'exec-path-from-shell
  (dolist (var '("SSH_AUTH_SOCK" "SSH_AGENT_PID" "GPG_AGENT_INFO" "LANG" "LC_CTYPE"))
    (add-to-list 'exec-path-from-shell-variables var)))


(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))
(exec-path-from-shell-copy-env "GOPATH")

(when (eq system-type 'darwin)
  (add-to-list 'load-path "/usr/local/Cellar/mu/HEAD/share/emacs/site-lisp/mu4e"))
(provide 'init-exec-path)
