;; @author: Thibault BRONCHAIN

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["#2e3436" "#a40000" "#4e9a06" "#c4a000" "#204a87" "#5c3566" "#729fcf" "#eeeeec"])
 '(custom-enabled-themes (quote (tsdh-dark))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
)

(setq android_project (getenv "ANDROID_PROJECT"))
;;(setq android_project "toto")
(setq user (getenv "USER"))

(if (string-equal android_project nil)
    (progn
      )
    (progn
      (load-file (format "/Users/%s/.emacs.d/modules/cedet/cedet-devel-load.el" user))


      (custom-set-variables
       '(semantic-default-submodes (quote (global-semantic-idle-completions-mode global-semantic-idle-scheduler-mode global-semanticdb-minor-mode global-semantic-idle-summary-mode global-semantic-mru-bookmark-mode)))
       '(semantic-idle-scheduler-idle-time 10)
       ;; '(semanticdb-javap-classpath (quote ("/usr/lib/jvm/jdk1.6.0_37/jre/lib/rt.jar"))) ;; use this on ubuntu linux (and probably other linuxes distributions)
       '(semanticdb-javap-classpath (quote ("/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK/Classes/classes.jar"))) ;; use this on OSX
       )

      ;; 1. enable it
      (semantic-mode 1)
      (global-semanticdb-minor-mode 1)

      ;; 2. use ede to manage project
      (global-ede-mode t)

      (setq classpath (format "/Users/%s/bin/adt/sdk/platforms/android-19/android.jar" user))

      (ede-java-root-project android_project
			     :file (format "/Users/%s/Sources/android/%s/build.xml" user android_project)
;;			     :file "/Users/thibaultbronchain/Sources/android/toto/build.xml"
			     :srcroot '("src")
			     :classpath '("/Users/thibaultbronchain/bin/adt/sdk/platforms/android-19/android.jar"))
			     :classpath '(classpath)
;;			     :classpath '((format "/Users/%s/bin/adt/sdk/platforms/android-19/android.jar" user)))

      ;; 3. enable db-javap
      (require 'semantic/db-javap)

      ;; 4. enable auto-complete
      (require 'semantic/ia)
      (defun my-cedet-hook ()
	;; functions which are disabled
	;; (local-set-key "\C-cp" 'semantic-ia-show-summary)
	;; (local-set-key "\C-cl" 'semantic-ia-show-doc)
	;; (local-set-key "." 'semantic-complete-self-insert)
	;; (local-set-key ">" 'semantic-complete-self-insert)
;;	(local-set-key "\M-n" 'semantic-ia-complete-symbol-menu)  ;; auto completet by menu
	(local-set-key "\C-c/" 'semantic-ia-complete-symbol)
	(local-set-key "\C-cb" 'semantic-mrub-switch-tags)
	(local-set-key "\C-cj" 'semantic-ia-fast-jump)
	(local-set-key "\C-cR" 'semantic-symref)
	(local-set-key "\C-cr" 'semantic-symref-symbol)
	)
      (add-hook 'c-mode-common-hook 'my-cedet-hook)

      ;; 5. use four spaces to indent java source
      (defun my-java-mode-hook ()
	(setq indent-tabs-mode nil)
	(setq tab-width 4)
	)
      (add-hook 'java-mode-hook 'my-java-mode-hook)
      )
  )


;; MELPA
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(when (< emacs-major-version 24)
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)
(unless (package-installed-p 'scala-mode2)
  (package-refresh-contents) (package-install 'scala-mode2))

;; el-get
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-thibault/recipes")
(el-get 'sync)


;; general modules
(add-to-list 'load-path (format "/Users/%s/.emacs.d/modules" user))

;; Old Scala mode
;;(add-to-list 'load-path (format "/Users/%s/.emacs.d/modules/scala-emacs" user))
;;(require 'scala-mode-auto)


;; Php mode
(require 'php-mode)

(setq-default indent-tabs-mode nil)

(global-font-lock-mode t) ;get colors without typing font-lock-mode
(setq font-lock-maximum-decoration t) ;more colors

;;(if first-time
    (setq auto-mode-alist
          (append '(("\\.cpp$" . c++-mode)
                     ("\\.hpp$" . c++-mode)
                     ("\\.h$" . c++-mode)
                     ("\\.lsp$" . lisp-mode)
                     ("\\.scm$" . scheme-mode)
                     ("\\.pl$" . perl-mode)
                     ("\\.php$" . php-mode)
                     ("\\.inc$" . php-mode)
                     ) auto-mode-alist))
;;)

;; Highlight auto syntax
(defvar font-lock-auto-mode-list
  (list 'c-mode 'c++-mode 'c++-c-mode 'emacs-lisp-mode 'lisp-mode 'perl-mode 'scheme-mode)
  "mode activated with auto highlight")

(defvar font-lock-mode-keyword-alist
  '((c++-c-mode . c-font-lock-keywords)
    (perl-mode . perl-font-lock-keywords))
  "keywords/modes association")

(defun font-lock-auto-mode-select ()
  (if (memq major-mode font-lock-auto-mode-list)
      (progn
	(font-lock-mode t))
    )
  )

(global-set-key [M-f1] 'font-lock-fontify-buffer)

;; New dabbrev
;;(require 'new-dabbrev)
(setq dabbrev-always-check-other-buffers t)
(setq dabbrev-abbrev-char-regexp "\\sw\\|\\s_")
(add-hook 'emacs-lisp-mode-hook
          '(lambda ()
	     (set (make-local-variable 'dabbrev-case-fold-search) nil)
	     (set (make-local-variable 'dabbrev-case-replace) nil)))
(add-hook 'c-mode-hook
          '(lambda ()
	     (set (make-local-variable 'dabbrev-case-fold-search) nil)
	     (set (make-local-variable 'dabbrev-case-replace) nil)))
(add-hook 'text-mode-hook
          '(lambda ()
	     (set (make-local-variable 'dabbrev-case-fold-search) t)
	     (set (make-local-variable 'dabbrev-case-replace) t)))

;; Mode C++ and C...
(defun my-c++-mode-hook ()
  (setq tab-width 4)
  (define-key c++-mode-map "\C-m" 'reindent-then-newline-and-indent)
  (define-key c++-mode-map "\C-ce" 'c-comment-edit)
  (setq c++-auto-hungry-initial-state 'none)
  (setq c++-delete-function 'backward-delete-char)
  (setq c++-tab-always-indent t)
  (setq c-indent-level 4)
  (setq c-continued-statement-offset 4)
  (setq c++-empty-arglist-indent 4))

(defun my-c-mode-hook ()
  (setq tab-width 4)
  (define-key c-mode-map "\C-m" 'reindent-then-newline-and-indent)
  (define-key c-mode-map "\C-ce" 'c-comment-edit)
  (setq c-auto-hungry-initial-state 'none)
  (setq c-delete-function 'backward-delete-char)
  (setq c-tab-always-indent t)
  ;; indentation style BSD
  (setq c-indent-level 4)
  (setq c-continued-statement-offset 4)
  (setq c-brace-offset -4)
  (setq c-argdecl-indent 0)
  (setq c-label-offset -4))


;; Turn off the startup message.
(setq inhibit-startup-message 1)

;; Hide menu-bar.
;;(menu-bar-mode)

;; Show line-number/column-number in the mode line.
(line-number-mode 1)
(column-number-mode 1)

;; Show time in the mode line.
(setq display-time-24hr-format 1)
(display-time)

;; Highlight matching parens.
(require 'paren)
(setq show-paren-delay 0)
(show-paren-mode)

;; Highlight region.
(transient-mark-mode 1)

;; Hightlight current line.
(global-hl-line-mode t)
(custom-set-faces '(highlight ((t (:weight bold)))))

;; Show/delete trailing spaces.
(setq-default show-trailing-whitespace 1)
(global-set-key [f6] 'delete-trailing-whitespace)

;; Mode shortcuts.
(global-set-key [f3] 'c-mode)
(global-set-key [f4] 'ruby-mode)
(global-set-key [f5] 'compile)

;; Navigation shortcuts.
(global-set-key (kbd "ESC <up>") '(lambda () (interactive) (other-window -1)))
(global-set-key (kbd "ESC <down>") 'other-window)
(global-set-key (kbd "ESC <left>") '(lambda () (interactive) (other-window -1)))
(global-set-key (kbd "ESC <right>") 'other-window)

;; Ruby mode.
(autoload 'ruby-mode "ruby-mode" "Ruby source files' editing mode")
(add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))

;; Tem opt
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
(defun to-bottom () (interactive) "Recenter screen so that currentline is on the bottom of the screen"
  (recenter -1)
  )
(defun set-key-to-bottom () (interactive)
  (local-set-key "\C-l" 'to-bottom)
  )
(add-hook 'shell-mode-hook 'set-key-to-bottom)

;;(add-to-list 'load-path (format "/Users/%s/.emacs.d/modules/auto-complete" user))
;;(require 'auto-complete-config)
;;(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
;;(ac-config-default)

(when (fboundp 'winner-mode)
  (winner-mode 1))





;; company mode
;;(add-to-list 'load-path (format "/Users/%s/.emacs.d/modules/company-mode" user))
;;(require 'company)
(add-hook 'after-init-hook 'global-company-mode)
(global-set-key "\M-n" 'company-complete)  ;; auto completet by menu
(setq company-idle-delay 500000000)

(eval-after-load 'company
  '(add-to-list 'company-backends 'company-irony))

;; (optional) adds CC special commands to `company-begin-commands' in order to
;; trigger completion at interesting places, such as after scope operator
;;     std::|
(add-hook 'irony-mode-hook 'company-irony-setup-begin-commands)

;; anaconda
(add-hook 'python-mode-hook 'anaconda-mode)

;; jedi
(add-hook 'python-mode-hook 'jedi:setup)

;;(add-to-list 'load-path
;;              "~/.emacs.d/modules/yasnippet")
;;(require 'yasnippet)
;;(yas-global-mode 1)
;;
;;
;;
;;
;;(add-to-list 'load-path (format "/Users/%s/.emacs.d/modules/auto-complete" user))
;;(require 'auto-complete-config)
;;(ac-config-default)
;;
;;(add-to-list 'ac-dictionary-directories (format "/Users/%s/.emacs.d/ac-dict" user))
;;
;;(add-to-list 'load-path (format "/Users/%s/.emacs.d/modules/auto-complete-clang" user))
;;(require 'auto-complete-clang)
;;
;;(setq ac-auto-start nil)
;;(setq ac-quick-help-delay 0.5)
;;(ac-set-trigger-key "ESC TAB")
;;;;(define-key ac-mode-map  [(control tab)] 'auto-complete)
;;(defun my-ac-config ()
;;  (setq-default ac-sources '(ac-source-abbrev ac-source-dictionary ac-source-words-in-same-mode-buffers))
;;  (add-hook 'emacs-lisp-mode-hook 'ac-emacs-lisp-mode-setup)
;;;;  (add-hook 'c-mode-common-hook 'ac-cc-mode-setup)
;;  (add-hook 'ruby-mode-hook 'ac-ruby-mode-setup)
;;  (add-hook 'css-mode-hook 'ac-css-mode-setup)
;;  (add-hook 'auto-complete-mode-hook 'ac-common-setup)
;;  (global-auto-complete-mode t))
;;(defun my-ac-cc-mode-setup ()
;;  (setq ac-sources (append '(ac-source-clang ac-source-yasnippet) ac-sources)))
;;(add-hook 'c-mode-common-hook 'my-ac-cc-mode-setup)
;;;; ac-source-gtags
;;(my-ac-config)

;; HN
;;(require 'package)
;;(add-to-list 'package-archives
;;             '("marmalade" .
;;               "http://marmalade-repo.org/packages/"))
;;(package-initialize)
;; HN mode
;;(add-to-list 'load-path (format "/Users/%s/.emacs.d/modules/hackernews.el" user))
;;(require 'hackernews)

;;EOF
