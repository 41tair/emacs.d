;;; init-org-export.el --- Optional CSS for HTML export -*- lexical-binding: t -*-

(defun my-org-inline-css-hook (exporter)
  "Include an existing local or personal stylesheet for HTML EXPORTER."
  (when (org-export-derived-backend-p exporter 'html)
    (let* ((local (expand-file-name "style.css"
                                   (or (and buffer-file-name
                                            (file-name-directory buffer-file-name))
                                       default-directory)))
           (fallback (expand-file-name "css/blog.css" user-emacs-directory))
           (file (cond ((file-readable-p local) local)
                       ((file-readable-p fallback) fallback))))
      (when file
        (setq-local org-html-head-include-default-style nil)
        (setq-local org-html-head
                    (concat org-html-head "\n<style type=\"text/css\">\n"
                            (with-temp-buffer
                              (insert-file-contents file)
                              (buffer-string))
                            "\n</style>"))))))

(with-eval-after-load 'ox
  (add-hook 'org-export-before-processing-functions #'my-org-inline-css-hook))
(provide 'init-org-export)
