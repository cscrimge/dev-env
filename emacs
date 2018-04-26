(global-set-key (kbd "C-z") 'undo)
(global-set-key (kbd "C-x C-d") 'kill-this-buffer)
(global-set-key (kbd "C-l") 'goto-line)
(global-set-key (kbd "C-/") 'comment-region)
(global-set-key (kbd "C-?") 'uncomment-region)

(add-to-list 'load-path "~/.emacs.d/custom-modes/")
(require 'jam-mode)
(require 'yaml-mode)
(require 'qt-pro)

(load "/usr/share/emacs/site-lisp/clang-format-3.7/clang-format.el")
;; (global-set-key [tab] 'clang-format-region)
(eval-after-load 'c++-mode
   '(define-key clang-format [(tab)] 'clang-format-region))


(setq frame-title-format "%b %*%*")
(setq auto-mode-alist
      (append '(
        ("\\.h$" . c++-mode)
        ("\\.fmebun$" . xml-mode)
        ("\\.fmemod$" . xml-mode)
        ("\\.jam$" . jam-mode)
        ("\\Jamfile" . jam-mode)
        ("\\Jamrules" . jam-mode)
        ("\\SConstruct" . python-mode)
        ("\\SConscript" . python-mode)
        ("\\.pr[io]$" . qt-pro-mode)
        )auto-mode-alist))

(defvar compile-command "jam")

(defun untabify-buffer ()
   "Untabify current buffer"
   (interactive)
   (save-excursion (untabify (point-min) (point-max)))
   )

;; no tabs by default. modes that really need tabs should enable
;; indent-tabs-mode explicitly. makefile-mode already does that, for
;; example.
;;(setq-default indent-tabs-mode nil)

;; if indent-tabs-mode is off, untabify before saving
;;(add-hook 'write-file-hooks
;;          (lambda () (if (not indent-tabs-mode)
;;                         (untabify (point-min) (point-max)))))

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(c-basic-offset 3)
 '(c-default-style (quote ((c-mode . "ellemtel") (c++-mode . "ellemtel") (java-mode . "java") (awk-mode . "awk") (other . "gnu"))))
 '(display-buffer-reuse-frames t)
 '(ediff-split-window-function (quote split-window-horizontally))
 '(focus-follows-mouse t)
 '(global-auto-revert-mode t)
 '(hide-ifdef-shadow t)
 '(indent-tabs-mode nil)
 '(lisp-body-indent 3)
 '(mouse-autoselect-window t)
 '(perl-indent-level 3)
 '(pop-up-windows nil)
 '(require-final-newline t)
 '(scroll-bar-mode (quote right))
 '(sh-indentation 3)
 '(show-paren-mode t)
 '(show-trailing-whitespace t)
 '(standard-indent 3)
 '(tab-width 4)
 '(tcl-continued-indent-level 3)
 '(tcl-indent-level 3)
 '(line-number-mode 1)
 '(column-number-mode 1))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "white" :foreground "black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 88 :width normal :foundry "unknown" :family "DejaVu Sans Mono"))))
 '(font-lock-builtin-face ((((class color) (min-colors 88) (background light)) (:foreground "CadetBlue" :weight bold))))
 '(font-lock-comment-delimiter-face ((default (:inherit font-lock-comment-face :weight bold)) (((class color) (min-colors 16)) nil)))
 '(font-lock-comment-face ((((class color) (min-colors 88) (background light)) (:foreground "DarkGreen"))))
 '(font-lock-constant-face ((((class color) (min-colors 88) (background light)) (:foreground "Firebrick"))))
 '(font-lock-doc-face ((t (:inherit font-lock-comment-face))))
 '(font-lock-function-name-face ((((class color) (min-colors 88) (background light)) (:foreground "CadetBlue"))))
 '(font-lock-keyword-face ((((class color) (min-colors 88) (background light)) (:foreground "Navy" :weight bold))))
 '(font-lock-negation-char-face ((t (:foreground "red"))))
 '(font-lock-string-face ((((class color) (min-colors 88) (background light)) (:foreground "Blue"))))
 '(font-lock-type-face ((((class color) (min-colors 88) (background light)) (:foreground "Purple"))))
 '(trailing-whitespace ((((class color) (background light)) (:background "pink1")))))
