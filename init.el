(package-initialize)
(put 'erase-buffer 'disabled nil)
(setq gc-cons-threshold 100000000)

(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t) ; Org-mode's repository

(put 'temporary-file-directory 'standard-value '((file-name-as-directory "/tmp")))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;;; PT Mono & Theme
(use-package solarized-theme
  :ensure t
  :config (progn
            (setq solarized-use-variable-pitch nil
                  solarized-height-minus-1 1.0
                  solarized-height-plus-1 1.0
                  solarized-height-plus-2 1.0
                  solarized-height-plus-3 1.0
                  solarized-height-plus-4 1.0)
            (set-default-font "PT Mono 14")
            (global-hl-line-mode -1)
            (load-theme 'solarized-light t)))

(add-hook 'emacs-lisp-mode-hook 'eldoc-mode)


(global-unset-key "\M-c")

(setq mac-command-modifier 'meta)
(setq mac-option-modifier 'super)

(global-set-key (kbd "<f12>") 'toggle-frame-maximized)

;; somewhere else:
(setq auto-save-list-file-prefix "~/.emacs-saves/.saves-")

;;;解决eshell中的clear命令问题
(defun eshell/clear ()
  (interactive)
  (let ((inhibit-read-only t))
    (erase-buffer)
    (eshell-send-input)))

;;;文件名复制到剪贴板
(defun copy-file-name-to-clipboard ()
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name))))
    (when filename
      (kill-new filename)
      (message "copied buffer file name '%s' to the clipboard" filename))))


(setq-default indent-tabs-mode nil)
(setq tabify nil)
(setq  cursor-in-non-selected-windows nil)

;;;左边显示行数
(global-linum-mode +1)
(setq linum-format " %4d ")
(set-face-attribute 'linum nil :background (face-attribute 'default :background))

(setq warning-minimum-level :emergency)

;;;切换到暂用buffer
(defun temp-buffer ()
  (interactive)
  (switch-to-buffer "*temp*"))

(defun detabify-buffer ()
  (interactive)
  (untabify (point-min) (point-max)))


;;;清除空格等等
(defun clean-up-whitespace ()
  (interactive)
  (detabify-buffer)
  (delete-trailing-whitespace))


;;;建立暂用的buffer
(global-set-key (kbd "C-x t") 'temp-buffer)

;;;启动提速
(require 'whitespace)
(setq whitespace-line-column 80000) ;; limit line length


;;;蛋疼的编码
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)


(if (boundp 'buffer-file-coding-system)
    (setq-default buffer-file-coding-system 'utf-8)
  (setq buffer-file-coding-system 'utf-8))

(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))
(setq whitespace-style (quote (spaces tabs newline space-mark tab-mark newline-mark)))
(setq whitespace-display-mappings
      '((tab-mark 9 [9655 9] [92 9])))

(setenv "PATH"
        (concat (getenv "PATH") ":/usr/local/bin"))

(defun view-buffer-name ()
  (interactive)
  (message (buffer-file-name)))


;;;需要你安装JsonPP
(defun beautify-json ()
  (interactive)
  (save-excursion
    (shell-command-on-region (mark) (point) "jsonpp" (buffer-name) t)))


(defun mac? ()
  (eq system-type 'darwin))


(defun linux? ()
  (eq system-type 'gnu/linux))

(defun windows? ()
  (eq system-type 'windows-nt))


(defun add-auto-mode (mode &rest patterns)
  (dolist (pattern patterns)
    (add-to-list 'auto-mode-alist (cons pattern mode))))

;;;有时候你需要编辑超级文件
(defun sudo ()
  (interactive)
  (let ((file-name (buffer-file-name)))
    (when file-name
      (find-alternate-file (concat "/sudo::" file-name)))))

;;; 全部保存
(defun save-all ()
  (interactive)
  (save-some-buffers t))

(defun insert-date (prefix)
  (interactive "P")
  (let ((format (cond
                 ((not prefix) "%Y-%m-%d" ) ;"%d.%m.%Y"
                 ((equal prefix '(4)) "%Y-%m-%d")
                 ((equal prefix '(16)) "%A, %d. %B %Y")))
        (system-time-locale "en_US"))
    (insert (format-time-string format))))

(global-set-key (kbd "C-c d") 'insert-date)

(defun settings ()
  (interactive)
  (find-file "~/.emacs.d/init.el"))

(defun rs ()
  (interactive)
  (load-file "~/.emacs.d/init.el"))

(global-set-key (kbd "C-c I") 'settings)

(defun open-line-below ()
  (interactive)
  (end-of-line)
  (newline)
  (indent-for-tab-command))

(defun open-line-above ()
  (interactive)
  (beginning-of-line)
  (newline)
  (forward-line -1)
  (indent-for-tab-command))

(global-set-key (kbd "<C-return>") 'open-line-below)
(global-set-key (kbd "<C-S-return>") 'open-line-above)

(global-set-key (kbd "C-S-n")
                (lambda ()
                  (interactive)
                  (ignore-errors (next-line 5))))

(global-set-key (kbd "C-S-p")
                (lambda ()
                  (interactive)
                  (ignore-errors (previous-line 5))))

(global-set-key (kbd "C-S-f")
                (lambda ()
                  (interactive)
                  (ignore-errors (forward-char 5))))

(global-set-key (kbd "C-S-b")
                (lambda ()
                  (interactive)
                  (ignore-errors (backward-char 5))))

(define-key emacs-lisp-mode-map (kbd "C-c C-c") 'pp-eval-last-sexp)

(setq inhibit-startup-message t)
(setq inhibit-splash-screen t)
(setq initial-scratch-message nil)
(setq initial-buffer-choice "~/")

(defalias 'yes-or-no-p 'y-or-n-p)
(delete-selection-mode t)
(global-set-key (kbd "C-x m") 'eshell)
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

(global-set-key (kbd "C-c %") 'query-replace-regexp)

(setq scroll-step            1
      scroll-conservatively  10000)

(when (display-graphic-p)
  (tool-bar-mode -1)
  (scroll-bar-mode -1))

(setq org-src-fontify-natively t)
(set-input-mode t nil t)

(global-subword-mode 1)

(setq make-backup-files nil) ; stop creating those backup~ files
(setq auto-save-default nil) ; stop creating those #auto-save# files


(setq-default fill-column 100)
(column-number-mode t)
(setq-default indicate-empty-lines nil)

(setq truncate-partial-width-windows nil)

(setq-default truncate-lines nil)
(add-hook 'focus-out-hook 'save-all)

(use-package aggressive-indent
  :ensure t
  :config (global-aggressive-indent-mode 1))


(setq-default cursor-type 'hbar)
(blink-cursor-mode t)
(setq explicit-shell-file-name "/usr/local/bin/bash")
(set-face-attribute 'fringe nil :background (face-attribute 'default :background)) ;
(set-face-attribute 'vertical-border nil :foreground (face-attribute 'default :background))


(require 'paren)
(setq show-paren-style 'parenthesis)
(show-paren-mode +1)
(setq show-paren-style 'parenthesis)
(setq show-paren-delay 0)

(keyboard-translate ?\C-x ?\C-u)
(keyboard-translate ?\C-u ?\C-x)

(use-package try
  :ensure t)

(use-package which-key
  :ensure t
  :config (which-key-mode))

(use-package beacon
  :ensure t
  :config (beacon-mode t))


(use-package undo-tree
  :ensure t)

(defun toggle-company-ispell ()
  (interactive)
  (cond
   ((memq 'company-ispell company-backends)
    (setq company-backends (delete 'company-ispell company-backends))
    (message "company-ispell disabled"))
   (t
    (add-to-list 'company-backends 'company-ispell)
    (message "company-ispell enabled!"))))

(use-package company
  :ensure t
  :bind ("s-<SPC>" . company-complete)
  :config (global-company-mode t)
  :init (progn
          (setq company-tooltip-align-annotations t)
          (setq company-idle-delay 0.025)
          (setq company-dabbrev-ignore-case t)
          (setq company-dabbrev-downcase nil)
          (setq company-tooltip-flip-when-above t)
          (setq company-dabbrev-code-other-buffers 'code)))



(use-package projectile
  :ensure t
  :config (projectile-global-mode t))

(use-package smartparens
  :ensure t
  :config (smartparens-global-mode t))


(use-package paredit
  :ensure t
  :config (add-hook 'emacs-lisp-mode-hook 'paredit-mode))

(use-package rainbow-mode
  :ensure t
  :config (rainbow-mode 1))

(use-package rainbow-delimiters
  :ensure t
  :config (add-hook 'emacs-lisp-mode-hook 'rainbow-delimiters-mode))

(use-package counsel
  :ensure t)

(use-package swiper
  :ensure t
  :bind (("\C-s" . swiper)
         ("C-c C-r" . ivy-resume)
         ("<f6>" . ivy-resume)
         ("M-x" . counsel-M-x)
         ("C-x C-f" . counsel-find-file)
         ("<f1> f" . counsel-describe-function)
         ("<f1> v" . counsel-describe-variable)
         ("<f1> l" . counsel-load-library)
         ("<f2> i" . counsel-info-lookup-symbol)
         ("<f2> u" . counsel-unicode-char)
         ("C-c g" . counsel-git)
         ("C-c j" . counsel-git-grep)
         ("C-c k" . counsel-ag)
         ("C-x l" . counsel-locate)
         ("C-S-o" . counsel-rhythmbox)
         )
  :config (progn
            (ivy-mode 1)
            (setq ivy-use-virtual-buffers t)
            (setq projectile-completion-system 'ivy)))

(use-package recentf
  :ensure t
  :init (progn
          (setq recentf-max-saved-items 1024)
          (setq recentf-max-menu-items 1024)
          (recentf-mode 1)
          (global-set-key (kbd "C-c f") 'ivy-recentf)))

(use-package highlight-parentheses
  :ensure t
  :config (global-highlight-parentheses-mode nil))

(use-package clojure-mode
  :ensure t
  :mode (("\\.clj\\'" . clojure-mode)
         ("\\.edn\\'" . clojure-mode))
  :init (progn
          (add-hook 'clojure-mode-hook #'rainbow-delimiters-mode)
          (add-hook 'clojure-mode-hook #'yas-minor-mode)
          (add-hook 'clojure-mode-hook #'subword-mode)
          (add-hook 'clojure-mode-hook #'smartparens-mode)
          (add-hook 'clojure-mode-hook #'paredit-mode)
          (add-hook 'clojure-mode-hook #'eldoc-mode)))

(use-package clj-refactor
  :ensure t
  :defer t
  :diminish clj-refactor-mode
  :config (cljr-add-keybindings-with-prefix "C-c C-m"))

(use-package cider
  :ensure t
  :defer t
  :diminish subword-mode
  :init
  (progn
    (setq cider-show-error-buffer nil)
    (setq cider-repl-print-length 1000)
    (add-hook 'cider-repl-mode-hook #'company-mode)
    (add-hook 'cider-mode-hook #'company-mode)
    (add-hook 'cider-mode-hook #'clj-refactor-mode)))

(use-package helm-cider
  :ensure t
  :init (helm-cider-mode t))

(use-package cider-eval-sexp-fu
  :ensure t
  :defer t
  :config (require 'cider-eval-sexp-fu))

(use-package smartparens
  :ensure t
  :defer t
  :diminish smartparens-mode
  :init
  (setq sp-override-key-bindings
        '(("C-<right>" . nil)
          ("C-<left>" . nil)
          ("C-)" . sp-forward-slurp-sexp)
          ("M-<backspace>" . nil)
          ("C-(" . sp-forward-barf-sexp)))
  :config
  (use-package smartparens-config)
  (sp-use-smartparens-bindings)
  (sp--update-override-key-bindings)
  :commands (smartparens-mode show-smartparens-mode))


;;;Emacs中轻松的使用git
(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status)
  )


(use-package project-explorer
  :ensure t
  :config (progn (setq pe/omit-gitignore t)
                 (setq pe/width 32)))

(use-package helm
  :ensure t
  :bind ("C-x C-g" . helm-imenu)
  )


;;; python
(use-package python
  :ensure t)

(use-package jedi
  :ensure t)

(use-package elpy
  :ensure t
  :config (progn (setq elpy-rpc-backend "jedi")
                 (setq py-python-command "/usr/bin/python3")
                 (elpy-enable)
                 (elpy-use-ipython)
                 (setq python-indent 4)
                 (add-hook 'python-mode-hook 'jedi:setup)
                 (setq jedi:complete-on-dot t)))

(use-package grizzl
  :ensure t
  :config
  (setq projectile-completion-system 'grizzl))

(use-package lorem-ipsum
  :ensure t
  :config (lorem-ipsum-use-default-bindings))

(use-package origami
  :ensure t)

(use-package markdown-mode
  :ensure t
  :mode (
         ("\\.text\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode)
         ("\\grimoire*\\'" . markdown-mode)
         ("\\.md\\'" . markdown-mode)))

(use-package expand-region
  :ensure t
  :bind ("C-=" . er/expand-region)
  )

(use-package hydra
  :ensure t)

(use-package goto-last-change
  :ensure t
  :bind ("C-x C-\\" . goto-last-change)
  )

(use-package web-mode
  :ensure t
  :config (progn
            (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
            (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
            (add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
            (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
            (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
            (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
            (add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
            (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))))

(use-package yaml-mode
  :ensure t
  :mode "\\.yaml?\\'"
  )


;;;react,jsx你会需要的
(use-package js2-mode
  :ensure t
  :mode (("\\.js?\\'" . js2-mode)
         ("\\.jsx?\\'" . js2-mode))
  :config
  (progn
    (add-hook 'js2-mode-hook 'yas-minor-mode)
    (add-hook 'js2-mode-hook 'js2-refactor-mode)
    (js2r-add-keybindings-with-prefix "C-c C-m")
    ))

;;;写HTML是你会需要的
(use-package emmet-mode
  :ensure t
  :config (progn
            (add-hook 'web-mode-hook 'emmet-mode)
            (add-hook 'sgml-mode-hook 'emmet-mode)
            (add-hook 'css-mode-hook  'emmet-mode)))


(use-package edit-server
  :init
  (add-hook 'after-init-hook 'server-start t)
  (add-hook 'after-init-hook 'edit-server-start t))

(use-package diff-hl
  :ensure t
  :config (global-diff-hl-mode t))

(use-package yasnippet
  :ensure t
  :config (yas-global-mode t))

(use-package clojure-snippets
  :ensure t)

(use-package helm-descbinds
  :ensure t
  :defer t
  :bind (("C-h b" . helm-descbinds)
         ("C-h w" . helm-descbinds)))

(use-package xkcd
  :ensure t
  :defer t)

(use-package calfw
  :ensure t
  :init
  (progn
    (require 'calfw)))

(use-package smart-mode-line
  :ensure t
  :config (progn
            (setq sml/no-confirm-load-theme t)
            (sml/setup)))

(use-package scala-mode
  :ensure t
  :mode (("\\.scala\\'" . scala-mode))
  )

(use-package mark-multiple
  :ensure t
  :bind (("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-'" . mc/mark-all-like-this))
  )


(custom-set-faces
 )
