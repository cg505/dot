;;; C-c SPC: jump to any visible word
;;; M-z: like C-c SPC but deletes all characters between and including point and the destination char
;;; C-=: expand reigon to surrounding sexp
;;; C-+: undo C-=
;;; C-M-w: copy sexp to kill ring, appending if called repeatedly

(require 'cl)

;;; avy jump mode
(global-set-key (kbd "C-c SPC") #'avy-goto-word-1)
(global-set-key (kbd "C-c '") #'avy-goto-char)

;; save zapped chars to kill ring
(with-eval-after-load 'avy-zap
  (setf avy-zap-function #'kill-region))
(global-set-key (kbd "M-z") #'avy-zap-to-char-dwim)

;;; jump to line
(global-set-key (kbd "C-x g") #'goto-line)


;;; expand-region
(global-set-key (kbd "C-=") #'er/expand-region)
(global-set-key (kbd "C-+") #'er/contract-region)


;;; appending sexp copy
(defvar kotct/sexp-copy-count
  0
  "Number of commands since last `kotct/sexp-copy-as-kill'.")

(add-hook 'pre-command-hook (lambda () (incf kotct/sexp-copy-count)))

(defun kotct/sexp-copy-as-kill (arg)
  "Save next sexp as if killed, but don't kill it, appending if called repeatedly."
  (interactive "p")
  (message "%s" arg)
  (let ((beg (point)))
    (let ((parse-sexp-ignore-comments t))
      (forward-sexp arg))
    (if (= 1 kotct/sexp-copy-count)
        (append-next-kill))
    (clipboard-kill-ring-save beg (point))
    (setq kotct/sexp-copy-count 0)))

(global-set-key (kbd "C-M-w") #'kotct/sexp-copy-as-kill)

;; Always delete trailing whitespace before saving.
(add-hook 'before-save-hook #'delete-trailing-whitespace)

(defun kotct/capitalize-word-without-downcase ()
  "Capitalize from point to end of word, like `capitalize-word', but
without downcasing the rest of the word after point."
  (interactive)
  (let (to-insert (upcase (char-after)))
    (delete-char 1)
    (insert to-insert)))

(global-set-key (kbd "M-S-c") #'kotct/capitalize-word-without-downcase)

(provide 'text)
