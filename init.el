(require 'package)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
(setq package-enable-at-startup nil)
(package-initialize)

;; Enable Evil
(add-to-list 'load-path "~/.emacs.d/evil")
(require 'evil)
(evil-mode 1)

;; undo-tree
(add-to-list 'load-path "~/.emacs.d/lisp/")
(require 'undo-tree)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (paredit ac-slime slime evil jedi iedit flycheck))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; flycheck
;;(use-package flycheck
  ;;:ensure t
  ;;:init (global-flycheck-mode))


;; 
;; (bind-keys*
;;      ("C-l" . iedit-mode))

(load-theme 'adwaita t)
;;(load-theme 'wheatgrass t)

(defun on-after-init ()
  (unless (display-graphic-p (selected-frame))
    (set-face-background 'default "unspecified-bg" (selected-frame))))

(add-hook 'window-setup-hook 'on-after-init)

(menu-bar-mode -1)
;;(toggle-scroll-bar -1)
(yas-global-mode 1) 

(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)    

(setq inferior-lisp-program "/usr/bin/sbcl --noinform")

(global-set-key (kbd "M-h") 'slime-eval-defun)


(setq inferior-lisp-program "/usr/bin/sbcl")
(require 'slime)

(slime-setup '(slime-fancy slime-tramp slime-asdf))
(slime-require :swank-listener-hooks)   

(add-hook 'emacs-lisp-mode-hook       'enable-paredit-mode)
(add-hook 'lisp-mode-hook             'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook 'enable-paredit-mode)

(add-hook 'slime-mode-hook (lambda () (auto-complete-mode t)))
(add-hook 'slime-mode-hook 'set-up-slime-ac)
(add-hook 'slime-repl-mode-hook 'set-up-slime-ac)
(eval-after-load "auto-complete" '(add-to-list 'ac-modes 'slime-repl-mode))

(defun last-sexp ()
  (buffer-substring-no-properties
   (save-excursion (backward-sexp)
		   (point))
   (point)))


(defun my-eval-insert-as-comment ()
  (interactive)
  (newline)
  (previous-line)
  (slime-eval-print-last-expression (last-sexp))
  (delete-indentation)
  (beginning-of-line)
  (insert ";; ⇒  ")
  (end-of-line))

(defvar my-leader-map (make-sparse-keymap) "Keymap for \"leader key\" shortcuts.")
(define-key my-leader-map "e" 'my-eval-insert-as-comment)
(define-key my-leader-map "(" 'paredit-wrap-round)
(define-key my-leader-map "(" 'paredit-wrap-sexp)
(define-key my-leader-map ";" 'paredit-semicolon)
(define-key my-leader-map "[" 'paredit-wrap-square)
(define-key my-leader-map "{" 'paredit-wrap-curly)
(define-key my-leader-map "b" 'paredit-forward-barf-sexp)
(define-key my-leader-map "f" 'paredit-forward-slurp-sexp)
(define-key my-leader-map "x" 'paredit-kill)
;;(define-key my-leader-map "F" 'paredit-backward-slurp-sexp)
;;(define-key my-leader-map "B" 'paredit-backward-barf-sexp)
(define-key my-leader-map "l" 'paredit-forward)
(define-key my-leader-map "h" 'paredit-backward)
(define-key my-leader-map "j" 'paredit-forward-down)
(define-key my-leader-map "k" 'paredit-forward-up)
(define-key my-leader-map "x" 'paredit-splice-sexp-killing-forward)
(define-key my-leader-map "9" 'paredit-splice-sexp)
(define-key evil-normal-state-map (kbd "SPC") my-leader-map)
