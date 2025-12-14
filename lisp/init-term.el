;; -*- lexical-binding: t -*-
;;; init-term.el --- Terminal configuration -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; (require 'multi-term)
;; (setq multi-term-program "/bin/zsh")

;; (add-hook 'term-mode-hook
;;           (lambda ()
;;             (add-to-list 'term-bind-key-alist '("M-[" . multi-term-prev))
;;             (add-to-list 'term-bind-key-alist '("M-]" . multi-term-next))))

;; (custom-set-variables
 
;;      '(term-default-bg-color "#000000")        ;; background color (black)
 
;;      '(term-default-fg-color "#dddd00"))       ;; foreground color (yellow)


;; (defun term-send-esc ()
;;   "Send ESC in term mode."
;;   (interactive)
;;   (term-send-raw-string "\e"))

;; (add-to-list 'term-bind-key-alist '("C-x g"))
;; (add-to-list 'term-bind-key-alist '("C-c C-e" . term-send-escape))
;; (add-to-list 'term-bind-key-alist '("C-r" . isearch-backward))

(use-package vterm
  :ensure t
  :hook (vterm-mode . (lambda ()
                        (display-line-numbers-mode -1)))
  :config
  (setq vterm-shell "/opt/homebrew/bin/zsh"))

(defun my-force-new-vterm-session ()
  "Create a new vterm session by calling vterm with a prefix argument."
  (interactive)
  (vterm '(4)))

(global-set-key [f8] 'my-force-new-vterm-session)

;; (with-eval-after-load 'vterm
;;   (setq vterm-key-map-alist
;;         (append vterm-key-map-alist
;;                 '(("M-<left>" . "\e[1;3D")    ; Alt+Left  (跳词)
;;                   ("M-<right>" . "\e[1;3C")   ; Alt+Right (跳词)
;;                   ("M-<up>"    . "\e[1;3A")   ; Alt+Up
;;                   ("M-<down>"  . "\e[1;3B")   ; Alt+Down
;;                   ("M-<backspace>" . "\x17")  ; Alt+Backspace (删除前词)
;;                   ("M-DEL"     . "\x17")      ; 同上 (适配不同键盘)
;;                   ("M-d"       . "\ed")       ; Alt+d (删除后词)
;;                   ("C-<left>"  . "\e[1;5D")   ; Ctrl+Left
;;                   ("C-<right>" . "\e[1;5C"))))) ; Ctrl+Right
;; (add-hook 'vterm-mode-hook
;;           (lambda ()
;;             (define-key vterm-mode-map (kbd "C-c C-t") nil)))
(provide 'init-term)
;;; init-term.el ends here
