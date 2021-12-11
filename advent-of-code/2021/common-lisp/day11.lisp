(in-package :day11)

(defvar *dim* 10)

(defun file->lines (input)
  "This function takes a file and converts it into a list of lines"
  (let ((lines '()))
    (do ((line (read-line input nil) (read-line input nil)))
      ((eq line nil))
      (setf lines (cons line lines)))
    (reverse lines)))

(defun list->array (list)
  (let* ((rows (list-length list))
         (cols (length (car list)))
         (matrix (make-array (* rows cols) :initial-element 0))
        (i 0) (j 0))
    (loop for row in list do
      (setf j 0)
      (loop for elt across row do
        (setf (aref matrix (+ (* i cols) j)) (- (char-int elt) 48))
        (incf j))
      (incf i))
    `(,rows ,cols ,matrix)))

(defun array-plus-one (rows cols array)
  (loop for i from 0 to (- rows 1) do
    (loop for j from 0 to (- cols 1) do
          (incf (aref array (+ (* i rows) j))))))

(defun find-nines (rows cols array)
  (loop for i from 0 to (1- (* rows cols))
        when (> (aref array i) 9)
          collect i))

(defun update-neighbors (rows cols array indexes)
  (loop for i in indexes do
    (setf (aref array i) -1)
    (multiple-value-bind (r c) (floor i rows)
      (loop for (dx dy) in '((1 0) (-1 0) (0 1) (0 -1) (-1 -1) (1 -1) (1 1) (-1 1)) do
        (let ((j (+ (* (+ r dx) rows) (+ c dy))))
          (if (and (<= 0 (+ r dx)) (<= 0 (+ c dy))
                   (< (+ r dx) cols) (< (+ c dy) cols)
                   (not (= -1 (aref array j))))
              (incf (aref array j))
              nil))))))

(defun zero-above-nine (rows cols array)
  (loop for i from 0 to (1- (* rows cols))
        when (= (aref array i) -1) do
          (setf (aref array i) 0)))

(defun next (rows cols array)
  (let ((flashes 0))
    (array-plus-one rows cols array)
    (do ((nines (find-nines rows cols array) (find-nines rows cols array)))
        ((= 0 (list-length nines)))
      (incf flashes (list-length nines))
      (update-neighbors rows cols array nines))
    (zero-above-nine rows cols array)
    flashes))

(defun print-matrix (rows cols matrix)
  (loop for i from 0 to (- rows 1) do
    (loop for j from 0 to (- cols 1) do
      (format t "~2a " (aref matrix (+ (* i cols) j))))
    (terpri)))

(defun all-zeroes (rows cols matrix)
  (= 0 (loop for i from 0 to (1- (* rows cols)) sum (aref matrix i))))

(defun day11-1 (rows cols array)
  (loop for i from 0 to 99 sum (next rows cols array)))

(defun day11-2 (rows cols array)
  (let ((res 0))
    (do ()
        ((all-zeroes rows cols array))
      (next rows cols array)
      (incf res))
    res))

(defun run ()
  (with-open-file (foo "../inputs/day11")
    (let* ((in (list->array (file->lines foo)))
           (rows (car in))
           (cols (cadr in))
           (arr (caddr in)))
      (format t "Day11:~%Solution 1: ~a~%Solution 2: ~a~%"
              (day11-1 rows cols (copy-seq arr))
              (day11-2 rows cols (copy-seq arr))))))

(run)
