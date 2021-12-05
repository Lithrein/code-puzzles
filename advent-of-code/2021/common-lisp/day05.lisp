(in-package :day05)

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
  (let* ((lst (split #'whitespace-p line))
         (beg (mapcar #'parse-integer (split #'comma-p (car lst))))
         (end (mapcar #'parse-integer (split #'comma-p (caddr lst)))))
    (flatten (list beg end))))

(defun day05-1 (input)
  (let ((mask (make-array (* *dim* *dim*) :initial-element 0))
        (cnt 0))
    (loop for (y1 x1 y2 x2) in input do
      (if (or (equal x1 x2) (equal y1 y2))
      (loop for i from (min x1 x2) to (max x1 x2) do
        (loop for j from (min y1 y2) to (max y1 y2) do
          (incf (aref mask (+ (* i *dim*) j)))))
      nil))
    (loop for i from 0 to (- *dim* 1) do
      (loop for j from 0 to (- *dim* 1) do
        (if (> (aref mask (+ (* i *dim*) j)) 1)
          (incf cnt)
          nil)))
  cnt))

(defun range-aux (i j)
  (cond ((> i j) '())
        (t (cons i (range-aux (+ 1 i) j)))))

(defun range (i j)
  (if (> i j)
    (reverse (range-aux j i))
    (range-aux i j)))

(defun day05-2 (input)
  (let ((mask (make-array (* *dim* *dim*) :initial-element 0))
        (cnt 0))
    (loop for (y1 x1 y2 x2) in input do
      (cond
        ((or (equal x1 x2) (equal y1 y2))
         (loop for i from (min x1 x2) to (max x1 x2) do
           (loop for j from (min y1 y2) to (max y1 y2) do
                 (incf (aref mask (+ (* i *dim*) j))))))
        (t
          (loop for i in (range x1 x2)
                for j in (range y1 y2) do
                (incf (aref mask (+ (* i *dim*) j)))))))
    (loop for i from 0 to (- *dim* 1) do
      (loop for j from 0 to (- *dim* 1) do
        (if (> (aref mask (+ (* i *dim*) j)) 1)
          (incf cnt)
          nil)))
  cnt))

(with-open-file (foo "../inputs/day05")
  (let* ((in (mapcar #'parse-line (file->lines foo))))
    (format t "Day05:~%Solution 1: ~a~%Solution 2: ~a~%"
            (day05-1 in)
            (day05-2 in))))
