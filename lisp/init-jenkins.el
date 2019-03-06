(require 'jenkins)

(setq jenkins-api-token (getenv "EMACS_JENKINS_API_TOKEN"))
(setq jenkins-url (getenv "EMACS_JENKINS_URL"))
(setq jenkins-username (getenv "EMACS_JENKINS_USERNAME"))

(provide 'init-jenkins)
