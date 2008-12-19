(defun homedir (file)
  "Allows Emacs to be started with from another user's account by setting the
EMACSUSER environment variable to the username of the account where this init
file exists (should be combined with the -u command line option).
This function is used to resolve all file locations below."
  (let* ((user (or (getenv "EMACSUSER")
                   (getenv "USER")))
         (filename (concat "~" user "/" file)))
    (expand-file-name filename)))

;; Set up list of config files.
(setq custom-file (homedir ".emacs.custom"))
(defvar mhj-init-file (homedir ".emacs")
  "My main config file.")
(defvar mhj-global-config-file (homedir ".emacs.global")
  "Main config file shared between emacs installations.")
(defvar mhj-local-config-file (homedir ".emacs.local")
  "Config file with site-specific settings.")
(defvar mhj-init-files (list custom-file
                             mhj-global-config-file 
                             mhj-local-config-file)
  "A list of all the various emacs config files that will be
loaded/compiled.")

(defvar mhj-emacs-lib-dir (homedir ".config/emacs/lib")
  "Base directory for my installed emacs packages/libraries.")
(defvar mhj-local-config-dirs (list mhj-emacs-lib-dir)
  "A list of the directories containing packages that should be
loaded/compiled.")

;; A couple of useful functions related to emacs config files, loaded
;; packages, etc.

;; FIXME (?) - this relies on you specifying all your package dirs in
;; advance, instead of recursing into each one...  Not sure which
;; would be better on the whole.

;; FIXME - byte-recompile-directory recurses into all sub-directories,
;; which I'm not sure that I want to happen automatically.  Especially
;; since, for the moment, this appears to negate half the point of
;; this function!
(defun mhj-compile-init-files ()
  "Compile all the various files that make up my environment."
  (interactive)
  (byte-compile-file mhj-init-file)
  (mapcar #'(lambda (file)
              (and (file-readable-p file)
                   (byte-compile-file file)))
          mhj-init-files)
  (mapcar #'(lambda (dir)
              (byte-recompile-directory dir 0))
          mhj-local-config-dirs))

(defun mhj-add-local-config-dir (dir)
  "Add a directory to the load path and to the list of local package
directories."
  (let ((full-path (concat mhj-emacs-lib-dir dir)))
    (when (and (file-readable-p full-path)
               (file-directory-p full-path))
      (add-to-list 'load-path full-path)
      (add-to-list 'mhj-local-config-dirs full-path))))

(add-to-list 'load-path mhj-emacs-lib-dir)
(mhj-add-local-config-dir "/mmm")
(mhj-add-local-config-dir "/psgml")
(mhj-add-local-config-dir "/nxml")
(mhj-add-local-config-dir "/slime")
(mhj-add-local-config-dir "/erlang")
(mhj-add-local-config-dir "/w3m")
(mhj-add-local-config-dir "/elib")
(mhj-add-local-config-dir "/ocaml")
(mhj-add-local-config-dir "/tuareg")

;; Finally, load each of my init files, in the specified order.
(mapcar #'(lambda (file) (load file 'noerror))
        mhj-init-files)
