(in-package :day03)

(defun file->lines (input)
  "This function takes a file and converts it into a list of lines"
  (let ((lines '()))
  (do ((line (read-line input nil) (read-line input nil)))
    ((eq line nil))
    (setf lines (cons line lines)))
  (reverse lines)))

(defun flatten (l)
  (cond ((null l) nil)
        ((atom l) (list l))
        (t (loop for a in l appending (flatten a)))))

(defun whitespace-p (char)
  (member char '(#\tab #\space)))

(defun words (str)
  "This function splits a sentence into a list of words, where a word is
  sequence of contiguous characters without spaces or tabs."
  (loop for i = (position-if-not #'whitespace-p str)
        then    (position-if-not #'whitespace-p str :start (1+ j))
        for j = (and i (position-if #'whitespace-p str :start i))
    when (and i (not (equal i j)))
    collect (subseq str i j)
    while j))

(defun day03-1 (input)
  (let ((num (make-array 12 :initial-element 0))
        (gamma 0)
        (epsilon 0)
        (half (/ (list-length input) 2)))
    (loop for bin in input do
      (loop for i from 0 to 11 do
            (incf (aref num i) (- (char-int (aref bin i)) 48))))
    (loop for i from 0 to 11 do
          (setf gamma (+ (* 2 gamma) (if (> (aref num i) half) 1 0)))
          (setf epsilon (+ (* 2 epsilon) (if (> (aref num i) half) 0 1))))
    (* gamma epsilon)))

(defun most-present (lst pos)
  (let ((n 0)
        (half (/ (list-length lst) 2)))
    (loop for bin in lst do
          (incf n (- (char-int (aref bin pos)) 48)))
    (if (>= n half) 1 0)))

(defun filter (pred lst)
  (cond
    ((null lst) nil)
    ((funcall pred (car lst)) (cons (car lst) (filter pred (cdr lst))))
    (t (filter pred (cdr lst)))))

(defun day03-2-aux (most less pos)
  (if (< pos 12)
  (let* ((most-present (code-char (+ 48 (most-present most pos))))
        (less-present (code-char (+ 48 (- 1 (most-present less pos)))))
        (filter-most (if (equal (list-length most) 1)
                       most
                       (filter (lambda (s) (equal (aref s pos) most-present)) most)))
        (filter-less (if (equal (list-length less) 1)
                       less
                       (filter (lambda (s) (equal (aref s pos) less-present)) less))))
    (day03-2-aux filter-most filter-less (+ 1 pos)))
  `(,(car most) ,(car less))))

(defun day03-2 (input)
  (let* ((res (day03-2-aux input input 0))
         (ogr-bin (car res))
         (csr-bin (cadr res))
         (ogr 0)
         (csr 0))
    (loop for i from 0 to 11 do
          (setf ogr (+ (* 2 ogr) (- (char-int (aref ogr-bin i)) 48)))
          (setf csr (+ (* 2 csr) (- (char-int (aref csr-bin i)) 48))))
    (* ogr csr)))

(with-open-file (foo "../inputs/day03")
  (let ((in (flatten (file->lines foo))))
    (format t "Day03:~%Solution 1: ~a~%Solution 2: ~a~%"
            (day03-1 in)
            (day03-2 in))))
