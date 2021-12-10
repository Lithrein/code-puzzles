(in-package :day10)

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

(defun score (c)
  (cond
    ((equal #\) c) 3)
    ((equal #\] c) 57)
    ((equal #\} c) 1197)
    ((equal #\> c) 25137)
    ((equal #\( c) 1)
    ((equal #\[ c) 2)
    ((equal #\{ c) 3)
    ((equal #\< c) 4)
    (t 0)))

(defun line-score (str)
  (with-input-from-string (stream str)
    (let ((brackets '())
          (illegal nil)
          (stop nil))
      (do ((cur (read-char stream) (read-char stream nil 'the-end)))
        ((or stop (not (characterp cur))))
        (cond
          ((equal #\( cur) (setf brackets (cons #\( brackets)))
          ((equal #\) cur) (if (equal (car brackets) #\()
                             (setf brackets (cdr brackets))
                             (setf stop t illegal cur)))
          ((equal #\[ cur) (setf brackets (cons #\[ brackets)))
          ((equal #\] cur) (if (equal (car brackets) #\[)
                             (setf brackets (cdr brackets))
                             (setf stop t illegal cur)))
          ((equal #\{ cur) (setf brackets (cons #\{ brackets)))
          ((equal #\} cur) (if (equal (car brackets) #\{)
                             (setf brackets (cdr brackets))
                             (setf stop t illegal cur)))
          ((equal #\< cur) (setf brackets (cons #\< brackets)))
          ((equal #\> cur) (if (equal (car brackets) #\<)
                             (setf brackets (cdr brackets))
                             (setf stop t illegal cur)))))
      `(,(score illegal) ,(reduce (lambda (res elt) (+ (* 5 res) elt))
                                  (mapcar #'score brackets))))))

(defun day10-1 (input)
  (apply #'+ (mapcar (lambda (elt) (if (equal (car elt) 0) 0 (car elt))) input)))

(defun day10-2 (input)
  (let ((lst (sort (filter (lambda (el) (not (equal el 0))) (mapcar (lambda (elt) (if (equal (car elt) 0) (cadr elt) 0)) input))
                   #'>)))
    (nth (floor (/ (list-length lst) 2)) lst)))

(with-open-file (foo "../inputs/day10")
  (let* ((in (file->lines foo))
         (prepro (mapcar #'line-score in)))
    (format t "Day10:~%Solution 1: ~a~%Solution 2: ~a~%"
            (day10-1 prepro)
            (day10-2 prepro))))
