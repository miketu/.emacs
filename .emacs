
;; .emacs file for Michael Tu



;; My workflow revolves around the following items:
;;   EMACS: Org-mode for general notes/documentation with howm as the main engine
;;   Zotero and betterbibextension (output all reading to a .bib file)
;;   R language  (Decent analysis software, I'm strongest in this language, I like how it resembles mathematics. )
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
;; I usually save files by year (YYYY-MM-DD format) and then search using helm-grep. Try to save plaintext as much as possible, and if neccessary I'll save images.  There is also helm-do-grep-ag for a wider search or org-agenda

(setq-default org-display-custom-times t)
(setq org-time-stamp-custom-formats '("<%Y-%m-%d>" . "<%Y-%m-%d %H:%M>"))  

(setq initial-major-mode 'org-mode) ;; Startup as org mode file in scratch buffer
(with-eval-after-load 'org       ;; Visual Line Mode by Default Org
  (setq org-startup-indented t)     ; Enable org-ident-mode by default
  

(add-hook 'org-mode-hook #'visual-line-mode)) ;;Make org start in visual line mode

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

;;; Org-Agenda related configuration


(setq org-agenda-files (directory-files-recursively "C://Dropbox//2025" "\\.org$"))
(setq org-agenda-inhibit-startup t)

;; Load various emacs languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '((R . t)
   (latex .t)
   (python .t)
   ))
  



;; howm


(use-package howm
  :ensure t
  :init
  (require 'howm-org)
  (setq howm-directory "C:/Dropbox/2025/")
  (setq howm-file-name-format "%Y-%m-%d-%H%M%S.org")
  ;; Makes HOWM compatible with org-mode
  (setq howm-view-title-header "*")
  ;(setq howm-dtime-format (format "%s" (cdr org-time-stamp-custom-formats)))
  ;(setq howm-view-title-header "#+title: ")
  (setq howm-dtime-format (format "#+date: %s" (cdr org-time-stamp-custom-formats)))
  (setq howm-insert-date-format "<%s>")
;
  )
(defadvice howm-exclude-p (around howm-suffix-only (filename) activate) ;; From https://github.com/kaorahi/howm/issues/83#issuecomment-3181303383
  ad-do-it
  (setq ad-return-value
        (or ad-return-value
            ;; include directories and *.howm
            (not (or (file-directory-p filename)
                     (string-match "[.]org$" filename))))))


(howm-menu)


;; Macros I like (https://github.com/cloudstreet-dev/Emacs-for-Goodness-Sake/blob/main/11-macros-registers.md was very helpful)
(defalias 'bible-verse-labeler
   (kmacro "M-x q u e r y - r e p l a c e - r e g e x p <return> \\ ( 0 - <backspace> <backspace> [ 0 - 9 ] + \\ ) <return> \\ \\ v s { \\ 1 } <return> y q M-b"))
(global-set-key [f5] 'bible-verse-labeler)
