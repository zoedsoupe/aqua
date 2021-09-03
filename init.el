;;; package --- The core of config -*- lexical-binding: t -*-
;;;
;;; Commentary:
;;;   My packages

;;;  _ __ ___   __| |___ _ __
;;; | '_ ` _ \ / _` / __| '_ \
;;; | | | | | | (_| \__ \ |_) |
;;; |_| |_| |_|\__,_|___/ .__/
;;;                     |_|

;;; Code:

;; The default is 800 kilobytes.  Measured in bytes.
(setq gc-cons-threshold (* 50 1000 1000))

;; Profile emacs startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "*** Emacs loaded in %s with %d garbage collections."
                     (format "%.2f seconds"
                             (float-time
                              (time-subtract after-init-time before-init-time)))
                     gcs-done)))

;; to load all config files
(add-to-list 'load-path
	     (expand-file-name "elisp" user-emacs-directory)
	     (expand-file-name "libs" user-emacs-directory))

;; straight.el bootstrap
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(use-package mmm-mode
  :straight t)
(require 'mmm-defaults)

(setq mmm-global-mode 'auto
      mmm-submode-decoration-level 0
      mmm-parse-when-idle t)

(add-to-list 'auto-mode-alist '("\\.html.eex\\'" . mhtml-mode))
(add-to-list 'auto-mode-alist '("\\.html.leex\\'" . mhtml-mode))

(defun screenshot (beg end)
  "Take a screenshot of the current region or buffer.
  Region included in screenshot is the active selection, interactively,
  or given by BEG and END. Buffer is used if region spans 0-1 characters."
  (interactive (if (region-active-p)
                   (list (region-beginning) (region-end))
                 (list (point-min) (point-max))))
  (deactivate-mark)

  (require 'screenshot)
  (screenshot--set-screenshot-region beg end)

  (setq screenshot--tmp-file
        (make-temp-file "screenshot-" nil ".png"))

  (screenshot-transient))

(mmm-add-classes
 '((eex-elixir
    :submode elixir-mode
    :face mmm-declaration-submode-face
    :front "<%[#=%]*" ;; regex to find the opening tag
    :back "%>"))) ;; regex to find the closing tag

(mmm-add-mode-ext-class 'mhtml-mode nil 'eex-elixir)
;; Theme----------------------------------
(use-package doom-themes
  :ensure t
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-dracula t)
  (doom-themes-neotree-config)
  (doom-themes-org-config))

(use-package minions
  :straight t
  :init (minions-mode 1))

(use-package centaur-tabs
  :straight t
  :init
  (centaur-tabs-mode t)
  :custom
  (centaur-tabs-set-bar 'over)
  (centaur-tabs-set-icons t)
  (centaur-tabs-height 24)
  (centaur-tabs-set-modified-marker t)
  (centaur-tabs-style "bar")
  (centaur-tabs-modified-marker "•"))

(centaur-tabs-headline-match)

(use-package org-wild-notifier
  :straight t
  :init (org-wild-notifier-mode))

(load-file (let ((coding-system-for-read 'utf-8))
                (shell-command-to-string "agda-mode locate")))

;; general and bootstrap config
(require 'init-dashboard)
(require 'init-basic)
(require 'init-ibuffer)
(require 'init-key)
(require 'init-todo)
(require 'init-functions)
(require 'init-yas)
(require 'init-flycheck)
(require 'init-git)
(require 'init-selectrum)
(require 'init-consult)
(require 'init-projectile)
(require 'init-rainbow)
(require 'init-neotree)
(require 'init-vterm)
(require 'init-paredit)

;; lang-modes
(require 'init-markdown)
(require 'init-org)
(require 'init-emoji)
(require 'init-elixir)

(setq custom-file (concat user-emacs-directory "/custom.el"))

(provide 'init)
;;; init ends here
