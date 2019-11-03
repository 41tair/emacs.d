;; 高亮当前行
(global-hl-line-mode t)

(require 'cc-mode)
(global-linum-mode t) ;; enable line numbers globally
(column-number-mode 1)


(setq inhibit-startup-message t) ;; hide the startup message

(display-time-mode t)
(setq display-time-24hr-format 1)

(display-battery-mode t)

;;(require 'sr-speedbar)


(setq make-backup-files nil)

(setq initial-scratch-message ";;Talk is cheap Show me the code")

(set-scroll-bar-mode nil)

(put 'downcase-region 'disabled nil)

(defun insertsshkey (string)
  "Insert ssh key"
  (interactive "sInsert ssh key")
  (insert "mkdir -p ~/.ssh;touch ~/.ssh/authorized_keys;echo ''>> ~/.ssh/authorized_keys;chmod 600 ~/.ssh/authorized_keys")
  (term-send-input))

;;----------global-key------------

(global-set-key (kbd "C->") 'other-window) ;; set hotkey change window
(global-set-key "\C-ca" 'org-agenda)
;; Magit shortcut
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-x M-g") 'magit-dispatch-popup)
(global-set-key (kbd "C-x C-t") 'multi-term)

(global-set-key [f12] 'goto-line)
(global-set-key [f9] 'insertsshkey)
(global-set-key [f3] 'execute-extended-command)
(global-set-key [f4] 'ag-project)
(global-set-key [f5] 'kmacro-start-macro)
(global-set-key [f6] 'kmacro-end-and-call-macro)
(fset 'yes-or-no-p 'y-or-n-p) ;; y or n instead of yes or no

(setq visible-bell 0)

;;(global-undo-tree-mode)

;; (with-eval-after-load "magit-fetch"
;; (magit-define-popup-switch
;;  'magit-fetch-popup
;;  ?t "Fetch tags from remote" "--tags"))


(show-paren-mode t)

;;(setq url-gateway-method 'socks)
;;(setq socks-server '("Default server" "127.0.0.1" 1086 5))
;;(require 'cc-mode)

;; (require 'groovy-mode)
;; (add-to-list 'auto-mode-alist '("Jenkinsfile$" . groovy-mode))
(provide 'init-kuma)
