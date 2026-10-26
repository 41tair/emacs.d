;; -*- lexical-binding: t -*-
;;; init-kuma.el --- Personal settings -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(global-hl-line-mode t)

(column-number-mode 1)
(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(dolist (mode-hook '(org-mode-hook
                     term-mode-hook
                     shell-mode-hook
                     eshell-mode-hook
                     vterm-mode-hook
                     yaml-mode-hook
                     yaml-ts-mode-hook))
  (add-hook mode-hook (lambda () (display-line-numbers-mode -1))))

(setq inhibit-startup-message t)

(display-time-mode t)
(setq display-time-24hr-format t)

(display-battery-mode t)

(setq make-backup-files nil)

(setq initial-scratch-message ";;Talk is cheap Show me the code")

;;(setq ns-use-native-fullscreen nil)
(put 'downcase-region 'disabled nil)

(defun insertsshkey (string)
  "Insert ssh key STRING into authorized_keys setup command."
  (interactive "sInsert ssh key: ")
  (insert (format "mkdir -p ~/.ssh;touch ~/.ssh/authorized_keys;echo '%s' >> ~/.ssh/authorized_keys;chmod 600 ~/.ssh/authorized_keys" string))
  (term-send-input))

(setq org-agenda-files (list "~/Documents/org/GTD.org"))
(setopt use-short-answers t)
(let ((font-height 190))
  (when (eq system-type 'gnu/linux)
    (setq font-height (round (* font-height 1.5))))
  (set-face-attribute 'default nil
                      :family "Google Sans Code"
                      :height font-height
                      :weight 'normal
                      :width 'normal))
(setq visible-bell nil)
(setq ring-bell-function 'ignore)

;; Undo tree
(setq undo-tree-history-directory-alist
      (list (cons "." (expand-file-name "undo" user-emacs-directory))))
(use-package undo-tree
  :ensure t
  :hook (after-init . global-undo-tree-mode))

(use-package winum
  :ensure t
  :config
  (winum-mode))

(show-paren-mode t)

;; Collect after losing focus, once Emacs has also been idle for a while.
(defvar byron/gc-idle-timer nil)
(defun byron/gc-after-focus-change ()
  "Debounce focus changes and collect while Emacs is idle."
  (when (timerp byron/gc-idle-timer)
    (cancel-timer byron/gc-idle-timer))
  (setq byron/gc-idle-timer nil)
  (unless (seq-some #'frame-focus-state (frame-list))
    (setq byron/gc-idle-timer (run-with-idle-timer 5 nil #'garbage-collect))))
(add-function :after after-focus-change-function #'byron/gc-after-focus-change)

(defun byron/setup-graphical-frame (frame)
  "Enable graphical features when FRAME is created, including daemon clients."
  (when (display-graphic-p frame)
    (with-selected-frame frame
      (pixel-scroll-precision-mode 1))))
(add-hook 'after-make-frame-functions #'byron/setup-graphical-frame)
(byron/setup-graphical-frame (selected-frame))
(add-hook 'text-mode-hook #'visual-wrap-prefix-mode)

(let ((directory (expand-file-name "~/Documents/elisp/inline")))
  (when (file-directory-p directory)
    ;; Load the built-in namesake before the local package can shadow it.
    (require 'inline)
    (add-to-list 'load-path directory)
    (autoload 'inline-fill (expand-file-name "inline.el" directory) nil t)
    (autoload 'inline-mode (expand-file-name "inline.el" directory) nil t)
    (add-hook 'after-init-hook (lambda () (inline-mode 1)))))

(let ((directory (expand-file-name "~/Documents/elisp/openrouter.el")))
  (when (file-directory-p directory)
    (add-to-list 'load-path directory)
    (autoload 'openrouter-status-mode "openrouter" nil t)
    (add-hook 'after-init-hook (lambda () (openrouter-status-mode 1)))))


(setq delete-by-moving-to-trash t)

(global-auto-revert-mode 1)

(setq global-auto-revert-non-file-buffers t)

(use-package expand-region
  :ensure t
  :bind ("C-=" . er/expand-region))

(setq magit-show-long-lines-warning nil)

(defun byron/magit-gc-before-large-refresh ()
  "Prune stale visibility state and collect markers before large refreshes.
Repeated rebuilds otherwise retain dead markers until the next collection,
making every insertion and deletion in a large diff increasingly costly."
  (when-let* ((status-buffer (if (derived-mode-p 'magit-status-mode)
                                (current-buffer)
                              (ignore-errors
                                (magit-get-mode-buffer 'magit-status-mode)))))
    (with-current-buffer status-buffer
      (when (or (> (buffer-size) (* 1024 1024))
                (bound-and-true-p byron-magit-lazy-diff-mode))
        ;; Keep current folds, without retaining sections from old branches.
        ;; Deferred children are absent from the tree; retain their cache.
        (when (and magit-root-section magit-section-visibility-cache
                   (not (bound-and-true-p byron-magit-lazy-diff-mode)))
          (let ((sections (make-hash-table :test #'equal)))
            (magit-map-sections
             (lambda (section)
               (puthash (magit-section-ident section) t sections)))
            (setq magit-section-visibility-cache
                  (seq-filter (lambda (entry) (gethash (car entry) sections))
                              magit-section-visibility-cache))))
        (garbage-collect)))))

(with-eval-after-load 'magit-mode
  (add-hook 'magit-pre-refresh-hook #'byron/magit-gc-before-large-refresh))

(defun byron/magit-enable-dify-lazy-diffs ()
  "Enable on-demand status hunks in the main Dify checkout."
  (when (equal default-directory (expand-file-name "~/Documents/dify/dify/"))
    (byron-magit-lazy-diff-mode 1)))

(with-eval-after-load 'magit
  (require 'byron-magit-lazy-diff)
  (add-hook 'magit-status-mode-hook #'byron/magit-enable-dify-lazy-diffs))

(provide 'init-kuma)
;;; init-kuma.el ends here
