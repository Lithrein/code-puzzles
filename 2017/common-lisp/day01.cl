#! /usr/bin/sbcl --script

(defun day01 (input offset)
  "This function takes an `input` array of digits which is considered as a
  circular buffer. If the current digit is equals to the one `offset` cells
  forward then the current digit is addded to the final sum."
  (let* ((len (length input)))
    (loop for i from 0 to (- len 1) sum
      (let ((cur (aref input i))
            (nxt (aref input (mod (+ i offset) len))))
        (if (equal cur nxt) (- (char-code cur) 48) 0)))))

(defun day01-1 (input) (day01 input 1))
(defun day01-2 (input) (day01 input (/ (length input) 2)))

(with-open-file (foo "../inputs/day01")
  (let ((in (read-line foo)))
    (format t "Solution 1: ~a~%Solution 2: ~a~%"
            (day01-1 in)
            (day01-2 in))))
