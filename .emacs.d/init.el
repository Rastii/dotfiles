;; packages
(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("org" . "http://orgmode.org/elpa/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))
(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(defvar my-packages
  '(paredit
    clojure-mode
    clojure-mode-extra-font-locking
    cider
    js2-mode
    ac-js2
    js-comint
    auto-complete
    rainbow-delimiters
    rainbow-mode
    haskell-mode
    magit
    evil
    htmlize
    org
    web-mode
    key-chord
    ag
    projectile
    helm
    helm-projectile
    markdown-mode
    powerline
    solarized-theme
    leuven-theme
    sql-indent
    sqlup-mode
    slime
    emmet-mode
    load-theme-buffer-local
    idle-highlight-mode
    multiple-cursors
    hackernews))

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

(defun require-package (package)
  (setq-default highlight-tabs t)
  "Install given PACKAGE."
  (unless (package-installed-p package)
    (unless (assoc package package-archive-contents)
      (package-refresh-contents))
    (package-install package)))

(setq magit-auto-revert-mode nil)
(setq magit-last-seen-setup-instructions "1.4.0")
;; org-mode
(require 'org)
(setq org-agenda-include-diary t)
(setq org-todo-keywords
  '((sequence "TODO" "DOING" "WAITING" "SOMEDAY" "DONE")))
(define-key global-map (kbd "C-c a") 'org-agenda)
 (defun org-toggle-todo-and-fold ()
  (interactive)
  (save-excursion
    (org-back-to-heading t)
    (cond ((looking-at "\*+ TODO")
           (org-todo "DONE")
           (hide-subtree))
          (t (org-todo "TODO")
           (hide-subtree)))))
(define-key org-mode-map (kbd "C-SPC") 'org-toggle-todo-and-fold)
(define-key org-mode-map (kbd "C-c s") 'org-sort)

;; Archive DONE items
(defun org-archive-done-tasks ()
  (interactive)
  (org-map-entries (lambda ()
                     (org-archive-subtree)
                     (setq org-map-continue-from (outline-previous-heading)))
                   "/DONE" 'tree))
(define-key org-mode-map (kbd "C-S-SPC") 'org-archive-done-tasks)

(require 'htmlize)
(setq org-src-fontify-natively t)
;; org exports
(setq org-html-doctype-alist "html5")
;; capture mode
(setq org-default-notes-file "~/org/everything.org")
(define-key global-map (kbd "C-c c") 'org-capture)

;; magit
(define-key global-map (kbd "C-x g") 'magit-status)

;; SUDO Find File
(defun sudo-find-file (file-name)
  "Like find file, but opens file as root"
  (interactive "FSudo Find File: ")
  (let ((tramp-file-name (concat "/sudo::" (expand-file-name file-name))))
    (find-file tramp-file-name)))
(define-key global-map (kbd "C-x C-S-f") 'sudo-find-file)

;; GO TO in web browser
(define-key global-map (kbd "C-M-g") 'eww)

(defun back-to-indentation-or-beginning ()
  "Move point to beginning of line, or to first non-space character"
  (interactive)
  (if (= (point) (progn (back-to-indentation) (point)))
      (beginning-of-line)))
(global-set-key (kbd "C-a") 'back-to-indentation-or-beginning)


;; Evil
(require 'evil)
;; Enable evil, but only for prog or text buffers
;; (add-hook 'prog-mode-hook 'evil-local-mode)
(mapcar (lambda (hook)
          (add-hook hook 'evil-local-mode)
          (add-hook hook 'linum-mode))
        '(prog-mode-hook text-mode-hook))

(define-key evil-insert-state-map (kbd "C-a") 'back-to-indentation-or-beginning)
(define-key evil-insert-state-map (kbd "C-e") 'move-end-of-line)
(define-key evil-insert-state-map (kbd "C-k") 'kill-line)
(define-key evil-insert-state-map (kbd "C-d") 'delete-char)
(define-key evil-insert-state-map (kbd "C-n") 'next-line)
(define-key evil-insert-state-map (kbd "C-p") 'previous-line)
; Move around
(define-key evil-normal-state-map (kbd "0") 'back-to-indentation-or-beginning)
(define-key evil-normal-state-map (kbd "C-h") 'evil-window-left)
(define-key evil-normal-state-map (kbd "C-j") 'evil-window-down)
(define-key evil-normal-state-map (kbd "C-k") 'evil-window-up)
(define-key evil-normal-state-map (kbd "C-l") 'evil-window-right)

;; Remap org-mode meta keys for convenience
(mapcar (lambda (state)
          (evil-declare-key state org-mode-map
            (kbd "M-l") 'org-metaright
            (kbd "M-h") 'org-metaleft
            (kbd "M-k") 'org-metaup
            (kbd "M-j") 'org-metadown
            (kbd "M-L") 'org-shiftmetaright
            (kbd "M-H") 'org-shiftmetaleft
            (kbd "M-K") 'org-shiftmetaup
            (kbd "M-J") 'org-shiftmetadown))
        '(normal insert))

(require 'key-chord)
(setq key-chord-two-keys-delay 0.5)
(key-chord-define evil-insert-state-map "jk" 'evil-normal-state)
(key-chord-mode 1)

;; Programming mode-specific
(require 'idle-highlight-mode)
(require 'auto-complete)
(add-hook 'prog-mode-hook (lambda ()
                            (auto-complete-mode t)
                            (idle-highlight-mode t)))

;; view settings
(setq inhibit-splash-screen t)

(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(load-theme 'plan9 t)
(add-hook 'text-mode-hook
          (lambda ()
            (visual-line-mode)))
(setq redisplay-dont-pause t
      scroll-margin 1
      scroll-step 1
      scroll-conservatively 10000
      scroll-preserve-screen-position 1)

(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this-word)
(global-set-key (kbd "C-<") 'mc/mark-previous-word-like-this)

(global-unset-key (kbd "C-<down-mouse-1>"))
(global-set-key (kbd "C-<mouse-1>") 'mc/add-cursor-on-click)

(require 'whitespace)
(setq whitespace-style '(face empty tabs lines-tail trailing))
(global-whitespace-mode t)

(require 'powerline)
(powerline-center-theme)

;; DocView
(setq doc-view-continuous t)

(require 'iso-transl)
(transient-mark-mode 1)

(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

;; Web development
(require 'web-mode)
(require 'js2-mode)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.css\\'" . web-mode))
(setq js2-global-externs '("$" "_" "d3" "angular"))
(setq web-mode-extra-snippets
      '(("php" . (("dowhile" . ("<?php do { ?>\n\n<?php } while (|); ?>"))
                  ("debug" . ("<?php error_log(__LINE__); ?>"))
                  ("translate" . "<?= _('|'); ?>")))))

;; Node REPL
(setq inferior-js-program-command "/usr/bin/node")
(setenv "NODE_NO_READLINE" "1")

(mapcar (lambda (pair)
          (define-key js2-mode-map (kbd (car pair)) (cdr pair)))
        '(("C-x C-e" . js-send-last-sexp)
          ("C-c C-c" . js-send-last-sexp-and-go)
          ("C-c b" . js-send-buffer)
          ("C-c C-b" . js-send-buffer-and-go)
          ("C-c l" . js-load-file-and-go)))

(defun my-web-mode-hook ()
  (linum-mode)
  (emmet-mode)
  (evil-local-mode)
  (idle-highlight-mode -1)
  ;; Config
  (setq web-mode-enable-css-colorization t)
  (setq web-mode-enable-current-element-highlight t)
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2))

(add-hook 'web-mode-hook 'my-web-mode-hook)
(setq emmet-move-cursor-between-quotes t)

;; Auto-completion
(require 'ac-js2)
(add-hook 'js2-mode-hook 'ac-js2-mode)
;; See if this gets too slow
(setq ac-js2-evaluate-calls t)
(setq js2-basic-offset 2)

(defun my-web-mode-hook ()
  (linum-mode)
  (emmet-mode)
  (evil-local-mode))

(add-hook 'html-mode-hook 'my-web-mode-hook)
(add-hook 'sgml-mode-hook 'my-web-mode-hook)
(add-hook 'css-mode-hook 'my-web-mode-hook)
(add-hook 'handlebars-mode-hook 'my-web-mode-hook)
(setq emmet-move-cursor-between-quotes t)

(require 'haskell-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
;; Markdown
(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

(setq-default indent-tabs-mode nil)
(setq tab-width 4)
(defvaralias 'c-basic-offset 'tab-width)
(define-key global-map (kbd "RET") 'newline-and-indent)
(global-hl-line-mode)

;; SQL mode
(add-hook 'sql-interactive-mode-hook
          (lambda ()
            (sqlup-mode)
            (toggle-truncate-lines t)))
(add-hook 'sql-mode-hook 'sqlup-mode)

(electric-pair-mode 1)
(show-paren-mode 1)
(setq show-paren-style 'expression)

;; Helm
(helm-mode +1)
(setq helm-quick-update t)
(setq helm-M-x-fuzzy-match t)
(setq helm-buffers-fuzzy-matching t)
(helm-autoresize-mode 1)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "<C-tab>") 'helm-mini)
(global-set-key (kbd "C-x C-f") 'helm-find-files)

;; Lisps
(setq my/lisps
      '(emacs-lisp-mode-hook lisp-mode-hook scheme-mode-hook clojure-mode-hook slime-mode-hook))
(defun my/lisp-hooks ()
  (paredit-mode)
  (rainbow-delimiters-mode))
(dolist (mode-hook my/lisps)
  (add-hook mode-hook 'my/lisp-hooks))

;; Emacs Lisp
(add-hook 'emacs-lisp-mode-hook 'eldoc-mode)
(define-key lisp-mode-map (kbd "C-S-r") 'slime)

;; SLIME stuff
; (load (expand-file-name "~/quicklisp/slime-helper.el"))
; (setq inferior-lisp-program "sbcl –dynamic-space-size 2560")

;; cc-mode
(setq-default c-default-style "k&r"
              c-basic-offset 4)

(projectile-global-mode)
(setq projectile-enable-caching t)

;; C-; to comment one line
(defun toggle-comment-on-line ()
  "Comment or uncomment current line"
  (interactive)
  (comment-or-uncomment-region (line-beginning-position) (line-end-position)))
(global-set-key (kbd "C-;") 'toggle-comment-on-line)

;; SHELL MODE
;; Use bash as my shell
(setq explicit-shell-file-name "/bin/bash")
(defun eshell-here ()
  "Opens up a new shell in the directory associated with the
current buffer's file. The eshell is renamed to match that
directory to make multiple eshell windows easier."
  (interactive)
  (let* ((parent (if (buffer-file-name)
                     (file-name-directory (buffer-file-name))
                   default-directory))
         (height (/ (window-total-height) 3))
         (name   (car (last (split-string parent "/" t)))))
    (split-window-vertically (- height))
    (other-window 1)
    (eshell "new")
    (rename-buffer (concat "*eshell: " name "*"))

    (insert (concat "ls"))
    (eshell-send-input)))
(defun eshell/x ()
  (insert "exit")
  (eshell-send-input)
  (delete-window))
(global-set-key (kbd "C-!") 'eshell-here)
(global-set-key [f1] 'eshell)

(setq browse-url-text-browser "w3m")
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;; Ugly, but necessary: filter ANSI escape sequences for a nicer npm experience
(defvar my-ansi-escape-re
  (rx (or ?\233 (and ?\e ?\[))
      (zero-or-more (char (?0 . ?\?)))
      (zero-or-more (char ?\s ?- ?\/))
      (char (?@ . ?~))))

(defun my-nuke-ansi-escapes (beg end)
  (save-excursion
    (goto-char beg)
    (while (re-search-forward my-ansi-escape-re end t)
      (replace-match ""))))

(defun my-eshell-nuke-ansi-escapes ()
  (my-nuke-ansi-escapes eshell-last-output-start eshell-last-output-end))

(add-hook 'eshell-output-filter-functions 'my-eshell-nuke-ansi-escapes t)

;; Mail
(require 'gnus)
(setq mm-verify-option 'always)


;; A saner backup policy
(setq
 backup-by-copying t
 backup-directory-alist
 '(("." . "~/.emacs.d/backup"))
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 create-lockfiles nil
 version-control t)
