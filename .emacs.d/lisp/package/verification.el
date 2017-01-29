(require 'cl)

;; check to make sure all dependencies are installed before continuing
(defun kotct/check-dependency-list ()
    (if (not (every #'package-installed-p kotct/dependency-list))
        (progn
          (y-or-n-p "You don't seem to have all necessary packages installed. Install them?\n(Your emacs will probably not work if you don't.)")
          ;; since loaddefs don't get evaluated until after init, we must
          ;; manually require packup (normally loaded via autoloads)
          (require 'packup)
          (kotct/packup-install-dependencies nil))))

(kotct/check-dependency-list)

(provide 'verification)
