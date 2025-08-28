
;; .emacs file for Michael Tu



;; My workflow revolves around the following items:
;;   EMACS: Howm, Org-mode for general notes/documentation
;;   Zotero and betterbibextension (output all reading to a .bib file)
;;   R language  (Decent analysis software, I'm strongest in this language, I also play around using tinytex)
;;   LaTeX is interacted with via EMACS or R, but having a general idea of how to use it is probably helpful too. 
;;   File syncing service (I use dropbox because I have an old account, but one can use syncthing r an equivalent resource)
;;   Microsoft Word/Powerpoint/Excel is neccesary for most places I've worked at, so I can't avoid it. 


;; Refresher Hints for EMACS
;; Hints: Use M-x customize-group if you need to something
;; Hints: Emacs dired is very useful for browsing/finding things



;; Emacs Defaults I Like			    
(setq make-backup-files nil) ; Remove backup files
(setq visible-bell t) ;;Replace sound bell with visible bell
(setq inhibit-splash-screen t) ;; Splash Screen
(setq inhibit-startup-message t) ;; Disable startup message
(tool-bar-mode 0) ;; Disable toolbar
(scroll-bar-mode 0) ;; Disable scrollbar
(menu-bar-mode 0) ;; Disable menubar
(setq-default cursor-type 'bar)  ;; Make the cursor a bar instead of a block
(setq initial-scratch-message "") ;; Make Startup blank
(fset 'yes-or-no-p 'y-or-n-p) ;; Don't need yes or no, can do y or n 
(require 'package) (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t) ;; Melpa stuff

;; Supposed Speed Optimizations (see https://github.com/cloudstreet-dev/Emacs-for-Goodness-Sake/blob/main/04-configuration.md)
;; Windows specific
;; Faster startup
(setq gc-cons-threshold most-positive-fixnum)
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (expt 2 23))))

(defvar my--file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq file-name-handler-alist my--file-name-handler-alist)))

(when (fboundp 'native-compile-async)
  (setq package-native-compile t)
  (setq native-comp-async-report-warnings-errors nil))
(when (eq system-type 'windows-nt)
  (setq w32-get-true-file-attributes nil)  ; Faster file operations
  (setq inhibit-compacting-font-caches t)) ; Faster fonts

;; Helm Configuration
;; Helpful search query: C-x C-f -> C-u C-s -> *.org -> [SEARCH STRING] 

(require 'helm)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x C-f") 'helm-find-files) ;; C-u C-s to do mega search of files




;; Michael's Org Mode Configurations
;; I usually save files by year (YYYY-MM-DD format) and then search using helm-grep. Try to save plaintext as much as possible, and if neccessary I'll save images.  There is also helm-do-grep-ag for a wider search.

(setq-default org-display-custom-times t)
(setq org-time-stamp-custom-formats '("<%Y-%m-%d>" . "<%Y-%m-%d %H:%M>"))  

(setq initial-major-mode 'org-mode) ;; Startup as org mode file in scratch buffer
(with-eval-after-load 'org       ;; Visual Line Mode by Default Org
  (setq org-startup-indented t)     ; Enable org-ident-mode by default
  

(add-hook 'org-mode-hook #'visual-line-mode)) ;;Make org start in visual line mode
(add-hook 'org-mode-hook 'howm-mode) ;; Make org compatible with howm

;; ORG Present settings
 
(setq visual-fill-column-width 110
      visual-fill-column-center-text t)

(eval-after-load "org-present"
  '(progn
     (add-hook 'org-present-mode-hook
               (lambda ()
                 (org-present-big)
                 (org-display-inline-images)
		 (menu-bar-mode 0)
		 (scroll-bar-mode 0)
		 (visual-fill-column-mode 1)
		 (visual-line-mode 1)
                 ))
     (add-hook 'org-present-mode-quit-hook
               (lambda ()
                 (org-present-small)
                 (org-remove-inline-images)
                 (org-present-read-write)
		 (menu-bar-mode 1)
		 (scroll-bar-mode 1)
		 (visual-fill-column-mode 0)
		 (visual-line-mode 1)
		 ))))

;; Load various emacs languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '((R . t)
  (latex .t)))
  


;; HOWM Configurations


(use-package howm
  :ensure t
  :init
  (require 'howm-org)
  (setq howm-directory "C:/Dropbox/2025/2025_log/")
  (setq howm-file-name-format "%Y-%m-%d-%H%M%S.org")
  ;; Makes HOWM compatible with org-mode
  (setq howm-view-title-header "*")
  ;(setq howm-dtime-format (format "%s" (cdr org-time-stamp-custom-formats)))
  ;(setq howm-view-title-header "#+title: ")
  (setq howm-dtime-format (format "#+date: %s" (cdr org-time-stamp-custom-formats)))
  (setq howm-insert-date-format "<%s>")

  )


(howm-menu)


;; Macros I like (https://github.com/cloudstreet-dev/Emacs-for-Goodness-Sake/blob/main/11-macros-registers.md was very helpful)
(defalias 'bible-verse-labeler
   (kmacro "M-x q u e r y - r e p l a c e - r e g e x p <return> \\ ( 0 - <backspace> <backspace> [ 0 - 9 ] + \\ ) <return> \\ \\ v s { \\ 1 } <return> y q M-b"))
(global-set-key [f5] 'bible-verse-labeler)



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(leuven-dark))
 '(custom-safe-themes
   '("9a1ab6610e154efdc085ef2244a0b9b2a89eb35ff87b9c4db55714668e1fc89e" default))
 '(org-fold-core-style 'overlays)
 '(package-selected-packages
   '(heroku-theme calfw-ical calfw calfw-howm howm magit casual visual-fill-column org-modern org-present pdf-tools auctex elfeed-web elfeed-tube csv-mode ess zotxt helm-org-ql helm-org-rifle helm-ag helm))
 '(visual-fill-column-center-text t t)
 '(visual-fill-column-width 500 t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
