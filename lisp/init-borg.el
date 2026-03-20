
(defun borg/org-current-iso-week-number ()
  "Return the current ISO week number."
  (string-to-number (format-time-string "%V")))

(defun borg/org-heading-week-number ()
  "Return the week number from a heading like `Week 10', or nil."
  (let ((heading (org-get-heading t t t t)))
    (save-match-data
      (when (string-match "\\bWeek[[:space:]]+\\([0-9]\\{1,2\\}\\)\\b" heading)
        (string-to-number (match-string 1 heading))))))

(defun borg/org-subtree-all-todos-done-p ()
  "Return non-nil when every TODO item in the current subtree is done."
  (let ((subtree-end (save-excursion (org-end-of-subtree t t)))
        (all-done t))
    (let ((todo-state (org-get-todo-state)))
      (when (and todo-state
                 (not (member todo-state org-done-keywords)))
        (setq all-done nil)))
    (save-excursion
      (forward-line 1)
      (while (and all-done
                  (< (point) subtree-end)
                  (re-search-forward org-heading-regexp subtree-end t))
        (let ((todo-state (org-get-todo-state)))
          (when (and todo-state
                     (not (member todo-state org-done-keywords)))
            (setq all-done nil)))))
    all-done))

(defun borg/org-archive-done-week ()
  "Archive a completed past week subtree into this year's archive."
  (interactive)
  (save-excursion
    (org-back-to-heading t)
    (let ((week (borg/org-heading-week-number))
          (current-week (borg/org-current-iso-week-number)))
      (unless week
        (user-error "Current heading must look like `Week N'"))
      (unless (< week current-week)
        (user-error "Refusing to archive the current or a future week"))
      (unless (borg/org-subtree-all-todos-done-p)
        (user-error "This week still has unfinished items"))
      (let ((org-archive-location (borg/org-current-year-archive-location)))
        (org-archive-subtree-default)))))

(provide 'init-borg)
