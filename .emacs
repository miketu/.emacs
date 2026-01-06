;; .emacs file for Michael Tu



;; My workflow revolves around the following items:
;;   Zotero with betterbibextension (output all reading to a .bib file) and markdown 

;;   EMACS: Org-mode for general notes/documentation with howm as the main engine for quote management
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

;; Load various emacs languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '((R . t)
   (latex .t)
   (python .t)
   ))


;; Pasting images org mode


(defvar jjgr-org-mode-paste-image-width 800) ; https://www.reddit.com/r/emacs/comments/jczcv0/paste_an_image_into_an_org_file_windows/ Allows copy and paste with org
(defun mtu-paste-image (file-name)
  (interactive "F")
  (let ((type (file-name-extension file-name)))
    (unless (member (upcase type) '("JPG" "JPEG" "PNG" "GIF"))
      (setq file-name (concat file-name ".png")))
    (let* ((command (format "(Get-Clipboard -Format Image).save(\"%s\")"
                            (expand-file-name file-name)))
           (output (call-process "powershell.exe" nil "*powershell*" nil "-Command" command)))
      (if (not (zerop output))
          (message "Unable to save image. Probably clipboard is empty.")
        (when jjgr-org-mode-paste-image-width
          (insert (format "#+ATTR_ORG: :width %s\n" 800))) ;;INPUT_VARIABLE: Width of image pasted
        (insert "[[file:" file-name "]]\n")
        (org-display-inline-images)))))




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

(global-set-key (kbd "C-c a") #'org-agenda)

(setq org-agenda-files (directory-files-recursively "C://Dropbox//2026" "\\.org$"))
(setq org-agenda-inhibit-startup t)





;; howm


(use-package howm
  :ensure t
  :init
  (require 'howm-org)
  (setq howm-directory "C:/Dropbox/2026/")
  (setq howm-file-name-format "%Y-%m-%d-%H%M%S log.org")
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

(setopt howm-recent-excluded-files-regexp
        (concat
         (regexp-quote (expand-file-name "0000-00-00-000000.org"
         ))))



(global-set-key [f1] 'howm-menu)




;; Browser and Checkup

(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe")

(defun routine-checkup ()
  (interactive)
  (browse-url "https://theoldreader.com/")
  (browse-url "https://mail.google.com/mail/u/0/#inbox")
  (browse-url "https://web.whatsapp.com/")
  (browse-url "https://messages.google.com/web/")
  (browse-url "[GOOGLE PHOTO LINK]")
  (browse-url "https://calendar.google.com/calendar/u/0/r")
  )

(global-set-key [f2] 'routine-checkup)



;; Calfw-Settings

(require 'calfw-ical)
(require 'calfw-howm)
(require 'calfw-org)

(defun gcal-open ()
  (interactive)
  (calfw-ical-open-calendar "[GCAL LINK]")
)

(defun gcal-howm ()
  "Organize windows based on howardism article https://www.howardism.org/Technical/Emacs/new-window-manager.html"
  (interactive)
  (delete-other-windows)
  (howm-menu)
  (split-window-horizontally)
  (other-window 1)
  (calfw-ical-open-calendar "[GCAL LINK]")
  (other-window 1)
  )

(global-set-key [f3] 'gcal-howm)




;; Macros I like (https://github.com/cloudstreet-dev/Emacs-for-Goodness-Sake/blob/main/11-macros-registers.md was very helpful) for exegesis
;; Should install SBL fonts as recommended by https://github.com/emacselements/my-ancient-greek-tweaks/blob/main/my-ancient-greek-tweaks.el


(defalias 'bible-verse-labeler
   (kmacro "M-x q u e r y - r e p l a c e - r e g e x p <return> \\ ( 0 - <backspace> <backspace> [ 0 - 9 ] + \\ ) <return> \\ \\ v s { \\ 1 } <return> y q M-b"))
(global-set-key [f5] 'bible-verse-labeler)

(set-fontset-font "fontset-default" 'greek (font-spec :family "SBL BibLit" :size 22))
(set-fontset-font "fontset-default" 'hebrew (font-spec :family "SBL BibLit" :size 25))

;; Default Loading Screen

(howm-menu)
;(gcal-howm)
