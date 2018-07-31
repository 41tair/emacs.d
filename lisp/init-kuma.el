;; 高亮当前行
(global-hl-line-mode t)

(global-linum-mode t) ;; enable line numbers globally
(column-number-mode 1)


(setq inhibit-startup-message t) ;; hide the startup message

(display-time-mode t)
(setq display-time-24hr-format 1)

(display-battery-mode t)

;;(require 'sr-speedbar)


(setq make-backup-files nil)

(set-scroll-bar-mode nil)

(put 'downcase-region 'disabled nil)
;;----------global-key------------

(global-set-key (kbd "C->") 'other-window) ;; set hotkey change window
(global-set-key "\C-ca" 'org-agenda)
;; Magit shortcut
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-x M-g") 'magit-dispatch-popup)
(global-set-key (kbd "C-x C-t") 'multi-term)

(fset 'yes-or-no-p 'y-or-n-p) ;; y or n instead of yes or no

(provide 'init-kuma)
