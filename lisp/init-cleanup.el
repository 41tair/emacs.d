;;; init-cleanup.el --- Reclaim hidden, exited terminals -*- lexical-binding: t -*-

(defgroup byron-cleanup nil "Terminal buffer cleanup." :group 'convenience)
(defcustom byron-vterm-cleanup-delay 3600
  "Seconds an exited terminal must remain hidden before cleanup."
  :type 'natnum :group 'byron-cleanup)
(defcustom byron-vterm-cleanup-interval 1800
  "Seconds between terminal cleanup checks."
  :type 'natnum :group 'byron-cleanup)

(defvar-local byron-vterm-hidden-since nil
  "Time this terminal became hidden, or nil while displayed.")
(defvar byron-vterm-cleanup-timer nil)

(defun byron-vterm-track-visibility (&optional _frame)
  "Update terminal visibility after a window change."
  (let ((now (current-time)))
    (dolist (buffer (buffer-list))
      (with-current-buffer buffer
        (when (derived-mode-p 'vterm-mode)
          (if (get-buffer-window buffer t)
              (setq byron-vterm-hidden-since nil)
            (unless byron-vterm-hidden-since
              (setq byron-vterm-hidden-since now))))))))

(defun byron-kill-vterm-buffer (buffer)
  "Kill terminal BUFFER only if its process has already exited."
  (when (and (buffer-live-p buffer)
             (not (process-live-p (get-buffer-process buffer))))
    (kill-buffer buffer)))

(defun byron-clean-vterm-buffers ()
  "Remove hidden, exited terminals without terminating live sessions."
  (byron-vterm-track-visibility)
  (let ((now (current-time)))
    (dolist (buffer (buffer-list))
      (with-current-buffer buffer
        (when (and (derived-mode-p 'vterm-mode)
                   byron-vterm-hidden-since
                   (>= (float-time (time-subtract now byron-vterm-hidden-since))
                       byron-vterm-cleanup-delay))
          (byron-kill-vterm-buffer buffer))))))

(add-hook 'window-buffer-change-functions #'byron-vterm-track-visibility)
(add-hook 'vterm-mode-hook #'byron-vterm-track-visibility)
(when (timerp byron-vterm-cleanup-timer)
  (cancel-timer byron-vterm-cleanup-timer))
(setq byron-vterm-cleanup-timer
      (run-at-time byron-vterm-cleanup-interval byron-vterm-cleanup-interval
                   #'byron-clean-vterm-buffers))

;; Keep a separately enabled midnight-mode from bypassing this policy.
(with-eval-after-load 'midnight
  (add-to-list 'clean-buffer-list-kill-never-regexps "\\`\\*vterm"))

(provide 'init-cleanup)
