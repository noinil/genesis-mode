# genesis-mode

Emacs Genesis-mode for user-friendly reading and writing Genesis input files.


## Usage:
To use this major mode, please add the following to
your Emacs configuration file:
```elisp
(add-to-list 'load-path "~/path_to_genesis-mode/")
(require 'genesis-mode)
(add-to-list 'auto-mode-alist '("\\.atin\\'" . genesis-mode))
(add-to-list 'auto-mode-alist '("\\.spin\\'" . genesis-mode))
(add-to-list 'auto-mode-alist '("\\.cgin\\'" . genesis-mode))
```

To use the snippets, please try this: https://github.com/noinil/esnippets

## Features:
- [X] provide a major mode for Genesis input files
- [X] key words highlighting
- [X] comment (`*`) recognition;  use `Alt`+`;` to comment out selected region
- [ ] indentation
- [ ] section fold
- [X] snippet
- [ ] other...

## Commentary
This file is based on *Emacs DerivedMode*:
http://www.emacswiki.org/emacs/DerivedMode

