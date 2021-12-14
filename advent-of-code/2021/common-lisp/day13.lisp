(in-package :day13)

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

(defun comma-p (char) (equal char #\,))

(defun parse-points (points)
  (if points
      (cons (mapcar #'parse-integer (split #'comma-p (car points))) (parse-points (cdr points)))))

(defun parse-instrs (instrs)
  (if instrs
      (let ((elt (parse-integer (subseq (car instrs) 13)))
            (tail (parse-instrs (cdr instrs))))
        (if (equal #\x (aref (car instrs) 11))
            (cons `(verti ,elt) tail)
            (cons `(horiz ,elt) tail)))))

(defun points->array (points)
  (destructuring-bind
      (x-max y-max)
      (loop for (x y) in points
            maximize x into x-max
            maximize y into y-max
            finally (return (list (1+ x-max) (1+ y-max))))
    (let ((array (make-array `(,y-max ,x-max) :initial-element #\ )))
      (loop for (x y) in points do
        (setf (aref array y x) #\#))
      `(,y-max ,x-max ,array))))

(defun fold-once (dir val y-max x-max array)
  (if (eql 'horiz dir)
      (progn
        (loop for i from 0 to (- val 1) do
          (loop for j from 0 to (- x-max 1)
                when (< (- (* 2 val) i) y-max)
                  when (equal #\# (aref array (- (* 2 val) i) j)) do
                    (setf (aref array i j) #\#)))
        `(,val ,x-max))
      (progn
        (loop for i from 0 to (- y-max 1) do
          (loop for j from 0 to (- val 1)
                when (< (- (* 2 val) j) x-max)
                  when (equal #\# (aref array i (- (* 2 val) j))) do
                    (setf (aref array i j) #\#)))
        `(,y-max ,val))))

(defun print-matrix (y-max x-max matrix)
  (loop for i from 0 to (- y-max 1) do
    (loop for j from 0 to (- x-max 1) do
      (format t "~a " (aref matrix i j)))
    (terpri)))

(defun copy-array (a)
  (do ((b (make-array (array-dimensions a) :element-type (array-element-type a)))
       (n 0 (1+ n)))
      ((>= n (array-total-size a)) b)
    (setf (row-major-aref b n) (row-major-aref a n))))

(defun day13-1 (instr rows cols array)
  (destructuring-bind
      (r c) (fold-once (car instr) (cadr instr) rows cols array)
    (loop for i from 0 to (- r 1)
          sum (loop for j from 0 to (- c 1)
                    count (equal #\# (aref array i j))))))

(defun day13-2 (instrs rows cols array)
  (if instrs
      (destructuring-bind
          (r c) (fold-once (caar instrs) (cadar instrs) rows cols array)
        (day13-2 (cdr instrs) r c array))
      (print-matrix rows cols array)))

(defun run ()
  (with-open-file (foo "../inputs/day13")
    (destructuring-bind (points-str instrs-str) (split-input (file->lines foo) '())
      (let ((instrs (parse-instrs instrs-str)))
        (destructuring-bind (rows cols array) (points->array (parse-points points-str))
          (format t "Day13:~%Solution 1: ~a~%Solution 2:~%"
                  (day13-1 (car instrs) rows cols (copy-array array)))
          (day13-2 instrs rows cols (copy-array array)))))))

(run)
