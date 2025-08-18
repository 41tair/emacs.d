(require 'package)

;; for eat terminal backend:
(use-package eat :ensure t)

;; install claude-code.el
(use-package claude-code :ensure t
  :vc (:url "https://github.com/stevemolitor/claude-code.el" :rev :newest)
  :config (claude-code-mode)
  :bind-keymap ("C-c c" . claude-code-command-map))


(defun my-claude-notify (title message)
  "Display a macOS notification with sound."
  (call-process "osascript" nil nil nil
                "-e" (format "display notification \"%s\" with title \"%s\" sound name \"zelda-item\""
                             message title)))

(setq claude-code-notification-function #'my-claude-notify)

(defun claude-code-setup-bell-handler ()
  "Set up bell handler for eat terminal after initialization."
  (when (and (bound-and-true-p eat-terminal)
             (claude-code--buffer-p (current-buffer)))
    (setf (eat-term-parameter eat-terminal 'ring-bell-function) #'claude-code--notify)))

;; Add to eat mode hook to ensure bell handler is set up
(add-hook 'eat-mode-hook #'claude-code-setup-bell-handler)


(provide 'init-claude)
