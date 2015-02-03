((el-get status "installed" recipe
         (:name el-get :website "https://github.com/dimitri/el-get#readme" :description "Manage the external elisp bits and pieces you depend upon." :type github :branch "master" :pkgname "dimitri/el-get" :info "." :compile
                ("el-get.*\\.el$" "methods/")
                :load "el-get.el"))
 (pymacs status "installed" recipe
         (:name pymacs :description "Interface between Emacs Lisp and Python" :type github :pkgname "pinard/Pymacs" :prepare
                (progn
                  (el-get-envpath-prepend "PYTHONPATH" default-directory)
                  (autoload 'pymacs-load "pymacs" nil t)
                  (autoload 'pymacs-eval "pymacs" nil t)
                  (autoload 'pymacs-exec "pymacs" nil t)
                  (autoload 'pymacs-call "pymacs")
                  (autoload 'pymacs-apply "pymacs"))
                :build
                ("make")))
 (rope status "installed" recipe
       (:name rope :description "A python refactoring library" :post-init
              (el-get-envpath-prepend "PYTHONPATH" default-directory)
              :type git :url "https://github.com/python-rope/rope.git"))
 (ropemacs status "installed" recipe
           (:name ropemacs :description "An Emacs minor mode for using rope python refactoring library in emacs." :post-init
                  (progn
                    (unless
                        (boundp 'pymacs-load-path)
                      (setq pymacs-load-path nil))
                    (add-to-list 'pymacs-load-path default-directory))
                  :depends
                  (rope ropemode)
                  :type git :url "https://github.com/python-rope/ropemacs"))
 (ropemode status "installed" recipe
           (:name ropemode :description "Common parts of ropemacs and ropevim." :post-init
                  (progn
                    (unless
                        (boundp 'pymacs-load-path)
                      (setq pymacs-load-path nil))
                    (add-to-list 'pymacs-load-path default-directory))
                  :type git :url "https://github.com/python-rope/ropemode")))
