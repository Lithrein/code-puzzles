(in-package :day01)

(defun file->lines (input)
  "This function takes a file and converts it into a list of lines"
  (let ((lines '()))
  (do ((line (read-line input nil) (read-line input nil)))
    ((eq line nil))
    (setf lines (cons line lines)))
  (reverse lines)))

(defun day01-1 (input)
  (loop for a in input
        for b in (cdr input)
        count (> b a)))

; (defun day01-1 (input)
;   (loop for (a b) on input count (and b (> b a))))

(defun day01-2 (input)
  (loop for a in input
        for d in (cdddr input)
        count (> d a)))

; (defun day01-2 (input)
;   (loop for (a b c d) on input count (and d (> d a))))

(with-open-file (foo "../inputs/day01")
  (let ((in (mapcar #'parse-integer (file->lines foo))))
    (format t "Day01:~%Solution 1: ~a~%Solution 2: ~a~%"
            (day01-1 in)
            (day01-2 in))))
