(require 'multi-term)
(setq multi-term-program "/bin/zsh")

(add-hook 'term-mode-hook
          (lambda ()
            (add-to-list 'term-bind-key-alist '("M-[" . multi-term-prev))
            (add-to-list 'term-bind-key-alist '("M-]" . multi-term-next))))

(custom-set-variables
 
     '(term-default-bg-color "#000000")        ;; background color (black)
 
     '(term-default-fg-color "#dddd00"))       ;; foreground color (yellow)


(defun term-send-esc ()
  "Send ESC in term mode."
  (interactive)
  (term-send-raw-string "\e"))

(add-to-list 'term-bind-key-alist '("C-x g"))
(add-to-list 'term-bind-key-alist '("C-c C-e" . term-send-escape))

(provide 'init-term)
