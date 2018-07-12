;; Automagically store backups of files
(setf backup-by-copying t
      backup-directory-alist '(("." . "~/.saves"))
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

;; check recovery diff
(defun kotct/recover-file-with-diff ()
  (interactive)
  (let ((orig-file buffer-file-name)
        (auto-save-file (make-auto-save-file-name)))
    (when (when (file-exists-p auto-save-file)
            (with-temp-buffer-window
             (format "*autosave-diff: %s*" (buffer-name)) nil
             (lambda (window _)
               (with-selected-window window
                 (unwind-protect
                     (y-or-n-p "Continue recovery?")
                   (when (window-live-p window)
                     (quit-restore-window window 'kill)))))
             (diff-no-select orig-file auto-save-file nil 'no-async standard-output)))
      (recover-this-file))))

(provide 'backup)
