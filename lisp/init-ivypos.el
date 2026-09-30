;;; init-ivypos.el --- Optional floating Ivy UI -*- lexical-binding: t -*-

(defgroup byron nil "Personal Emacs configuration." :group 'convenience)
(defcustom byron-use-ivy-posframe nil
  "Display Ivy in a floating frame instead of the minibuffer.
Set before initialization; disabled by default to preserve the current UI."
  :type 'boolean :group 'byron)

(when byron-use-ivy-posframe
  (use-package ivy-posframe
    :ensure t
    :after ivy
    :custom
    (ivy-posframe-height-alist '((t . 15)))
    (ivy-posframe-display-functions-alist
     '((swiper . ivy-display-function-fallback)
       (t . ivy-posframe-display-at-frame-center)))
    :config
    (defun byron/enable-ivy-posframe (frame)
      "Enable the optional floating interface when a graphical FRAME exists."
      (when (display-graphic-p frame)
        (with-selected-frame frame
          (ivy-posframe-mode 1))))
    (add-hook 'after-make-frame-functions #'byron/enable-ivy-posframe)
    (byron/enable-ivy-posframe (selected-frame))))

(provide 'init-ivypos)
