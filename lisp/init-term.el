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
  :config
  (setq vterm-shell "/opt/homebrew/bin/zsh"))

(defun my-force-new-vterm-session ()
  "Create a new vterm session by calling vterm with a prefix argument."
  (interactive)
  (vterm '(4)))

(global-set-key [f8] 'my-force-new-vterm-session)

;; (add-hook 'vterm-mode-hook
;;           (lambda ()
;;             (define-key vterm-mode-map (kbd "C-c C-t") nil)))
(provide 'init-term)
