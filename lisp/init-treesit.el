;;; init-treesit.el --- Pinned grammars and mode selection -*- lexical-binding: t -*-

(require 'treesit)

;; Pin grammar releases compatible with Emacs 30 and its bundled queries.
(defconst byron/treesit-sources
  '((typescript "https://github.com/tree-sitter/tree-sitter-typescript" "v0.23.2" "typescript/src")
    (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "v0.23.2" "tsx/src")
    (python "https://github.com/tree-sitter/tree-sitter-python" "v0.23.6")
    (go "https://github.com/tree-sitter/tree-sitter-go" "v0.23.4")
    (gomod "https://github.com/camdencheek/tree-sitter-go-mod" "v1.1.0")
    (rust "https://github.com/tree-sitter/tree-sitter-rust" "v0.23.2")
    (json "https://github.com/tree-sitter/tree-sitter-json" "v0.24.8")
    (yaml "https://github.com/tree-sitter-grammars/tree-sitter-yaml" "v0.7.1")
    (bash "https://github.com/tree-sitter/tree-sitter-bash" "v0.23.3")))

(dolist (source byron/treesit-sources)
  (setf (alist-get (car source) treesit-language-source-alist) (cdr source)))

(defun byron/treesit-ready-p (language)
  "Return non-nil when LANGUAGE can be parsed on this machine."
  (and (treesit-available-p) (treesit-language-available-p language)))

(defun byron/treesit-remap-modes ()
  "Prefer available tree-sitter modes, keeping ordinary modes as fallbacks."
  (dolist (entry '((python python-mode python-ts-mode)
                   (go go-mode go-ts-mode)
                   (rust rust-mode rust-ts-mode)
                   (json js-json-mode json-ts-mode)
                   (yaml yaml-mode yaml-ts-mode)))
    (when (byron/treesit-ready-p (car entry))
      (setf (alist-get (cadr entry) major-mode-remap-alist) (caddr entry))))
  (when (byron/treesit-ready-p 'json)
    (add-to-list 'auto-mode-alist '("\\.json\\'" . json-ts-mode)))
  (when (byron/treesit-ready-p 'yaml)
    (add-to-list 'auto-mode-alist '("\\.ya?ml\\'" . yaml-ts-mode))))

(defun byron/install-treesit-grammars (&optional languages)
  "Install missing grammars for LANGUAGES, or all configured languages.
Installation is explicit so opening a file never downloads or compiles code."
  (interactive)
  (unless (treesit-available-p)
    (user-error "This Emacs was built without tree-sitter support"))
  (dolist (language (or languages (mapcar #'car byron/treesit-sources)))
    (unless (treesit-language-available-p language)
      (treesit-install-language-grammar language)
      (unless (treesit-language-available-p language)
        (error "Grammar installation failed: %s" language))))
  (byron/treesit-remap-modes))

(byron/treesit-remap-modes)
(provide 'init-treesit)
