;; -*- lexical-binding: t -*-
;;; init-yasnippet.el --- Yasnippet configuration -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode 1))

(setq lsp-enable-snippet t)
;; make Ctrl-c k the only trigger key for yas
(define-key yas-minor-mode-map (kbd "<tab>") nil)
(define-key yas-minor-mode-map (kbd "TAB") nil)
(define-key yas-minor-mode-map (kbd "C-c k") 'yas-expand)

(provide 'init-yasnippet)
;;; init-yasnippet.el ends here
