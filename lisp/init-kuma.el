;; -*- lexical-binding: t -*-
;;; init-kuma.el --- Personal settings -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(global-hl-line-mode t)

(require 'cc-mode)
(column-number-mode 1)
(global-display-line-numbers-mode 1)

(setq inhibit-startup-message t)

(display-time-mode t)
(setq display-time-24hr-format t)

(display-battery-mode t)

(setq make-backup-files nil)

(setq initial-scratch-message ";;Talk is cheap Show me the code")

(set-scroll-bar-mode nil)

;;(setq ns-use-native-fullscreen nil)
(put 'downcase-region 'disabled nil)

(defun insertsshkey (string)
  "Insert ssh key STRING into authorized_keys setup command."
  (interactive "sInsert ssh key: ")
  (insert (format "mkdir -p ~/.ssh;touch ~/.ssh/authorized_keys;echo '%s' >> ~/.ssh/authorized_keys;chmod 600 ~/.ssh/authorized_keys" string))
  (term-send-input))

;;----------global-key------------

(global-set-key (kbd "C->") 'other-window)
(global-set-key "\C-ca" 'org-agenda)
(setq org-agenda-files (list "~/Documents/org/GTD.org"))

;; Magit shortcut
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-x M-g") 'magit-dispatch)  ; magit-dispatch-popup 已废弃

(global-set-key [f12] 'goto-line)
(global-set-key [f9] 'insertsshkey)
(global-set-key [f4] 'ag-project)
(global-set-key [f5] 'kmacro-start-macro)
(global-set-key [f6] 'kmacro-end-and-call-macro)
(fset 'yes-or-no-p 'y-or-n-p)
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
(global-undo-tree-mode)
(setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))

;; winum-mode 替代废弃的 window-numbering-mode
(use-package winum
  :ensure t
  :config
  (winum-mode))

(show-paren-mode t)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(provide 'init-kuma)
;;; init-kuma.el ends here
