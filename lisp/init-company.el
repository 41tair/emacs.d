;;; init-company.el --- Completion through CAPF -*- lexical-binding: t -*-

(setq tab-always-indent 'complete)
(add-to-list 'completion-styles 'initials t)

(use-package company
  :ensure t
  :hook (after-init . global-company-mode)
  :bind (("M-C-/" . company-complete)
         :map company-active-map
         ("C-n" . company-select-next)
         ("C-p" . company-select-previous))
  :custom
  (company-idle-delay 0.2)
  (company-minimum-prefix-length 2)
  (company-tooltip-align-annotations t))

;; LSP supplies company-capf; retain standard backends for other buffers.
(provide 'init-company)
