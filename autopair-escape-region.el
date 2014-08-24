;;; autopair-escape-region.el --- Extends autopair

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;;; Commentary:
;;
;; When `autopair-escape-region-when-quoting' (enabled by default) is
;; true, then it will appropriately quote the string. For example
;; selecting the following string:
;;
;; This is a test of the quoting system, "this is only a test"
;;
;; And pressing quote, gives:
;;
;; "This is a test of the quoting system, \"this is only a test\""
;;
;;  Quoting the whole phrase again gives:
;;
;; "\"This is a test of the quoting system, \\\"this is only a test\\\"\""
;;
;;;; Installation:
;; Add
;; (require 'autopair-escape-region)
;; to your initialization file.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;;; Code: 
;; 
;;

(require 'autopair)

(defcustom autopair-escape-region-when-quoting 't
  "When regions are selected, quote that region"
  :type 'boolean
  :group 'autopair)

(defun autopair-get-char-by-class+ (class-string)
  "Gets char from current syntax table."
  (dotimes (char 256)
    (let* ((syntax-entry (aref (syntax-table) char))
           (class (and syntax-entry
                       (syntax-class syntax-entry)))
           (pair (and syntax-entry
                      (cdr syntax-entry))))
      (when (eq class (car (string-to-syntax class-string)))
        (return char))
      ))
  )
(defun autopair-get-escape-char+ ()
  "Gets escape char from current syntax table."
  (autopair-get-char-by-class+ "\\")
  )
(defun autopair-get-quote-char+ ()
  "Gets quote char from current syntax table."
  (autopair-get-char-by-class+ "\"")
  )

(defun autopair-try-escape-region+ (action pair pos-before region-before)
  (when autopair-escape-region-when-quoting
    (if (eq pair (autopair-get-quote-char+))
        (progn
          (save-excursion
            (save-restriction
              (narrow-to-region (+ (car region-before) 1) (+ (cdr region-before) 1))
              (message (buffer-string))
              (goto-char (point-min))
              (while (search-forward-regexp
                      (concat "\\([" (string (autopair-get-quote-char+)) (string (autopair-get-escape-char+)) "]\\)")
                      nil
                      t)
                (replace-match (concat (string (autopair-get-escape-char+)) (string (autopair-get-escape-char+)) "\\1"))
                )
              (- (point-max) 1))
            )
          )
      )
    )
  )

(defadvice autopair-default-handle-wrap-action (before autopair-default-handle-wrap-action+ activate)
  (let* ((new-end (apply 'autopair-try-escape-region+ (ad-get-args 0))))
    (if new-end
        (ad-set-arg 3 `(,(car (ad-get-arg 3)) . ,new-end)))))

(provide 'autopair-escape-region)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; auto-pair+.el ends here
