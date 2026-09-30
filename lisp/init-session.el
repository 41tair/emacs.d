;;; init-session.el --- Built-in history and session persistence -*- lexical-binding: t -*-

(use-package savehist
  :ensure nil
  :hook (after-init . savehist-mode)
  :custom
  (history-length 1000)
  (savehist-additional-variables '(search-ring regexp-search-ring)))

(use-package saveplace
  :ensure nil
  :hook (after-init . save-place-mode))

(use-package recentf
  :ensure nil
  :hook (after-init . recentf-mode)
  :custom
  (recentf-max-saved-items 300)
  (recentf-auto-cleanup 'never))

(use-package desktop
  :ensure nil
  :custom
  (desktop-path (list user-emacs-directory))
  (desktop-auto-save-timeout 600)
  (desktop-restore-eager 1)
  (desktop-load-locked-desktop nil)
  :config
  (desktop-save-mode 1))

(provide 'init-session)
