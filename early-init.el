;;; early-init.el --- Startup settings -*- lexical-binding: t -*-

(setq package-enable-at-startup nil
      package-user-dir
      (expand-file-name (format "elpa-%s.%s" emacs-major-version emacs-minor-version)
                        user-emacs-directory))

;; Prefer the built-in Python implementation to the external namesake.
(setq package-load-list '((python-mode nil) all))

(defun byron/native-compiler-environment ()
  "Expose Homebrew's GCC runtime libraries to native compilation on macOS."
  (when (and (eq system-type 'darwin) (native-comp-available-p))
    (let* ((prefix (cond ((file-directory-p "/opt/homebrew/opt/gcc") "/opt/homebrew")
                         ((file-directory-p "/usr/local/opt/gcc") "/usr/local")))
           (gcc (and prefix (concat prefix "/opt/gcc/lib/gcc/current")))
           (runtime (and gcc (file-directory-p gcc)
                         (car (directory-files-recursively gcc "libemutls_w\\.a\\'"))))
           (paths (and runtime
                       (list (file-name-directory runtime) gcc
                             (concat prefix "/opt/libgccjit/lib/gcc/current")))))
      (when paths
        (setenv "LIBRARY_PATH"
                (mapconcat #'identity
                           (delete-dups
                            (append paths
                                    (split-string (or (getenv "LIBRARY_PATH") "")
                                                  path-separator t)))
                           path-separator))))))

(byron/native-compiler-environment)
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars . nil) default-frame-alist)

(setq gc-cons-threshold (* 128 1024 1024))
(defun byron/finish-startup ()
  "Restore the normal collection threshold after initialization."
  (setq gc-cons-threshold (* 100 1024 1024)))
(add-hook 'emacs-startup-hook #'byron/finish-startup)

;;; early-init.el ends here
