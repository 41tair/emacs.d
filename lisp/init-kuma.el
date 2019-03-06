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

(setq initial-scratch-message ";;Talk is cheap")

(set-scroll-bar-mode nil)

(put 'downcase-region 'disabled nil)

(defun insertsshkey (string)
  "Insert ssh key"
  (interactive "sInsert ssh key")
  (insert "mkdir -p ~/.ssh;touch ~/.ssh/authorized_keys;echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9GGP6aYJedzOK68wrqreRuezjS0KJ+CXge93i0ZYdxNqPL6snJcsm1i+MZJXFaqf3MQOfwcy72ijnHbC/iCF9sHAHzrOzviUpLugjO/b8pk7QoJ0ZMueQwDb+MqakS5NNBxXaxzz0d608VibzBRTgGcq4y2MIo53GEuSZZh7oNd4SN02QGHNGviudaCII2gc++thutnP2UZLQPqbWkjUjikW9LSScXGPtKII3wg4uwRVHRCz/2V99QTpG5et+OTvjr90817h2p7+8bCAX3qityapRXFVvKfpmhek18KTTqxanzMcyLpO80PQyTXU2Vu3wUUPIdhW75sc4eJclnbp3 altair96wby@gmail.com'>> ~/.ssh/authorized_keys;chmod 600 ~/.ssh/authorized_keys")
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
(global-set-key [f2] 'mu4e)
(global-set-key [f3] 'execute-extended-command)
(global-set-key [f4] 'ag-project)
(global-set-key [f5] 'kmacro-start-macro)
(global-set-key [f6] 'kmacro-end-and-call-macro)
(fset 'yes-or-no-p 'y-or-n-p) ;; y or n instead of yes or no

(setq visible-bell 0)

(global-undo-tree-mode)


;; chinese font width
(setq fonts
      (cond ((eq system-type 'darwin)     '("Monaco"    "STHeiti"))
            ((eq system-type 'gnu/linux)  '("Menlo"     "WenQuanYi Zen Hei"))
            ((eq system-type 'windows-nt) '("Consolas"  "Microsoft Yahei"))))
(set-face-attribute 'default nil :font
                    (format "%s:pixelsize=%d" (car fonts) 12))
(dolist (charset '(kana han symbol cjk-misc bopomofo))
  (set-fontset-font (frame-parameter nil 'font) charset
                    (font-spec :family (car (cdr fonts)))))
;; Fix chinese font width and rescale
(setq face-font-rescale-alist '(("Microsoft Yahei" . 1.2) ("WenQuanYi Micro Hei Mono" . 1.2) ("STHeiti". 1.2)))


(with-eval-after-load "magit-fetch"
(magit-define-popup-switch
 'magit-fetch-popup
 ?t "Fetch tags from remote" "--tags"))


(show-paren-mode t)

;;(setq url-gateway-method 'socks)
;;(setq socks-server '("Default server" "127.0.0.1" 1086 5))
;;(require 'cc-mode)

(provide 'init-kuma)
