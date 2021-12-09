(in-package :day09)

(defvar *dim* 1000)

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

(defun range-aux (i j)
  (cond ((> i j) '())
        (t (cons i (range-aux (+ 1 i) j)))))

(defun range (i j)
  (if (> i j)
    (reverse (range-aux j i))
    (range-aux i j)))

(defun whitespace-p (char)
  (member char '(#\tab #\space)))

(defun comma-p (char)
  (member char '(#\,)))

(defun split (pred str)
  "This function splits a sentence into a list of words, where a word is
  sequence of contiguous characters without spaces or tabs."
  (loop for i = (position-if-not pred str)
        then    (position-if-not pred str :start (1+ j))
        for j = (and i (position-if pred str :start i))
        when (and i (not (equal i j)))
        collect (subseq str i j)
        while j))

(defun filter (pred lst)
  (cond
    ((null lst) nil)
    ((funcall pred (car lst)) (cons (car lst) (filter pred (cdr lst))))
    (t (filter pred (cdr lst)))))

(defun parse-line (line)
  (mapcar #'parse-integer
          (loop for i from 0 to (- (length line) 1)
        collect (subseq line i (+ 1 i)))))

(defun list->array (list)
  (let* ((rows (list-length list))
         (cols (list-length (car list)))
         (matrix (make-array (* rows cols) :initial-element 0))
        (i 0) (j 0))
    (loop for row in list do
      (setf j 0)
      (loop for elt in row do
        (setf (aref matrix (+ (* i cols) j)) elt)
        (incf j))
      (incf i))
    `(,rows ,cols ,matrix)))

(defun print-matrix (rows cols matrix)
  (loop for i from 0 to (- rows 1) do
    (loop for j from 0 to (- cols 1) do
      (format t "~a " (aref matrix (+ (* i cols) j))))
    (terpri)))

(defun access (row col rows cols matrix default)
  (if (and (<= 0 row) (<= 0 col) (< row rows) (< col cols))
    (aref matrix (+ (* row cols) col))
    default))

(defun find-basins (rows cols matrix)
  (let ((basins '()))
    (loop for i from 0 to (- rows 1) do
      (loop for j from 0 to (- cols 1) do
        (if (= 4 (loop for (dx dy) in '((1 0) (0 1) (-1 0) (0 -1))
                       count (> (access (+ i dx) (+ j dy) rows cols matrix 10)
                                (access i j rows cols matrix 10))))
          (setf basins (cons `(,i ,j) basins))
          nil)))
    basins))

(defun explore-basin (bx by rows cols matrix)
  (if (>= (access bx by rows cols matrix 10) 9)
    0
    (progn
      (setf (aref matrix (+ (* bx cols) by)) 9)
      (+ 1
         (explore-basin (+ bx 0) (+ by 1) rows cols matrix)
         (explore-basin (+ bx 0) (- by 1) rows cols matrix)
         (explore-basin (+ bx 1) (+ by 0) rows cols matrix)
         (explore-basin (- bx 1) (+ by 0) rows cols matrix)))))

(defun day09-1 (rows cols matrix)
    (apply #'+ (mapcar (lambda (l) (+ 1 (access (car l) (cadr l) rows cols matrix 10)))
                       (find-basins rows cols matrix))))

(defun basins-sizes (rows cols matrix)
  (sort (loop for (bx by) in (find-basins rows cols matrix)
        collect (explore-basin bx by rows cols matrix))
        #'>))

(defun day09-2 (rows cols matrix)
  (let ((sizes (basins-sizes rows cols matrix)))
    (* (car sizes) (cadr sizes) (caddr sizes))))

(with-open-file (foo "../inputs/day09")
  (let* ((in (list->array (mapcar #'parse-line (file->lines foo))))
         (rows (car in))
         (cols (cadr in))
         (matrix (caddr in)))
    (format t "Day09:~%Solution 1: ~a~%Solution 2: ~a~%"
            (day09-1 rows cols matrix)
            (day09-2 rows cols matrix))))
