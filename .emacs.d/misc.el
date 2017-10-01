(use-package company
  :ensure t
  :diminish company-mode
  :init
  (setq company-idle-delay 0.2)
  (setq company-minimum-prefix-length 1)
  (setq company-show-numbers t)
  (setq company-tooltip-limit 20)
  (setq company-dabbrev-downcase nil)
  (setq company-dabbrev-ignore-case t)
  (setq company-dabbrev-code-ignore-case t)
  (setq company-dabbrev-code-everywhere t)
  (setq company-etags-ignore-case t)
  (setq company-global-modes
        '(not
          eshell-mode org-mode))
  :config
  (unless (face-attribute 'company-tooltip :background)
    (set-face-attribute 'company-tooltip nil :background "black" :foreground "gray40")
    (set-face-attribute 'company-tooltip-selection nil :inherit 'company-tooltip :background "gray15")
    (set-face-attribute 'company-preview nil :background "black")
    (set-face-attribute 'company-preview-common nil :inherit 'company-preview :foreground "gray40")
    (set-face-attribute 'company-scrollbar-bg nil :inherit 'company-tooltip :background "gray20")
    (set-face-attribute 'company-scrollbar-fg nil :background "gray40"))
  ;; From https://github.com/jwiegley/dot-emacs/blob/master/init.el
  ;; From https://github.com/company-mode/company-mode/issues/87
  ;; See also https://github.com/company-mode/company-mode/issues/123
  (defadvice company-pseudo-tooltip-unless-just-one-frontend
      (around only-show-tooltip-when-invoked activate)
    (when (company-explicit-action-p)
      ad-do-it))
  (global-company-mode))

(use-package company-emoji
  :ensure t
  :init
  (add-hook 'markdown-mode-hook 'company-emoji-init))

(use-package evil
  :ensure t
  :init
  (setq evil-want-C-u-scroll t)
  (setq evil-flash-delay 2)
  (setq evil-shift-width 8)

  :config
  (evil-mode 1))

(use-package highlight-chars
  :ensure t
  :init
  (add-hook 'font-lock-mode-hook 'hc-highlight-tabs))

(use-package solarized-theme
  :ensure t
  :init
  (setq solarized-distinct-fringe-background t)
  (setq solarized-use-variable-pitch nil)
  (setq solarized-high-contrast-mode-line t)
  (setq solarized-use-less-bold t)
  (setq solarized-use-more-italic nil)
  (setq solarized-emphasize-indicators nil)
  (setq solarized-scale-org-headlines nil)
  (setq solarized-height-minus-1 1)
  (setq solarized-height-plus-1 1)
  (setq solarized-height-plus-2 1)
  (setq solarized-height-plus-3 1)
  (setq solarized-height-plus-4 1)

  :config
  (set-default-font "Droid Sans Mono-11")
  (setq x-underline-at-descent-line t)
  (load-theme 'solarized-dark t))

(use-package yasnippet
  :commands (yas-expand yas-insert-snippet)
  :config
  (yas-minor-mode 1))
