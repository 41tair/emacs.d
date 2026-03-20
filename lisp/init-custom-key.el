;; -*- lexical-binding: t -*-
;;; init-custom-key.el --- Global custom keybindings -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(define-key global-map (kbd "C->") #'other-window)
(define-key global-map (kbd "C-c a") #'org-agenda)
(define-key global-map (kbd "C-c c") #'org-capture)
(define-key global-map (kbd "C-c l") #'org-store-link)
(define-key global-map (kbd "C-x C-b") #'ibuffer)
(define-key global-map (kbd "C-x g") #'magit-status)
(define-key global-map (kbd "C-x M-g") #'magit-dispatch)
(define-key global-map (kbd "M-?") #'sanityinc/counsel-search-project)
(define-key global-map (kbd "M-C-/") #'company-complete)
(define-key global-map (kbd "M-C-'") #'company-yasnippet)
(define-key global-map [f1] #'my-force-new-vterm-session)
(define-key global-map [f2] #'inline-fill)
(define-key global-map [f3] #'borg/org-review-week)
(define-key global-map [f4] #'ag-project)
(define-key global-map [f5] #'kmacro-start-macro)
(define-key global-map [f6] #'kmacro-end-and-call-macro)
(define-key global-map [f7] #'inline-fill)
(define-key global-map [f8] #'my-force-new-vterm-session)
(define-key global-map [f9] #'insertsshkey)
(define-key global-map [f10] #'insertsshkey)
(define-key global-map [f11] #'insertsshkey)
(define-key global-map [f12] #'goto-line)

(provide 'init-custom-key)
;;; init-custom-key.el ends here
