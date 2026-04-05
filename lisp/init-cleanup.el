;; -*- lexical-binding: t -*-
;;; init-cleanup.el --- Buffer cleanup configuration -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(require 'cl-lib)
(require 'midnight)

(defcustom byron-vterm-cleanup-delay 3600
  "Seconds a hidden `vterm' buffer may remain idle before being killed."
  :type 'natnum)

(defcustom byron-vterm-cleanup-interval 1800
  "Seconds between automatic stale `vterm' cleanup runs."
  :type 'natnum)

(cl-defstruct (byron-hidden-layer
               (:constructor byron-hidden-layer-create))
  name
  mode
  created-time-var
  cleanup-delay
  cleanup-interval
  buffer-killer
  timer
  mode-hook-function
  cleanup-function)

(defvar byron-hidden-layers nil
  "Registered hidden buffer cleanup layers.")

(defvar-local byron-vterm-created-time nil
  "Creation time used to age never-displayed `vterm' buffers.")

(defun byron-hidden-layer-mode-hook (layer)
  "Return the hook symbol for LAYER's major mode."
  (intern (format "%s-hook" (byron-hidden-layer-mode layer))))

(defun byron-hidden-layer-record-created-time (created-time-var)
  "Record the current time in CREATED-TIME-VAR for the current buffer."
  (set created-time-var (current-time)))

(defun byron-hidden-layer-last-seen (layer buffer)
  "Return BUFFER's last seen time for LAYER."
  (with-current-buffer buffer
    (or buffer-display-time
        (symbol-value (byron-hidden-layer-created-time-var layer)))))

(defun byron-hidden-layer-buffer-stale-p (layer buffer now)
  "Return non-nil when BUFFER is a hidden stale buffer in LAYER as of NOW."
  (with-current-buffer buffer
    (and (derived-mode-p (byron-hidden-layer-mode layer))
         (not (get-buffer-window buffer 'visible))
         (let* ((last-seen (byron-hidden-layer-last-seen layer buffer))
                (age (and last-seen
                          (float-time (time-subtract now last-seen)))))
           (and age
                (>= age (byron-hidden-layer-cleanup-delay layer)))))))

(defun byron-hidden-layer-kill-buffer (layer buffer)
  "Kill BUFFER using LAYER's configured buffer killer."
  (funcall (or (byron-hidden-layer-buffer-killer layer) #'kill-buffer) buffer))

(defun byron-hidden-layer-clean-buffers (layer)
  "Kill stale hidden buffers belonging to LAYER."
  (let ((now (current-time)))
    (dolist (buffer (buffer-list))
      (when (byron-hidden-layer-buffer-stale-p layer buffer now)
        (message "Cleaning stale %s buffer %s"
                 (byron-hidden-layer-name layer)
                 (buffer-name buffer))
        (byron-hidden-layer-kill-buffer layer buffer)))))

(defun byron-hidden-layer-stop-timer (layer)
  "Stop LAYER's cleanup timer."
  (when (timerp (byron-hidden-layer-timer layer))
    (cancel-timer (byron-hidden-layer-timer layer))
    (setf (byron-hidden-layer-timer layer) nil)))

(defun byron-hidden-layer-start-timer (layer)
  "Start or restart LAYER's cleanup timer."
  (byron-hidden-layer-stop-timer layer)
  (setf (byron-hidden-layer-timer layer)
        (run-at-time (byron-hidden-layer-cleanup-interval layer)
                     (byron-hidden-layer-cleanup-interval layer)
                     (byron-hidden-layer-cleanup-function layer))))

(defun byron-hidden-layer-uninstall (layer)
  "Remove LAYER's hooks and timer."
  (remove-hook (byron-hidden-layer-mode-hook layer)
               (byron-hidden-layer-mode-hook-function layer))
  (remove-hook 'midnight-hook (byron-hidden-layer-cleanup-function layer))
  (byron-hidden-layer-stop-timer layer))

(defun byron-hidden-layer-install (layer)
  "Install LAYER's hooks and timer."
  (add-hook (byron-hidden-layer-mode-hook layer)
            (byron-hidden-layer-mode-hook-function layer))
  (add-hook 'midnight-hook (byron-hidden-layer-cleanup-function layer))
  (byron-hidden-layer-start-timer layer))

(defun byron-make-hidden-layer (&rest args)
  "Create, install and register a hidden buffer cleanup layer."
  (let* ((layer (apply #'byron-hidden-layer-create args))
         (name (byron-hidden-layer-name layer))
         (existing (alist-get name byron-hidden-layers nil nil #'eq))
         (created-time-var (byron-hidden-layer-created-time-var layer)))
    (when existing
      (byron-hidden-layer-uninstall existing))
    (setf (byron-hidden-layer-mode-hook-function layer)
          (lambda ()
            (byron-hidden-layer-record-created-time created-time-var))
          (byron-hidden-layer-cleanup-function layer)
          (lambda ()
            (byron-hidden-layer-clean-buffers layer)))
    (byron-hidden-layer-install layer)
    (setq byron-hidden-layers (assq-delete-all name byron-hidden-layers))
    (push (cons name layer) byron-hidden-layers)
    layer))

(defun byron-kill-vterm-buffer (buffer)
  "Kill `vterm' BUFFER without prompting for its running process."
  (when (buffer-live-p buffer)
    (let ((proc (get-buffer-process buffer))
          (kill-buffer-query-functions nil))
      (when (process-live-p proc)
        (set-process-query-on-exit-flag proc nil)
        (delete-process proc))
      (kill-buffer buffer))))

(defvar byron-vterm-hidden-layer
  (byron-make-hidden-layer
   :name 'vterm
   :mode 'vterm-mode
   :created-time-var 'byron-vterm-created-time
   :cleanup-delay byron-vterm-cleanup-delay
   :cleanup-interval byron-vterm-cleanup-interval
   :buffer-killer #'byron-kill-vterm-buffer)
  "Hidden cleanup layer for stale `vterm' buffers.")

(midnight-mode 1)

(provide 'init-cleanup)
;;; init-cleanup.el ends here
