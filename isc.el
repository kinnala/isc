(defun isc-save-region ()
  (if (region-active-p)
      (let ((region-contents-string
             (buffer-substring (region-beginning) (region-end))))
        (setq isc-region-content region-contents-string))
    (setq isc-region-content (buffer-string))))

(defun isc-shell-cmd (cmd)
  (shell-command (concat "cat "
                         isc-temp-file
                         " | "
                         cmd) "*isc*"))

(defun isc-update-func (beg end len)
  (let ((str (minibuffer-contents)))
    (isc-shell-cmd str)))

(defun isc-remove-update-hook ()
  (remove-hook 'after-change-functions #'isc-update-func))

(defun isc-run-cmd ()
  (interactive)
  (isc-save-region)
  (setq isc-temp-file (make-temp-file "isc" nil nil isc-region-content))
  (with-help-window "*isc*")
  (minibuffer-with-setup-hook
      (lambda ()
        (add-hook 'after-change-functions #'isc-update-func)
        (add-hook 'minibuffer-exit-hook #'isc-remove-update-hook))
    (isc-shell-cmd (read-string (concat "cat "
                                        isc-temp-file
                                        " | ")))))
