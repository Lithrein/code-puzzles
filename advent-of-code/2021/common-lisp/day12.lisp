(in-package :day12)

(defvar *dim* 10)

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

(defun dash-p (char) (equal char #\-))

(defun lines->graph (lines)
  (let ((graph (make-hash-table :test 'equal)))
    (loop for line in lines do
      (destructuring-bind (src dst) (split #'dash-p line)
        (setf (gethash src graph) (cons dst (gethash src graph)))
        (setf (gethash dst graph) (cons src (gethash dst graph)))))
    graph))

(defun small-cave-p (cave) (lower-case-p (aref cave 0)))

(defun walk1 (from graph visited)
  (let ((res '()))
    (if (equal from "end") (setf res '(("end")))
        (if (gethash from visited) nil
            (progn
              (if (small-cave-p from) (setf (gethash from visited) t))
              (loop for neighbor in (gethash from graph) do
                (let ((paths (walk1 neighbor graph visited)))
                  (loop for path in paths do
                    (if path (setf res (append (cons (cons from path) nil) res)) nil))))
              (if (small-cave-p from) (setf (gethash from visited) nil)))))
    res))

(defun walk2 (from graph visited twice)
  (let ((res '()))
    (if (equal from "end") (setf res '(("end")))
        (if (gethash from visited)
            (if (or (equal from "start") twice) nil
                (progn
                  (loop for neighbor in (gethash from graph) do
                    (let ((paths (walk2 neighbor graph visited t)))
                      (loop for path in paths do
                        (if path (setf res (append (cons (cons from path) nil) res)) nil))))))
            (progn
              (if (small-cave-p from) (setf (gethash from visited) t))
              (loop for neighbor in (gethash from graph) do
                (let ((paths (walk2 neighbor graph visited twice)))
                  (loop for path in paths do
                    (if path (setf res (append (cons (cons from path) nil) res)) nil))))
              (if (small-cave-p from) (setf (gethash from visited) nil)))))
    res))

(defun day12-1 (graph)
  (list-length (walk1 "start" graph (make-hash-table :test 'equal))))

(defun day12-2 (graph)
  (list-length (walk2 "start" graph (make-hash-table :test 'equal) nil)))

(defun run ()
  (with-open-file (foo "../inputs/day12")
    (let* ((graph (lines->graph (file->lines foo))))
      (format t "Day12:~%Solution 1: ~a~%Solution 2: ~a~%"
              (day12-1 graph)
              (day12-2 graph)))))

(run)
