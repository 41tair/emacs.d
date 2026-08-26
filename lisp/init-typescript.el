;; -*- lexical-binding: t -*-
;;; init-typescript.el --- TypeScript configuration -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(require 'subr-x)

(defconst my/typescript-extensions
  '("\\.ts\\'" "\\.mts\\'" "\\.cts\\'"))

(defun my/typescript-project-root ()
  "Return the nearest TypeScript or Node project root."
  (or (locate-dominating-file default-directory "tsconfig.json")
      (locate-dominating-file default-directory "package.json")
      (locate-dominating-file default-directory "node_modules")))

(defun my/typescript-use-project-node-modules ()
  "Prefer project-local Node executables for TypeScript tools."
  (when-let* ((root (my/typescript-project-root))
              (bin (expand-file-name "node_modules/.bin" root)))
    (when (file-directory-p bin)
      (setq-local exec-path (cons bin exec-path))
      (setq-local process-environment (copy-sequence process-environment))
      (setenv "PATH" (concat bin path-separator (getenv "PATH"))))))

(defun my/typescript-setup ()
  "Set up TypeScript editing."
  (setq-local js-indent-level 2)
  (setq-local typescript-indent-level 2)
  (my/typescript-use-project-node-modules)
  (when (fboundp 'lsp-deferred)
    (lsp-deferred)))

(defun my/typescript-tsx-setup ()
  "Set up TSX editing."
  (when (derived-mode-p 'web-mode)
    (setq-local web-mode-markup-indent-offset 2)
    (setq-local web-mode-css-indent-offset 2)
    (setq-local web-mode-code-indent-offset 2))
  (when (or (not (derived-mode-p 'web-mode))
            (and buffer-file-name
                 (string-match-p "\\.tsx\\'" buffer-file-name)))
    (my/typescript-setup)))

(defun my/typescript-treesit-available-p (language)
  "Return non-nil when tree-sitter grammar for LANGUAGE is available."
  (and (fboundp 'treesit-available-p)
       (treesit-available-p)
       (treesit-language-available-p language)))

(when (require 'treesit nil t)
  (dolist (source '((typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" nil "typescript/src"))
                    (tsx . ("https://github.com/tree-sitter/tree-sitter-typescript" nil "tsx/src"))))
    (add-to-list 'treesit-language-source-alist source))

  (defun my/typescript-install-treesit-grammars ()
    "Install TypeScript and TSX tree-sitter grammars."
    (interactive)
    (dolist (language '(typescript tsx))
      (unless (treesit-language-available-p language)
        (treesit-install-language-grammar language)))))

(if (my/typescript-treesit-available-p 'typescript)
    (dolist (pattern my/typescript-extensions)
      (add-auto-mode 'typescript-ts-mode pattern))
  (when (maybe-require-package 'typescript-mode)
    (use-package typescript-mode
      :ensure nil
      :mode (("\\.ts\\'" . typescript-mode)
             ("\\.mts\\'" . typescript-mode)
             ("\\.cts\\'" . typescript-mode)))))

(if (my/typescript-treesit-available-p 'tsx)
    (add-auto-mode 'tsx-ts-mode "\\.tsx\\'")
  (when (maybe-require-package 'web-mode)
    (use-package web-mode
      :ensure nil
      :mode ("\\.tsx\\'" . web-mode)
      :config
      (add-to-list 'web-mode-content-types-alist '("jsx" . "\\.tsx\\'")))))

(dolist (hook '(typescript-mode-hook typescript-ts-mode-hook))
  (add-hook hook #'my/typescript-setup))

(dolist (hook '(tsx-ts-mode-hook web-mode-hook))
  (add-hook hook #'my/typescript-tsx-setup))

(with-eval-after-load 'lsp-mode
  (setq lsp-clients-typescript-prefer-use-project-ts-server t)
  (setq lsp-clients-typescript-max-ts-server-memory 4096)
  (lsp-register-custom-settings
   '(("typescript.suggest.autoImports" t t)
     ("javascript.suggest.autoImports" t t)
     ("typescript.preferences.includePackageJsonAutoImports" "auto"))))

(provide 'init-typescript)
;;; init-typescript.el ends here
