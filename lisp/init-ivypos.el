(require 'ivy-posframe)
;; Different command can use different display function.
(setq ivy-posframe-height-alist '((swiper . 15)
                                  (t      . 15)))


(setq ivy-fixed-height-minibuffer nil
        ;; ivy-display-function #'ivy-posframe-display-at-point
        ivy-posframe-parameters
        '((min-width . 90)
          (min-height .,ivy-height)
          (internal-border-width . 10)))

(defun window-top-mac (info)
  (cons (/ (- (plist-get info :parent-frame-width)
              (plist-get info :posframe-width))
           2)
	35
	))

(defun ivy-posframe-display-at-window-top-mac (str)
  (ivy-posframe--display str #'window-top-mac)
  )



(setq ivy-posframe-display-functions-alist
      '((swiper          . ivy-posframe-display-at-point)
        (complete-symbol . ivy-posframe-display-at-frame-top-center)
        (counsel-M-x     . ivy-posframe-display-at-window-top-mac)
        (t               . ivy-posframe-display)))
(ivy-posframe-mode 1)

(provide 'init-ivypos)
