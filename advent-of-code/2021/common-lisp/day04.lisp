(in-package :day04)

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

(defun comma-p (char)
  (member char '(#\,)))

(defun split (str pred)
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

(defun max-array (a)
  (loop for i from 0 to (- (length a) 1) maximize (aref a i)))

(defun sum-array (a)
  (loop for i from 0 to (- (length a) 1) sum (aref a i)))

(defun max-sum-row-col (mat sel)
  (let ((sum-col (make-array 5 :initial-element 0))
        (sum-row (make-array 5 :initial-element 0)))
    (loop for i from 0 to 4 do
      (loop for j from 0 to 4 do
            (incf (aref sum-row i) (aref mat (+ (* 25 sel) (* 5 i) j)))
            (incf (aref sum-col j) (aref mat (+ (* 25 sel) (* 5 i) j)))))
    (max (max-array sum-col) (max-array sum-row))))

(defun compute-score (tables mask sel last)
  (let ((nhl 0))
    (loop for i from 0 to 4 do
      (loop for j from 0 to 4 do
        (if (equal 1 (aref mask (+ (* 25 sel) (* 5 i) j))) nil
          (incf nhl (aref tables (+ (* 25 sel) (* 5 i) j))))))
  (* nhl last)))

(defun day04-1 (tables htable nb-lst)
  (let* ((mask (make-array (* 100 5 5) :initial-element 0))
        (max-val 0) (winner -1) (last -1))
    (loop for el in nb-lst do
      (setf last el)
      (loop for pos in (gethash el htable) do
        (setf (aref mask pos) 1))
      (loop for i from 0 to 99 do
        (setf max-val (max max-val (max-sum-row-col mask i)))
        (if (equal (max (max-sum-row-col mask i)) 5) (setf winner i) nil))
      while (not (equal max-val 5)))
      (compute-score tables mask winner last)))

(defun day04-2 (tables htable nb-lst)
  (let* ((mask (make-array (* 100 5 5) :initial-element 0))
        (max-val 0) (wins (make-array 100 :initial-element 0)) (nb-wins 0) (winner -1) (last -1))
    (loop for el in nb-lst do
      (setf last el)
      (loop for pos in (gethash el htable) do
        (setf (aref mask pos) 1))
      (loop for i from 0 to 99 do
        (setf max-val (max max-val (max-sum-row-col mask i)))
        (if (and (equal (aref wins i) 0) (equal (max (max-sum-row-col mask i)) 5))
          (progn (setf (aref wins i) 1)
                 (setf winner i))
          nil))
        (setf nb-wins (sum-array wins))
      while (not (equal nb-wins 100)))
      (compute-score tables mask winner last)))

(defun build-hash-table (input)
  (let* ((len (/ (length input) 25))
         (htable (make-hash-table)))
  (loop for i from 0 to (- len 1) do
    (loop for j from 0 to 4 do
      (loop for k from 0 to 4 do
        (let* ((pos (+ (* 25 i) (* 5 j) k))
               (key (aref input pos)))
          (setf (gethash key htable) (cons pos (gethash key htable)))))))
  htable))

(with-open-file (foo "../inputs/day04")
  (let* ((in (file->lines foo))
         (numbers (mapcar #'parse-integer (split (car in) #'comma-p)))
         (tables (coerce (mapcar #'parse-integer (flatten (mapcar (lambda (lst) (split lst #'whitespace-p)) (cddr in)))) 'vector))
         (htable (build-hash-table tables)))
    (format t "Day04:~%Solution 1: ~a~%Solution 2: ~a~%"
            (day04-1 tables htable numbers)
            (day04-2 tables htable numbers))))
