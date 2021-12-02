(in-package :day02)

(defun file->lines (input)
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
    when (and i (not (equal i j)))
    collect (subseq str i j)
    while j))

(defun day02-1 (input)
  (let ((h 0) (d 0))
    (loop for (cmd val) in input do
      (let ((v (parse-integer val)))
        (cond
         ((equal cmd "up")      (decf d v))
         ((equal cmd "down")    (incf d v))
         ((equal cmd "forward") (incf h v)))))
    (* h d)))

(defun day02-2 (input)
  (let ((h 0) (d 0) (a 0))
    (loop for (cmd val) in input do
      (let ((v (parse-integer val)))
        (cond
         ((equal cmd "up")      (decf a v))
         ((equal cmd "down")    (incf a v))
         ((equal cmd "forward") (incf h v) (incf d (* a v))))))
    (format t "~a~%" `(,h ,d ,a))
    (* h d)))

(with-open-file (foo "../inputs/day02")
  (let ((in (mapcar #'words (file->lines foo))))
    (format t "Day02:~%Solution 1: ~a~%Solution 2: ~a~%"
            (day02-1 in)
            (day02-2 in))))
