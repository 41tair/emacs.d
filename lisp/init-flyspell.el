;;; init-flyspell.el --- Spell-check only when a checker exists -*- lexical-binding: t -*-

(defun byron/flyspell-prog-mode ()
  "Check comments when an external spelling program is available."
  (when (or (executable-find "aspell") (executable-find "hunspell")
            (executable-find "ispell"))
    (flyspell-prog-mode)))
(add-hook 'prog-mode-hook #'byron/flyspell-prog-mode)

(with-eval-after-load 'flyspell
  (keymap-set flyspell-mode-map "C-;" nil)
  (add-to-list 'flyspell-prog-text-faces 'nxml-text-face))

(provide 'init-flyspell)
