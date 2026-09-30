# Personal Emacs Config
[![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/3949/badge)](https://bestpractices.coreinfrastructure.org/projects/3949)
![](https://img.shields.io/github/license/41tair/emacs.d)
![](https://img.shields.io/github/languages/top/41tair/emacs.d)

This is my emacs configuration.
There have a lots of config from [Purcell's config](https://github.com/purcell/emacs.d)
The following scenarios are applicable to this profile

 - Lisp
 - Python
 - Go
 - Rust
 - TypeScript / TSX
 - Lua

 - Git with Magit
 - Company, LSP & Flymake
 - Tree-sitter highlighting and indentation
 - Ivy & Counsel
 - Yasnippet
 - Org mode
 - vterm
 
 
 # How to use it

    git clone https://github.com/41tair/emacs.d.git ~/.emacs.d

Emacs packages are installed automatically on first startup. Install external tools as needed:

 - Language servers and formatters: `pyright`, `autopep8`, `gopls`, `rust-analyzer`, `rustfmt`, and Node.js with `typescript` and `typescript-language-server`.
 - Tree-sitter grammars: run `M-x byron/install-treesit-grammars`; requires Git and a C/C++ compiler.
 - vterm: requires CMake and a C compiler to build its module.

# Support Enviorment
 - Emacs 30
 - macOS 15.8
