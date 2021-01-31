#! /usr/bin/sbcl --script

; --- Day 2: Corruption Checksum ---

(defun list->string (list)
  "This function takes a list of characters and convert it into a string"
  (let ((str (make-string (length list)))
        (idx 0))
    (loop for c in list do
      (setf (aref str idx) c)
      (setf idx (+ idx 1)))
    str))

(defun words (str)
  "This function splits a sentence into a list of words, where a word is
  sequence of contiguous characters without spaces or tabs."
  (let ((sentence '())
        (word '()))
    (loop for c across str do
        (if (and (or (equal c #\tab) (equal c #\ )) (not (equal word '())))
          (prog1
            (setf sentence (cons (list->string (reverse word)) sentence))
            (setf word '()))
          (if (and (not (equal c #\ )) (not (equal c #\tab)))
            (setf word (cons c word)))))
    (reverse
      (if (not (equal word '()))
       (cons (list->string (reverse word)) sentence)
       sentence))))

(defun minmax (list)
  "This function returns a list with the min and the max of a list"
  (let ((min (car list))
        (max (car list)))
    (loop for i in list do
      (setf min (if (< i min) i min))
      (setf max (if (> i max) i max)))
  (list max min)))

; As you walk through the door, a glowing humanoid shape yells in your
; direction. "You there! Your state appears to be idle. Come help us repair the
; corruption in this spreadsheet - if we take another millisecond, we'll have to
; display an hourglass cursor!"
;
; The spreadsheet consists of rows of apparently-random numbers. To make sure
; the recovery process is on the right track, they need you to calculate the
; spreadsheet's checksum. For each row, determine the difference between the
; largest value and the smallest value; the checksum is the sum of all of these
; differences.
;
; For example, given the following spreadsheet:
;
; 5 1 9 5 ; min: 1, max: 9, diff: 8
; 7 5 3   ; min: 3, max: 7, diff: 4
; 2 4 6 8 ; min: 2, max: 8, diff: 6
; sum of diffs: 18

(defun day02-1 (input)
  (let ((sum 0))
  (do ((line (read-line input nil) (read-line input nil)))
    ((eq line nil))
    (setf sum (+ sum (reduce #'- (minmax (mapcar #'read-from-string
                                                 (words line)))))))
  sum))

(defun day02-2 (input) 0)

(with-open-file (in "../inputs/day02")
    (format t "Solution 1: ~a~%Solution 2: ~a~%"
            (day02-1 in)
            (day02-2 in)))
