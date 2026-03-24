;;; init-borg.el --- Borg task workflow helpers -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:

(require 'org)
(require 'org-agenda)

(defvar borg/org-review-log-items '(closed state clock)
  "Log items shown in Borg review timeline commands.")

(defvar borg/org-review-prefix-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "w") #'borg/org-review-week)
    (define-key map (kbd "m") #'borg/org-review-month)
    (define-key map (kbd "q") #'borg/org-review-quarter)
    (define-key map (kbd "y") #'borg/org-review-year)
    map)
  "Prefix map for Borg review timeline commands.")

(define-key sanityinc/org-global-prefix-map (kbd "A") #'borg/org-archive-done-task)
(define-key sanityinc/org-global-prefix-map (kbd "r") borg/org-review-prefix-map)

(defun borg/org-current-iso-week-number ()
  "Return the current ISO week number."
  (string-to-number (format-time-string "%V")))

(defun borg/org-heading-week-number ()
  "Return the week number from a heading like `Week 10', or nil."
  (let ((heading (org-get-heading t t t t)))
    (save-match-data
      (when (string-match "\\bWeek[[:space:]]+\\([0-9]\\{1,2\\}\\)\\b" heading)
        (string-to-number (match-string 1 heading))))))

(defun borg/org-done-state-p (state)
  "Return non-nil when STATE is one of `org-done-keywords'."
  (and state (member state org-done-keywords)))

(defun borg/org-all-done-states-p (states)
  "Return non-nil when every TODO state in STATES is done."
  (let ((all-done t))
    (while (and states all-done)
      (unless (borg/org-done-state-p (car states))
        (setq all-done nil))
      (setq states (cdr states)))
    all-done))

(defun borg/org-subtree-todo-states (&optional exclude-current)
  "Return TODO states in the current subtree.
When EXCLUDE-CURRENT is non-nil, do not include the current heading."
  (let ((subtree-end (save-excursion (org-end-of-subtree t t)))
        (states nil))
    (save-excursion
      (org-back-to-heading t)
      (unless exclude-current
        (let ((todo-state (org-get-todo-state)))
          (when todo-state
            (push todo-state states))))
      (while (progn
               (outline-next-heading)
               (< (point) subtree-end))
        (let ((todo-state (org-get-todo-state)))
          (when todo-state
            (push todo-state states)))))
    (nreverse states)))

(defun borg/org-subtree-all-todos-done-p ()
  "Return non-nil when every TODO item in the current subtree is done."
  (borg/org-all-done-states-p (borg/org-subtree-todo-states)))

(defun borg/org-has-incomplete-ancestor-p ()
  "Return non-nil when any ancestor subtree still has unfinished TODOs.
This prevents archiving a completed child while its parent project remains
active because of unfinished siblings or an unfinished ancestor heading."
  (save-excursion
    (let ((incomplete-ancestor nil))
      (while (and (not incomplete-ancestor)
                  (org-up-heading-safe))
        (unless (borg/org-subtree-all-todos-done-p)
          (setq incomplete-ancestor t)))
      incomplete-ancestor)))

(defun borg/org-subtree-archivable-p ()
  "Return non-nil when the current subtree can be archived.
The heading itself and its descendants must be done, and no ancestor subtree
may still contain unfinished TODO items."
  (and (borg/org-done-state-p (org-get-todo-state))
       (borg/org-all-done-states-p (borg/org-subtree-todo-states t))
       (not (borg/org-has-incomplete-ancestor-p))))

(defun borg/org-collect-archivable-subtrees ()
  "Return markers for all archivable task subtrees in the current buffer.
When a parent subtree is archivable, its descendants are skipped so the
entire project is archived as one subtree."
  (let ((markers nil))
    (save-excursion
      (save-restriction
        (widen)
        (goto-char (point-min))
        (while (re-search-forward org-outline-regexp-bol nil t)
          (goto-char (match-beginning 0))
          (if (borg/org-subtree-archivable-p)
              (progn
                (push (point-marker) markers)
                (goto-char (save-excursion (org-end-of-subtree t t))))
            (outline-next-heading)))))
    (nreverse markers)))

(defun borg/org-archive-current-subtree ()
  "Archive the current subtree into `archived/<year>.org'."
  (let ((org-archive-location (sanityinc/org-current-year-archive-location)))
    (org-archive-subtree-default)))

(defun borg/org-archive-done-task ()
  "Archive all completed task subtrees in the current file.
If a parent task and all of its descendants are done, archive the whole
parent subtree. Completed child tasks stay in place until every ancestor
subtree that contains them is also complete."
  (interactive)
  (let ((targets (borg/org-collect-archivable-subtrees))
        (count 0))
    (unless targets
      (user-error "No completed tasks found in the current file"))
    (save-excursion
      (dolist (marker (reverse targets))
        (when (marker-buffer marker)
          (goto-char marker)
          (borg/org-archive-current-subtree)
          (setq count (1+ count)))))
    (message "Archived %d completed task%s"
             count
             (if (= count 1) "" "s"))))

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
      (borg/org-archive-current-subtree))))

(defun borg/org-read-review-time (label)
  "Return the review anchor time for LABEL.
With a prefix argument, prompt for the date to review."
  (if current-prefix-arg
      (org-read-date nil t nil (format "%s review date: " label))
    (current-time)))

(defun borg/org-beginning-of-week (time)
  "Return the Monday at the start of TIME's week."
  (let* ((decoded (decode-time time))
         (day (nth 3 decoded))
         (month (nth 4 decoded))
         (year (nth 5 decoded))
         (weekday (nth 6 decoded))
         (offset (if (zerop weekday) 6 (1- weekday))))
    (time-subtract (encode-time 0 0 0 day month year)
                   (days-to-time offset))))

(defun borg/org-beginning-of-month (time)
  "Return the first day of TIME's month at midnight."
  (let ((decoded (decode-time time)))
    (encode-time 0 0 0 1 (nth 4 decoded) (nth 5 decoded))))

(defun borg/org-beginning-of-quarter (time)
  "Return the first day of TIME's quarter at midnight."
  (let* ((decoded (decode-time time))
         (month (nth 4 decoded))
         (year (nth 5 decoded))
         (quarter-month (+ 1 (* 3 (/ (1- month) 3)))))
    (encode-time 0 0 0 1 quarter-month year)))

(defun borg/org-beginning-of-year (time)
  "Return the first day of TIME's year at midnight."
  (let ((decoded (decode-time time)))
    (encode-time 0 0 0 1 1 (nth 5 decoded))))

(defun borg/org-beginning-of-period (period time)
  "Return the start time for PERIOD containing TIME."
  (pcase period
    ('week (borg/org-beginning-of-week time))
    ('month (borg/org-beginning-of-month time))
    ('quarter (borg/org-beginning-of-quarter time))
    ('year (borg/org-beginning-of-year time))
    (_ (user-error "Unsupported review period: %s" period))))

(defun borg/org-shift-months (time months)
  "Return TIME shifted by MONTHS, pinned to the first of the month."
  (let ((decoded (decode-time time)))
    (encode-time 0 0 0 1 (+ months (nth 4 decoded)) (nth 5 decoded))))

(defun borg/org-review-range (period time)
  "Return the (START . END) range for PERIOD containing TIME."
  (let ((start (borg/org-beginning-of-period period time)))
    (cons start
          (pcase period
            ('week (time-add start (days-to-time 7)))
            ('month (borg/org-shift-months start 1))
            ('quarter (borg/org-shift-months start 3))
            ('year (borg/org-shift-months start 12))
            (_ (user-error "Unsupported review period: %s" period))))))

(defun borg/org-review-label (period)
  "Return the display label for review PERIOD."
  (pcase period
    ('week "Weekly")
    ('month "Monthly")
    ('quarter "Quarterly")
    ('year "Yearly")
    (_ (user-error "Unsupported review period: %s" period))))

(defun borg/org-days-between (start end)
  "Return the number of whole days between START and END."
  (floor (/ (float-time (time-subtract end start)) 86400)))

(defun borg/org-review-title (label start end)
  "Return a review agenda title for LABEL from START up to END."
  (format "%s review timeline: %s - %s"
          label
          (format-time-string "%Y-%m-%d" start)
          (format-time-string "%Y-%m-%d"
                              (time-subtract end (seconds-to-time 1)))))

(defun borg/org-review-buffer-name (label start end)
  "Return the agenda buffer name for a review from START to END."
  (format "*Org Review(%s:%s-%s)*"
          label
          (format-time-string "%Y-%m-%d" start)
          (format-time-string "%Y-%m-%d"
                              (time-subtract end (seconds-to-time 1)))))

(defun borg/org-review-years (start end)
  "Return the archive years touched by the review range from START to END."
  (let ((start-year (string-to-number (format-time-string "%Y" start)))
        (end-year (string-to-number
                   (format-time-string "%Y"
                                       (time-subtract end (seconds-to-time 1)))))
        (years nil))
    (while (<= start-year end-year)
      (push start-year years)
      (setq start-year (1+ start-year)))
    (nreverse years)))

(defun borg/org-archive-root-directory (source-file)
  "Return the archive root directory for SOURCE-FILE."
  (let* ((source-path (expand-file-name source-file))
         (source-dir (directory-file-name (file-name-directory source-path))))
    (if (string-equal (file-name-nondirectory source-dir) "archived")
        (file-name-directory source-dir)
      (file-name-as-directory source-dir))))

(defun borg/org-year-archive-file (year source-file)
  "Return the archive file path for YEAR beside SOURCE-FILE."
  (expand-file-name (format "archived/%s.org" year)
                    (borg/org-archive-root-directory source-file)))

(defun borg/org-archive-file-p (file)
  "Return non-nil when FILE lives directly under an `archived/' directory."
  (let ((directory (directory-file-name
                    (file-name-directory (expand-file-name file)))))
    (string-equal (file-name-nondirectory directory) "archived")))

(defun borg/org-source-agenda-files ()
  "Return the configured non-archive agenda files."
  (let ((org-agenda-files (default-value 'org-agenda-files))
        (files nil))
    (dolist (file (org-agenda-files t))
      (unless (borg/org-archive-file-p file)
        (push file files)))
    (nreverse files)))

(defun borg/org-review-archive-files (start end source-files)
  "Return existing archive files relevant to the review range.
Each SOURCE-FILES entry contributes its sibling `archived/<year>.org' files."
  (let ((years (borg/org-review-years start end))
        (files nil))
    (dolist (file source-files)
      (dolist (year years)
        (let ((archive-file (borg/org-year-archive-file year file)))
          (when (file-exists-p archive-file)
            (push archive-file files)))))
    (delete-dups (nreverse files))))

(defun borg/org-review-agenda-files (start end source-files)
  "Return agenda files for review, including relevant yearly archives."
  (delete-dups
   (append source-files
           (borg/org-review-archive-files start end source-files))))

(defun borg/org-review-command-settings (period)
  "Return dynamic custom agenda settings for review PERIOD."
  `((org-agenda-start-day
     (let* ((range (borg/org-review-range ',period (current-time))))
       (format-time-string "%Y-%m-%d" (car range))))
    (org-agenda-span
     (let* ((range (borg/org-review-range ',period (current-time))))
       (borg/org-days-between (car range) (cdr range))))
    (org-agenda-show-log ',borg/org-review-log-items)
    (org-agenda-start-with-log-mode t)
    (org-agenda-log-mode-items ',borg/org-review-log-items)
    (org-agenda-files
     (let* ((range (borg/org-review-range ',period (current-time)))
            (source-files (borg/org-source-agenda-files)))
       (borg/org-review-agenda-files (car range) (cdr range) source-files)))
    (org-agenda-skip-archived-trees nil)
    (org-agenda-overriding-header
     (let* ((range (borg/org-review-range ',period (current-time))))
       (borg/org-review-title
        (borg/org-review-label ',period)
        (car range)
        (cdr range))))))

(defun borg/org-open-review-agenda (label start end &optional source-files)
  "Open a review agenda for LABEL from START up to END."
  (let* ((source-files (or source-files (borg/org-source-agenda-files)))
         (agenda-files (borg/org-review-agenda-files start end source-files))
         (start-day (format-time-string "%Y-%m-%d" start))
         (span (borg/org-days-between start end))
         (header (borg/org-review-title label start end))
         (buffer-name (borg/org-review-buffer-name label start end))
         (org-agenda-buffer-tmp-name buffer-name)
         (redo-cmd `(borg/org-open-review-agenda
                     ,label
                     ',start
                     ',end
                     ',source-files))
         (lprops `((org-agenda-files ',agenda-files)
                   (org-agenda-skip-archived-trees nil)
                   (org-agenda-start-day ,start-day)
                   (org-agenda-span ,span)
                   (org-agenda-show-log ',borg/org-review-log-items)
                   (org-agenda-start-with-log-mode t)
                   (org-agenda-log-mode-items ',borg/org-review-log-items)
                   (org-agenda-overriding-header ,header)))
         (org-agenda-start-day start-day)
         (org-agenda-span span)
         (org-agenda-files agenda-files)
         (org-agenda-skip-archived-trees nil)
         (org-agenda-show-log borg/org-review-log-items)
         (org-agenda-start-with-log-mode t)
         (org-agenda-log-mode-items borg/org-review-log-items)
         (org-agenda-sticky nil)
         (org-agenda-window-setup 'current-window)
         (org-agenda-overriding-header header))
    (org-agenda-list nil)
    (let ((agenda-buffer (current-buffer)))
      (with-current-buffer agenda-buffer
        (setq-local org-agenda-this-buffer-name buffer-name)
        (setq-local org-agenda-buffer-name buffer-name)
        (setq-local org-agenda-files agenda-files)
        (setq-local org-agenda-skip-archived-trees nil)
        (setq-local org-agenda-show-log borg/org-review-log-items)
        (setq-local org-agenda-redo-command redo-cmd)
        (let ((inhibit-read-only t))
          (add-text-properties
           (point-min)
           (point-max)
           `(org-lprops ,lprops
                        org-redo-cmd ,redo-cmd)))))))

(defun borg/org-review-period (period &rest _)
  "Open a review timeline for PERIOD."
  (pcase-let* ((label (borg/org-review-label period))
               (anchor (borg/org-read-review-time label))
               (`(,start . ,end) (borg/org-review-range period anchor)))
    (borg/org-open-review-agenda label start end)))

(defun borg/org-review-week (&rest _)
  "Open a weekly review timeline.
With a prefix argument, review the week containing a prompted date."
  (interactive)
  (borg/org-review-period 'week))

(defun borg/org-review-month (&rest _)
  "Open a monthly review timeline.
With a prefix argument, review the month containing a prompted date."
  (interactive)
  (borg/org-review-period 'month))

(defun borg/org-review-quarter (&rest _)
  "Open a quarterly review timeline.
With a prefix argument, review the quarter containing a prompted date."
  (interactive)
  (borg/org-review-period 'quarter))

(defun borg/org-review-year (&rest _)
  "Open a yearly review timeline.
With a prefix argument, review the year containing a prompted date."
  (interactive)
  (borg/org-review-period 'year))

;; Register review timelines in the Org agenda dispatcher under the `r' prefix.
(with-eval-after-load 'org-agenda
  (org-add-agenda-custom-command '("r" . "Review timeline"))
  (org-add-agenda-custom-command
   `("rw" "Weekly review timeline" agenda ""
     ,(borg/org-review-command-settings 'week)))
  (org-add-agenda-custom-command
   `("rm" "Monthly review timeline" agenda ""
     ,(borg/org-review-command-settings 'month)))
  (org-add-agenda-custom-command
   `("rq" "Quarterly review timeline" agenda ""
     ,(borg/org-review-command-settings 'quarter)))
  (org-add-agenda-custom-command
   `("ry" "Yearly review timeline" agenda ""
     ,(borg/org-review-command-settings 'year))))

(provide 'init-borg)
