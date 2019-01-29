(require 'mu4e)
(require 'smtpmail)

(setq
 ;; general
 mu4e-maildir "~/Mails"
 mu4e-get-mail-command "offlineimap"
 mu4e-update-interval 600

 ;; smtp
 message-send-mail-function 'smtpmail-send-it
 smtpmail-stream-type 'starttls
 starttls-use-gnutls t

 ;; insert sign
 mu4e-compose-signature-auto-include 't
 mu4e-sent-folder "/Gmail/[Gmail].Sent Mail"
 mu4e-drafts-folder "/Gmail/[Gmail].Drafts"
 mu4e-trash-folder "/Gmail/[Gmail].Trash")

(setq mu4e-attachment-dir  "~/Downloads")


(defvar my-mu4e-account-alist
  '(("Gmail"
     ;; about me
     (user-mail-address "altair96wby@gmail.com")
     (user-full-name "Byron wang")
     (mu4e-compose-signature "Best regards.\n Byron wang")
     ;; smtp
     (smtpmail-stream-type starttls)
     (smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil)))
     (smtpmail-auth-credentials (expand-file-name "~/.authinfo.gpg"))
     (smtpmail-default-smtp-server "smtp.gmail.com")
     (smtpmail-smtp-server "smtp.gmail.com")
     (smtpmail-smtp-service 587))

    ("Daocloud"
     ;; about me
     (user-mail-address "altair.wang@daocloud.io")
     (user-full-name "Byron wang")
     (mu4e-compose-signature "Best regards.\n Byron wang ")

     ;; smtp
     (smtpmail-stream-type starttls)
     (smtpmail-starttls-credentials '(("smtp.partner.outlook.cn" 587 nil nil)))
     (smtpmail-auth-credentials (expand-file-name "~/.authinfo.gpg"))
     (smtpmail-default-smtp-server "smtp.partner.outlook.cn")
     (smtpmail-smtp-service 587)
     )))


(defun my-mu4e-set-account ()
  "Set the account for composing a message."
  (let* ((account
          (if mu4e-compose-parent-message
	      (let ((maildir (mu4e-message-field mu4e-compose-parent-message :maildir)))
                (string-match "/\\(.*?\\)/" maildir)
                (match-string 1 maildir))
	    (completing-read (format "Compose with account: (%s) "
				     (mapconcat #'(lambda (var) (car var))
                                                my-mu4e-account-alist "/"))
			     (mapcar #'(lambda (var) (car var)) my-mu4e-account-alist)
			     nil t nil nil (car my-mu4e-account-alist))))
         (account-vars (cdr (assoc account my-mu4e-account-alist))))
    (if account-vars
        (mapc #'(lambda (var)
                  (set (car var) (cadr var)))
	      account-vars)
      (error "No email account found"))))


(add-hook 'mu4e-compose-pre-hook 'my-mu4e-set-account)
(add-hook 'after-init-hook #'mu4e-alert-enable-mode-line-display)


(provide 'init-mu4e)
