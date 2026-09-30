;;; init-elpa.el --- Package declarations and installation -*- lexical-binding: t -*-

(require 'package)
(require 'cl-lib)
(require 'use-package)
(require 'use-package-ensure)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(unless package--initialized
  (package-initialize))

;; Themes need the package load path; declarations must see saved choices.
(when (file-exists-p custom-file)
  (load custom-file nil t))

(defvar byron/required-packages nil
  "External packages declared by the active configuration.")

(defun require-package (package &optional min-version no-refresh)
  "Ensure PACKAGE is installed, optionally at MIN-VERSION.
NO-REFRESH prevents refreshing archive metadata.  Record direct dependencies
also when they were installed before this Emacs session."
  (unless (package-installed-p package min-version)
    (let ((versions (mapcar #'package-desc-version
                            (cdr (assq package package-archive-contents)))))
      (if (cl-some (lambda (version) (version-list-<= min-version version)) versions)
          (package-install package)
        (if no-refresh
            (error "No available version of %s satisfies %S" package min-version)
          (package-refresh-contents)
          (require-package package min-version t))))
    (unless (package-installed-p package min-version)
      (error "Package %s does not satisfy version %S" package min-version)))
  (unless (package-built-in-p package min-version)
    (cl-pushnew package byron/required-packages))
  t)

(defun maybe-require-package (package &optional min-version no-refresh)
  "Ensure optional PACKAGE is installed, reporting installation failures."
  (condition-case err
      (require-package package min-version no-refresh)
    (error
     (display-warning 'init (format "Could not install %s: %s"
                                   package (error-message-string err)))
     nil)))

(defun byron/use-package-ensure (name args _state)
  "Record and install NAME using the `use-package' ensure ARGS."
  (dolist (ensure args)
    (when ensure
      (let ((package (if (eq ensure t) name ensure)))
        (when (consp package)
          (use-package-pin-package (car package) (cdr package))
          (setq package (car package)))
        (require-package package))))
  t)

(setq use-package-ensure-function #'byron/use-package-ensure)

(defun byron/save-selected-packages ()
  "Persist declared dependencies, preserving manually selected packages."
  (let ((selected (sort (delete-dups (append byron/required-packages
                                            package-selected-packages nil))
                        #'string<)))
    (unless (equal selected package-selected-packages)
      (customize-save-variable 'package-selected-packages selected))))

(add-hook 'after-init-hook #'byron/save-selected-packages 90)

(require-package 'fullframe)
(fullframe list-packages quit-window)
(require-package 'gnu-elpa-keyring-update)

(use-package magit
  :ensure t
  :commands (magit-status magit-dispatch))

(defun sanityinc/set-tabulated-list-column-width (col-name width)
  "Set any column named COL-NAME to WIDTH."
  (when (> width (length col-name))
    (cl-loop for column across tabulated-list-format
             when (string= col-name (car column))
             do (setf (elt column 1) width))))

(defun sanityinc/maybe-widen-package-menu-columns ()
  "Widen package menu columns to avoid truncation."
  (sanityinc/set-tabulated-list-column-width "Version" 13)
  (sanityinc/set-tabulated-list-column-width
   "Archive" (apply #'max (mapcar (lambda (entry) (length (car entry)))
                                package-archives))))

(add-hook 'package-menu-mode-hook #'sanityinc/maybe-widen-package-menu-columns)
(provide 'init-elpa)
