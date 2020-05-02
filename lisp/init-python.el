(setq auto-mode-alist
      (append '(("SConstruct\\'" . python-mode)
                ("SConscript\\'" . python-mode))
              auto-mode-alist))

(require-package 'pip-requirements)

(when (maybe-require-package 'anaconda-mode)
  (after-load 'python
    ;; Anaconda doesn't work on remote servers without some work, so
    ;; by default we enable it only when working locally.
    (add-hook 'python-mode-hook
              (lambda () (unless (file-remote-p default-directory)
                      (anaconda-mode 1))))
    (add-hook 'anaconda-mode-hook 'anaconda-eldoc-mode))
  (after-load 'anaconda-mode
    (define-key anaconda-mode-map (kbd "M-?") nil))
  (when (maybe-require-package 'company-anaconda)
    (after-load 'company
      (after-load 'python
        (push 'company-anaconda company-backends)))))


(if (eq system-type 'darwin)
    (setq python3Dic "/usr/local/bin")
  (setq python3Dic "/usr/local/bin"))


(defun my-python-mode-config ()
  (setq
   ;; 缩进长度4个空格
   python-indent 4
   ;; 使用空格而不是tab进行缩进
   indent-tabs-mode nil
   ;; 如果有tab的话就解释成4个空格
   default-tab-width 4

   ;; 设置 run-python 的参数，主要是python3解释器的路径，不然默认用的是python2
   python-shell-interpreter (concat python3Dic "/python3")
   python-shell-completion-native-enable nil
   py-python-command (concat python3Dic "/python3")
   exec-path (append exec-path '(python3Dic))
   python-shell-completion-native-disabled-interpreters '("python3")))

;; 在每次进入python-mode的时候加载自定义的python开发环境
(add-hook 'python-mode-hook 'my-python-mode-config)

(use-package company-jedi
  :ensure t
  :init
  ;; 对company-jedi的一些初始化设置
  (progn
    ;; 按下字符就弹出补全，0延迟
    (setq jedi:get-in-function-call-delay 0)
    ;; 进入pyhton-mode的时候初始化jedi
    (add-hook 'python-mode-hook 'jedi:setup)
    ;; 在打出点的时候弹出补全
    (setq jedi:complete-on-dot t)
    ;; 补全的时候识别简写
    (setq jedi:use-shortcuts t)
    ;; 补全列表循环
    (setq company-selection-wrap-around t)
    ;; 虚拟环境
    (setq jedi:environment-root "jedi")))

(define-key company-active-map (kbd "TAB") 'company-complete-common-or-cycle)
(use-package elpy
  :ensure t
  :commands elpy-enable
  :hook
  (python-mode . elpy-mode))

(setq elpy-rpc-virtualenv-path 'current)
(setq elpy-rpc-python-command "/usr/local/bin/python3")
(use-package flycheck
  :ensure t  
  :hook
  (progn
    (python-mode . flycheck-mode)))

(add-hook 'python-mode-hook 'py-autopep8-enable-on-save)
(setq py-autopep8-options '("--max-line-length=120"))

(provide 'init-python)
