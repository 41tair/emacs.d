;; 高亮当前行
(global-hl-line-mode t)

(require 'cc-mode)
;;(global-linum-mode t) ;; enable line numbers globally
(column-number-mode 1)


(setq inhibit-startup-message t) ;; hide the startup message

(add-hook 'after-init-hook 'global-company-mode)

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
  (interactive "Insert ssh key")
  (insert "mkdir -p ~/.ssh;touch ~/.ssh/authorized_keys;echo ''>> ~/.ssh/authorized_keys;chmod 600 ~/.ssh/authorized_keys")
  (term-send-input))

;;----------global-key------------

(global-set-key (kbd "C->") 'other-window) ;; set hotkey change window
(global-set-key "\C-ca" 'org-agenda)
(setq org-agenda-files (list "~/Documents/org/GTD.org"))
;; Magit shortcut
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-x M-g") 'magit-dispatch-popup)
(global-set-key (kbd "C-x C-t") 'multi-term)

(global-set-key [f12] 'goto-line)
(global-set-key [f9] 'insertsshkey)
(global-set-key [f3] 'smex)
(global-set-key [f4] 'ag-project)
(global-set-key [f5] 'kmacro-start-macro)
(global-set-key [f6] 'kmacro-end-and-call-macro)
(fset 'yes-or-no-p 'y-or-n-p) ;; y or n instead of yes or no
;;(set-default-font "Monaco 15" nil t)
(setq visible-bell 0)

(global-set-key (kbd "C-x p") 'leetcode-problems)
(global-undo-tree-mode)
(window-numbering-mode)

(require 'smex) ; Not needed if you use package.el
(smex-initialize) ; Can be omitted. This might cause a (minimal) delay
					; when Smex is auto-initialized on its first run.
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
  ;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)
;; (with-eval-after-load "magit-fetch"
;; (magit-define-popup-switch
;;  'magit-fetch-popup
;;  ?t "Fetch tags from remote" "--tags"))

;; (setq url-gateway-method 'socks)
;; (setq socks-server '("Default server" "127.0.0.1" 1081 5))


;; (setq url-using-proxy t)
;; (setq url-proxy-services '(("http" . "127.0.0.1:8001")))
(show-paren-mode t)


(use-package lsp-python-ms
  :ensure t
  :init (setq lsp-python-ms-auto-install-server t)
  :hook (python-mode . (lambda ()
                          (require 'lsp-python-ms)
                          (lsp))))  ; or lsp-deferred
(setq lsp-python-ms-executable
      "/Users/byronwang/Documents/Mac/python-language-server/output/bin/Release/osx.10.15-x64/publish/Microsoft.Python.LanguageServer")
(setq lsp-python-ms-python-executable "/usr/local/bin/python3")

(provide 'init-kuma)
