(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))
(unless (display-graphic-p)
  (menu-bar-mode -1))

(eval-and-compile
  (mapc
   #'(lambda (path)
       (push (expand-file-name path user-emacs-directory) load-path))
   '("site-lisp" "site-lisp/use-package" "elpa" )))

(eval-when-compile
  (defvar use-package-verbose t)
  (require 'use-package))

(require 'bind-key)
(require 'diminish nil t)

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)
(load (expand-file-name "settings.el" user-emacs-directory))

(use-package package
  :init
  (setq package-enable-at-startup nil)
  (setq package-archives '(("melpa" . "http://melpa.milkbox.net/packages/")
                           ("org" . "http://orgmode.org/elpa/")
                           ("gnu" . "http://elpa.gnu.org/packages/")))

  :config
  (package-initialize))

(use-package ace-link
  :ensure t
  :init
  (ace-link-setup-default))

(use-package ace-window
  :ensure t
  :bind* ("M-s" . ace-window)
  :init
  (setq aw-background nil)
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

(use-package ag
  :ensure t
  :commands (ag ag-regexp)
  :init
  (use-package helm-ag
    :ensure t
    :bind ("C-c s" . helm-ag)
    :commands helm-ag))

(use-package avy
  :ensure t
  :bind ("M-SPC" . avy-goto-line)
  :init
  (bind-keys :prefix-map avy-map
             :prefix "C-c j"
             ("c" . avy-goto-char)
             ("l" . avy-goto-line)
             ("w" . avy-goto-word-or-subword-1))
  :config
  (setq avy-background t))

(use-package browse-kill-ring
  :ensure t
  :bind ("C-x C-y" . browse-kill-ring)
  :config
  (setq save-interprogram-paste-before-kill t)
  (setq browse-kill-ring-quit-action 'kill-and-delete-window))

(use-package expand-region
  :ensure t
  :bind ("C-=" . er/expand-region))

(use-package fill-column-indicator
  :ensure t
  :init
  (setq-default fci-rule-column 80)
  (setq fci-handle-truncate-lines nil)
  (setq-default fci-rule-width 6)

  :config
  (define-globalized-minor-mode global-fci-mode fci-mode (lambda () (fci-mode 1)))
  (global-fci-mode 1)
  (defun auto-fci-mode (&optional unused)
    (if (> (window-width) fci-rule-column)
        (fci-mode 1)
      (fci-mode 0)))
  (add-hook 'after-change-major-mode-hook 'auto-fci-mode)
  (add-hook 'window-configuration-change-hook 'auto-fci-mode))

(use-package ggtags
  :ensure t
  :commands ggtags-mode
  :diminish ggtags-mode
  :init
  (setq-local helm-semantic-or-imenu #'ggtags-build-imenu-index))

(use-package helm
  :ensure t
  :demand t
  :diminish helm-mode
  :bind* (("C-c h" . helm-command-prefix)
    ("C-c y" . helm-show-kill-ring)
    ("C-x C-b" . helm-buffers-list)
    ("C-x b" . helm-mini)
    ("C-x C-f" . helm-find-files)
    ("C-x c s" . helm-swoop))
  :config
  (use-package helm-ls-git
    :ensure t)
  (progn
    (require 'helm-config)
    (bind-key "<tab>" 'helm-execute-persistent-action helm-map)
    (bind-key "C-i" 'helm-execute-persistent-action helm-map)
    (bind-key "C-z" 'helm-select-action helm-map)
    (bind-key "A-v" 'helm-previous-page helm-map)
    (setq helm-M-x-fuzzy-match t
      helm-recentf-fuzzy-match t
      helm-buffers-fuzzy-matching t
      helm-semantic-fuzzy-match t
      helm-imenu-fuzzy-match t
      helm-apropos-fuzzy-match t
      helm-lisp-fuzzy-completion t
      helm-move-to-line-cycle-in-source t
      helm-ff-file-name-history-use-recentf t
      helm-ff-auto-update-initial-value nil
      helm-tramp-verbose 9)
    (helm-mode)
    (helm-autoresize-mode t)))

(use-package helm-descbinds
  :ensure t
  :bind ("C-h b" . helm-descbinds)
  :init
  (fset 'describe-bindings 'helm-descbinds)
  :config
  (require 'helm-config))

(use-package helm-gtags
  :ensure t
  :init
  (setq
   helm-gtags-ignore-case t
   helm-gtags-auto-update t
   helm-gtags-use-input-at-cursor t
   helm-gtags-pulse-at-cursor t
   helm-gtags-prefix-key "\C-cg"
   helm-gtags-suggested-key-mapping t
   ))

(use-package helm-swoop
  :ensure t)

(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status)
  :init
  (add-hook 'magit-mode-hook 'hl-line-mode)
  :config
  (setq magit-use-overlays nil))

(use-package markdown-mode
  :ensure t
  :init
  (add-hook 'markdown-mode-hook 'turn-on-auto-revert-mode)
  :mode (("\\`README\\.md\\'" . gfm-mode)
         ("\\.md\\'"          . markdown-mode)
         ("\\.markdown\\'"    . markdown-mode)))

(use-package sh
  :commands sh-mode
  :init
  (setq sh-basic-offset 8)
  (setq sh-indentation 8)
  (setq sh-indent-for-case-label 0)
  (setq sh-indent-for-case-alt '+))

(use-package smartparens
  :ensure t
  :diminish smartparens-mode
  :init
  (smartparens-global-mode t)
  (show-smartparens-global-mode t)
  (use-package smartparens-config)
  (setq sp-autoinsert-quote-if-followed-by-closing-pair nil)
  (sp-with-modes '(markdown-mode gfm-mode)
    (sp-local-pair "*" "*"))
  (sp-with-modes '(org-mode)
    (sp-local-pair "<" ">")
    (sp-local-pair "[" "]")))

(use-package smex
  :ensure t
  :bind (("M-x" . smex)
         ("C-c C-c M-x" . execute-extended-command))
  :init
  (smex-initialize))

(use-package color-theme
  :ensure t)

(use-package color-theme-solarized
  :ensure t
  :init
  (set-frame-parameter nil 'background-mode 'dark)
  (set-terminal-parameter nil 'background-mode 'dark)
  (setq solarized-italic nil)
  (setq solarized-contrast "normal")
  (setq solarized-visibility "normal")
  (set-default-font "Monospace-10")
  :config
  (load-theme 'solarized t))

(use-package undo-tree
  :ensure t
  :diminish undo-tree-mode)

(use-package visual-regexp
  :ensure t
  :bind ("M-%" . vr/query-replace))

(use-package whitespace
  :diminish global-whitespace-mode
  :init
  (setq whitespace-style (quote (spaces tabs space-mark tab-mark)))
  :config
  (global-whitespace-mode 1))

(require 'server)
(unless (server-running-p)
  (server-start))
