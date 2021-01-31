#! /usr/bin/sbcl --script

; --- Day 2: Corruption Checksum ---

(defun list->string (list)
  "This function takes a list of characters and converts it into a string"
  (let ((str (make-string (length list)))
        (idx 0))
    (loop for c in list do
      (setf (aref str idx) c)
      (setf idx (+ idx 1)))
    str))

(defun file->line (input)
  "This function takes a file and converts it into a list of lines"
  (let ((lines '()))
  (do ((line (read-line input nil) (read-line input nil)))
    ((eq line nil))
    (setf lines (cons line lines)))
  (reverse lines)))

(defun whitespace-p (char)
  (member char '(#\tab #\space)))

(defun words (str)
  "This function splits a sentence into a list of words, where a word is
  sequence of contiguous characters without spaces or tabs."
  (let ((sentence '())
        (word '()))
    (loop for c across str do
      (cond
        ((and (whitespace-p c) (not (equal word '())))
          (progn
            (setf sentence (cons (list->string (reverse word)) sentence))
            (setf word '())))
        ((not (whitespace-p c))
          (setf word (cons c word)))))
    (reverse
      (if (not (equal word '()))
       (cons (list->string (reverse word)) sentence)
       sentence))))

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

(defun minmax (list)
  "This function returns a list with the min and the max of a list"
  (let ((min (car list))
        (max (car list)))
    (loop for i in list do
      (setf min (if (< i min) i min))
      (setf max (if (> i max) i max)))
  (list max min)))

(defun day02-1 (lines)
  (let ((sum 0))
  (loop for line in lines do
    (setf sum (+ sum (reduce #'- (minmax (mapcar #'read-from-string
                                                 (words line)))))))
  sum))

; "Great work; looks like we're on the right track after all. Here's a star for
; your effort." However, the program seems a little worried. Can programs be
; worried?
;
; "Based on what we're seeing, it looks like all the User wanted is some
; information about the evenly divisible values in the spreadsheet.
; Unfortunately, none of us are equipped for that kind of calculation - most of
; us specialize in bitwise operations."
;
; It sounds like the goal is to find the only two numbers in each row where one
; evenly divides the other - that is, where the result of the division operation
; is a whole number. They would like you to find those numbers on each line,
; divide them, and add up each line's result.
;
; For example, given the following spreadsheet:
;
; 5 9 2 8 ; 8 and 2 ; div: 4
; 9 4 7 3 ; 9 and 3 ; div: 3
; 3 8 6 5 ; 6 and 3 ; div: 2
; sum of divs: 9

(defun divdiv (list)
  "This function extracts a list of tuples of integers `(j i)`
  where `j` is divisible by `i` from `list`."
  (let ((res '()))
  (loop for i in list do
    (loop for j in list do
          (setf res (if (and (not (eq i j)) (eq (mod j i) 0))
                      (cons (list j i) res)
                      res))))
  res))

(defun day02-2 (lines)
  (let ((sum 0))
  (loop for line in lines do
    (setf sum (+ sum
                 (reduce #'/ (car (divdiv (mapcar #'read-from-string
                                                 (words line))))))))
  sum))

(with-open-file (in "../inputs/day02")
  (let ((lines (file->line in)))
    (format t "Solution 1: ~a~%Solution 2: ~a~%"
            (day02-1 lines)
            (day02-2 lines))))
