#! /usr/bin/sbcl --script

; --- Day 2: Corruption Checksum ---

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
  (loop for i = (position-if-not #'whitespace-p str)
        then    (position-if-not #'whitespace-p str :start (1+ j))
        for j = (and i (position-if #'whitespace-p str :start i))
    when (and i (not (= i j)))
    collect (subseq str i j)
    while j))

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
  (loop for i in list
        minimizing i into min
        maximizing i into max
        finally (return (list max min))))

(defun day02-1 (lines)
  (loop for line in lines sum
    (reduce #'- (minmax (mapcar #'read-from-string (words line))))))

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

; Solution 1: 32121
; Solution 2: 197

(defun divdiv (list)
  "This function extracts a list of tuples of integers `(j i)`
  where `j` is divisible by `i` from `list`."
  (loop for i in list nconc
    (loop for j in list
          when (and (not (eq i j)) (eq (mod j i) 0))
          collect (list j i))))

(defun day02-2 (lines)
  (loop for line in lines sum
    (reduce #'/ (car (divdiv (mapcar #'read-from-string (words line)))))))

(with-open-file (in "../inputs/day02")
  (let ((lines (file->line in)))
    (format t "Solution 1: ~a~%Solution 2: ~a~%"
            (day02-1 lines)
            (day02-2 lines))))
