(in-package :day14)

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

(defun parse-word (words) (coerce (car words) 'list))

(defun parse-rules (rules)
  (let ((hrule (make-hash-table :test 'equal)))
    (loop for rule in rules do
      (setf (gethash (subseq rule 0 2) hrule) (aref rule 6)))
    hrule))

;; list based solution

(defun rewrite (word rules acc)
  (if (cdr word)
      (let* ((pat (coerce (list (car word) (cadr word)) 'string))
             (prod (gethash pat rules))
             (tl (cons (car word) acc)))
        (rewrite (cdr word) rules (if prod (cons prod tl) tl)))
      (reverse (cons (car word) acc))))

(defun rewrite-n (n word rules)
  (if (equal n 0) word
      (rewrite-n (- n 1) (rewrite word rules '()) rules)))

(defun freqs (word)
  (let ((freq-table (make-hash-table :test 'equal)))
    (loop for c in word do
      (if (not (gethash c freq-table)) (setf (gethash c freq-table) 0))
      (incf (gethash c freq-table)))
    freq-table))

(defun day14-1 (word rules)
  (let* ((res (rewrite-n 10 word rules))
         (freqs (freqs res)))
    (loop for val being the hash-value in freqs
          maximize val into v-max
          minimize val into v-min
          finally (return (- v-max v-min))))) 

;; hash map based solution

(defun word->hword (word)
  (let ((hword (make-hash-table :test 'equal)))
    (loop for (a b) on word
          when b do
            (let ((pat (coerce (list a b) 'string)))
              (if (gethash pat hword)
                  (incf (gethash pat hword))
                  (setf (gethash pat hword) 1))))
    hword))

(defun candidates (pat candidate)
  `(,(coerce `(,(aref pat 0) ,candidate) 'string)
    ,(coerce `(,candidate ,(aref pat 1)) 'string)))

(defun hrewrite-n (n hword rules)
  (if (equal n 0) hword
      (hrewrite-n (- n 1) (hrewrite hword rules) rules)))

(defun hrewrite (hword rules)
  (let ((nhword (make-hash-table :test 'equal)))
    (loop for pat being the hash-keys in hword using (hash-value val) do
      (let ((candidate (gethash pat rules)))
        (loop for nkey in (candidates pat candidate) do
          (if (gethash nkey nhword)
              (incf (gethash nkey nhword) val)
              (setf (gethash nkey nhword) val)))))
    nhword))

(defun hfreqs (hword)
  (let ((freq-table (make-hash-table :test 'equal)))
    (loop for keys being the hash-keys in hword using (hash-value val) do
      (let ((c (aref keys 1)))
        (if (not (gethash c freq-table))
            (setf (gethash c freq-table) val)
            (incf (gethash c freq-table) val))))
    freq-table))

(defun day14-2 (word rules)
  (let* ((res (hrewrite-n 40 (word->hword word) rules))
         (hfreqs (hfreqs res)))
    (loop for val being the hash-value in hfreqs
          maximize val into v-max
          minimize val into v-min
          finally (return (- v-max v-min)))))

(defun run ()
  (with-open-file (foo "../inputs/day14")
    (destructuring-bind (words-str rules-str) (split-input (file->lines foo) '())
      (let ((word (parse-word words-str))
            (rules (parse-rules rules-str)))
        (format t "Day14:~%Solution 1: ~a~%Solution 2: ~a~%"
                (day14-1 word rules)
                (day14-2 word rules))))))

(run)
