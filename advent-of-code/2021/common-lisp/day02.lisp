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

(defun day02-1-aux (input)
  (if input
    (let* ((res (day02-1-aux (cdr input)))
           (cmdval (car input))
           (cmd (car cmdval))
           (val (parse-integer (cadr cmdval)))
           (x (car res))
           (y (cadr res)))
    (cond
      ((equal cmd "up")      `(,x ,(- y val)))
      ((equal cmd "down")    `(,x ,(+ y val)))
      ((equal cmd "forward") `(,(+ x val) ,y))))
    '(0 0)))

(defun day02-1 (input)
  (let ((res (day02-1-aux input)))
    (* (car res) (cadr res))))

(defun day02-2-aux (input)
  (if input
    (let* ((res (day02-2-aux (cdr input)))
           (cmdval (car input))
           (cmd (car cmdval))
           (val (parse-integer (cadr cmdval)))
           (x (car res))
           (y (cadr res))
           (aim (caddr res)))
    (cond
      ((equal cmd "up")      `(,x ,y ,(- aim val)))
      ((equal cmd "down")    `(,x ,y ,(+ aim val)))
      ((equal cmd "forward") `(,(+ x val) ,(+ y (* aim val)) ,aim))))
    '(0 0 0)))

(defun day02-2 (input)
  (let ((res (day02-2-aux input)))
    (* (car res) (cadr res))))

(with-open-file (foo "../inputs/day02")
  (let ((in (mapcar #'words (file->lines foo))))
    (format t "Day02:~%Solution 1: ~a~%Solution 2: ~a~%"
            (day02-1 in)
            (day02-2 (reverse in)))))
