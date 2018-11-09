(require 'mu4e)

(setq mu4e-maildir "~/Mails")
;;(setq mu4e-get-mail-command "offlineimap")
;; Fetch mail in 60 sec interval
;;(setq mu4e-update-interval 60)

; folder for sent messages
(setq mu4e-sent-folder   "/Gmail/[Gmail].Sent Mail")
;; unfinished messages
(setq mu4e-drafts-folder "/Gmail/[Gmail].Drafts")
;; trashed messages
(setq mu4e-trash-folder  "/Gmail/[Gmail].Trash")
;; saved messages
;;(setq mu4e-trash-folder  "/Gmail/Arc")

(setq mu4e-get-mail-command "offlineimap")
(setq mu4e-update-interval 300)
(require 'mu4e-contrib)
(setq mu4e-html2text-command 'mu4e-shr2text)
;; try to emulate some of the eww key-bindings
(add-hook 'mu4e-view-mode-hook
          (lambda ()
            (local-set-key (kbd "<tab>") 'shr-next-link)
            (local-set-key (kbd "<backtab>") 'shr-previous-link)))


(setq mu4e-view-show-images t)


; SMTP setup
;; (setq message-send-mail-function 'smtpmail-send-it
;;       smtpmail-stream-type 'starttls
;;       starttls-use-gnutls t)
;; ;; Personal info
;; (setq user-full-name "Byron, Wang")
;; (setq user-mail-address "altair96wby@gmail.com")
;; ;; gmail setup
;; (setq smtpmail-smtp-server "smtp.gmail.com")
;; (setq smtpmail-smtp-service 587)
;; (setq smtpmail-smtp-user "altair96wby@gmail.com")


;; (setq smtpmail-smtp-server "smtp.gmail.com")
;; (setq smtpmail-smtp-service 587)
;; (setq user-full-name "altair96wby@gmail.com")
;; (setq user-mail-address "altair96wby@gmail.com")


(require 'smtpmail)

(setq message-send-mail-function 'smtpmail-send-it
      starttls-use-gnutls t
      smtpmail-starttls-credentials
      '(("smtp.gmail.com" 587 nil nil))
      smtpmail-auth-credentials
      (expand-file-name "~/.authinfo.gpg")
      smtpmail-default-smtp-server "smtp.gmail.com"
      smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-smtp-service 587
      smtpmail-debug-info t)



(setq mu4e-compose-signature "Sent from my emacs.")
;;(setq message-send-mail-function 'message-send-mail-with-sendmail)

(provide 'init-mu4e)
