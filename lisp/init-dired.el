(setq-default dired-dwim-target t)

;; Emacs 30 already prefers gls when it is available.

(when (maybe-require-package 'diredfl)
  (with-eval-after-load 'dired
    (diredfl-global-mode)))

(with-eval-after-load 'dired
  (require 'dired-x)
  (setq dired-recursive-deletes 'top
        dired-omit-files
        (concat dired-omit-files "\\|^\\.DS_Store\\'"))
  (add-hook 'dired-mode-hook #'dired-omit-mode)
  (define-key dired-mode-map [mouse-2] 'dired-find-file)
  (define-key dired-mode-map (kbd "C-c C-p") 'wdired-change-to-wdired-mode))

(when (maybe-require-package 'diff-hl)
  (with-eval-after-load 'dired
    (add-hook 'dired-mode-hook 'diff-hl-dired-mode)))

(provide 'init-dired)
