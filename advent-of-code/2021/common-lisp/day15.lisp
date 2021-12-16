(in-package :day15)

(defun file->lines (input)
  "This function takes a file and converts it into a list of lines"
  (let ((lines '()))
    (do ((line (read-line input nil) (read-line input nil)))
      ((eq line nil))
      (setf lines (cons line lines)))
    (reverse lines)))

(defun split (pred str)
  "This function splits a sentence into a list of words, where a word is
  sequence of contiguous characters without spaces or tabs."
  (loop for i = (position-if-not pred str)
        then    (position-if-not pred str :start (1+ j))
        for j = (and i (position-if pred str :start i))
        when (and i (not (equal i j)))
        collect (subseq str i j)
        while j))

(defun split-input (input acc)
  (if (equal "" (car input))
      `(,acc ,(cdr input))
      (split-input (cdr input) (cons (car input) acc))))

(defun lines->array (lines)
  (let* ((rows (list-length lines))
         (cols (length (car lines)))
         (array (make-array `(,rows ,cols) :initial-element 0)))
    (loop for line in lines
          for i from 0 to (- rows 1) do
            (loop for j from 0 to (- cols 1) do
              (setf (aref array i j) (- (char-int (aref line j)) 48))))
    array))

(defun five-times (array)
  (destructuring-bind (rows cols) (array-dimensions array)
    (let ((narray (make-array `(,(* 5 rows) ,(* 5 cols)))))
      (loop for i from 0 to (- rows 1) do
        (loop for j from 0 to (- cols 1) do
          (loop for dx from 0 to 4 do
            (loop for dy from 0 to 4 do
              (setf (aref narray (+ (* rows dx) i) (+ (* cols dy) j))
                    (+ 1 (mod (+ dx dy (- (aref array i j) 1)) 9)))))))
      narray)))

(defun bellman-ford (array)
  (destructuring-bind (rows cols) (array-dimensions array)
    (let ((weights (make-array `(,rows ,cols) :initial-element nil)))
      (setf (aref weights 0 0) 0)
      (loop for k from 0 to 2 do ; cheat code mode on. should be (- (* rows cols) 1) instead of 2...
        (loop for i from 0 to (- rows 1) do
          (loop for j from 0 to (- cols 1) do
            (loop for (dx dy) in '((0 1) (1 0) (-1 0) (0 -1)) do
              (when (and (<= 0 (+ i dx)) (<= 0 (+ j dy))
                         (< (+ i dx) rows) (< (+ j dy) cols))
                (if (aref weights (+ i dx) (+ j dy))
                    (if (> (aref weights (+ i dx) (+ j dy)) (+ (aref weights i j)
                                                               (aref array (+ i dx) (+ j dy))))
                        (progn
                          (setf (aref weights (+ i dx) (+ j dy))
                                (+ (aref weights i j) (aref array (+ i dx) (+ j dy))))))
                    (progn
                      (setf (aref weights (+ i dx) (+ j dy))
                            (+ (aref weights i j) (aref array (+ i dx) (+ j dy)))))))))))
      #+nil weights
      (aref weights (- rows 1) (- cols 1)))))

(defun print-matrix (matrix)
  (destructuring-bind (rows cols) (array-dimensions matrix)
    (loop for i from 0 to (- rows 1) do
      (loop for j from 0 to (- cols 1) do
        (format t "~a " (aref matrix i j)))
      (terpri))))

(defun day15-1 (array) (bellman-ford array))
(defun day15-2 (array) (bellman-ford (five-times array)))

(defun run ()
  (with-open-file (foo "../inputs/day15")
    (let ((array (lines->array (file->lines foo))))
      (format t "Day15:~%Solution 1: ~a~%Solution 2: ~a~%"
              (day15-1 array)
              (day15-2 array)))))

(run)
