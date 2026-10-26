;;; byron-magit-lazy-diff.el --- Defer folded status hunks -*- lexical-binding: t -*-

;;; Commentary:
;; Keep Magit's file headers and patch parser, but postpone parsing ordinary
;; folded file bodies.  Raw patches belong to the current refresh, so a later
;; refresh always replaces them.  Rename, mode-change and conflict diffs keep
;; Magit's eager path.  This extension targets Magit 20260926.1436.

;;; Code:

(require 'cl-lib)
(require 'magit)

(defgroup byron-magit-lazy-diff nil
  "Load folded status diffs on demand."
  :group 'magit)

(defvar-local byron-magit-lazy-diff-mode nil)

(defvar byron-magit-lazy-diff--pending
  (make-hash-table :test #'eq :weakness 'key)
  "File sections whose raw hunks have not yet been parsed.")

(defun byron-magit-lazy-diff--hunks-end ()
  "Return the end of the raw hunk sequence at point."
  (save-excursion
    (while (looking-at diff-hunk-header-re-unified)
      (forward-line)
      ;; Match the body grammar used by `magit-diff-wash-hunk'.
      (while (and (not (eobp)) (memq (char-after) '(?- ?+ ?\s ?\\)))
        (forward-line)))
    (point)))

(defun byron-magit-lazy-diff--wash-hunks (wash-sequence wash-hunk raw)
  "Insert RAW and parse it using WASH-SEQUENCE and WASH-HUNK."
  (let ((beg (point))
        (end (copy-marker (point) t)))
    (unwind-protect
        (progn
          (insert raw)
          (save-restriction
            (narrow-to-region beg end)
            (goto-char beg)
            (funcall wash-sequence wash-hunk)
            (unless (eobp)
              (error "Magit did not consume the deferred diff; refresh with g")))
          (goto-char end)
          (remhash magit-insert-section--current
                   byron-magit-lazy-diff--pending))
      (set-marker end nil))))

(defun byron-magit-lazy-diff--insert-file
    (insert-file file orig status modes rename header binary long-status)
  "Defer ordinary folded bodies while calling INSERT-FILE for metadata."
  (if (not (and byron-magit-lazy-diff-mode
                (derived-mode-p 'magit-status-mode)
                (not (or modes rename binary long-status))
                (member status '("modified" "new file" "deleted" "copied"))))
      (funcall insert-file file orig status modes rename header binary long-status)
    (let ((wash-sequence (symbol-function 'magit-wash-sequence))
          (target-buffer (current-buffer)))
      (cl-letf (((symbol-function 'magit-wash-sequence)
                 (lambda (wash-hunk)
                   (if (not (and (eq (current-buffer) target-buffer)
                                 (eq wash-hunk #'magit-diff-wash-hunk)
                                 (looking-at diff-hunk-header-re-unified)
                                 (oref magit-insert-section--current hidden)))
                       (funcall wash-sequence wash-hunk)
                     (let* ((end (byron-magit-lazy-diff--hunks-end))
                            (raw (buffer-substring (point) end)))
                       (delete-region (point) end)
                       (puthash magit-insert-section--current t
                                byron-magit-lazy-diff--pending)
                       (magit-insert-section-body
                         (byron-magit-lazy-diff--wash-hunks
                          wash-sequence wash-hunk raw)))))))
        (funcall insert-file file orig status modes rename header binary long-status)))))

(defun byron-magit-lazy-diff--materialize (section)
  "Parse a pending file SECTION without changing its fold state."
  (when (and section (gethash section byron-magit-lazy-diff--pending)
             (oref section washer))
    (save-excursion
      (let ((hidden (seq-filter (lambda (s) (oref s hidden))
                                (magit-section-lineage section t))))
        (magit-section--opportunistic-wash section)
        ;; Insertion at a hidden ancestor's end need not extend its overlay.
        (dolist (s hidden)
          (magit-section-hide s))))))

(defun byron-magit-lazy-diff--before-content (section)
  "Ensure SECTION has patch text before a patch operation reads it."
  (byron-magit-lazy-diff--materialize section))

(defun byron-magit-lazy-diff--before-hunk ()
  "Load the current file before a visit command looks up its first hunk."
  (byron-magit-lazy-diff--materialize (magit-diff--file-section)))

(defun byron-magit-lazy-diff--before-locate (file _line _column &optional parent)
  "Load FILE below PARENT before locating a source line in its hunks."
  (when byron-magit-lazy-diff-mode
    (let* ((parent (pcase parent
                     ('unstaged (magit-get-section '((unstaged) (status))))
                     ('staged (magit-get-section '((staged) (status))))
                     ('nil magit-root-section)
                     (_ parent)))
           (section (and parent
                         (seq-find (lambda (s) (equal (oref s value) file))
                                   (oref parent children)))))
      (byron-magit-lazy-diff--materialize section))))

(defun byron-magit-lazy-diff--before-restore-positions (positions)
  "Load files needed to restore old hunk locations in POSITIONS."
  (when byron-magit-lazy-diff-mode
    (dolist (position positions)
      (dolist (old (list (nth 1 position) (nth 4 position)))
        (when (and old (magit-hunk-section-p old))
          (byron-magit-lazy-diff--materialize
           (magit-get-section (magit-section-ident (oref old parent)))))))))

;;;###autoload
(define-minor-mode byron-magit-lazy-diff-mode
  "Defer parsing folded file diffs in this Magit status buffer.
Expand a file normally to load its hunks.  Patch operations load their
required content automatically.  Disabling the mode rebuilds the status
with Magit's original renderer."
  :lighter " LazyDiff"
  :group 'byron-magit-lazy-diff
  (unless (derived-mode-p 'magit-status-mode)
    (setq byron-magit-lazy-diff-mode nil)
    (user-error "Lazy diffs require a Magit status buffer"))
  (when magit-root-section
    (magit-refresh-buffer)))

(advice-add 'magit-diff-insert-file-section :around
            #'byron-magit-lazy-diff--insert-file)
(advice-add 'magit-apply--section-content :before
            #'byron-magit-lazy-diff--before-content)
(advice-add 'magit-diff--hunk-section :before
            #'byron-magit-lazy-diff--before-hunk)
(advice-add 'magit-diff--locate-file-position :before
            #'byron-magit-lazy-diff--before-locate)
(advice-add 'magit--refresh-buffer-set-positions :before
            #'byron-magit-lazy-diff--before-restore-positions)

(provide 'byron-magit-lazy-diff)
;;; byron-magit-lazy-diff.el ends here
