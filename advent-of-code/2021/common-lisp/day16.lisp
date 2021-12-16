(in-package :day16)

(defun file->lines (input)
  "This function takes a file and converts it into a list of lines"
  (let ((lines '()))
    (do ((line (read-line input nil) (read-line input nil)))
      ((eq line nil))
      (setf lines (cons line lines)))
    (reverse lines)))

(defun hex->bin (c)
  (cond
    ((equal c #\0) "0000") ((equal c #\1) "0001") ((equal c #\2) "0010")
    ((equal c #\3) "0011") ((equal c #\4) "0100") ((equal c #\5) "0101")
    ((equal c #\6) "0110") ((equal c #\7) "0111") ((equal c #\8) "1000")
    ((equal c #\9) "1001") ((equal c #\A) "1010") ((equal c #\B) "1011")
    ((equal c #\C) "1100") ((equal c #\D) "1101") ((equal c #\E) "1110")
    ((equal c #\F) "1111")))

(defun bin->dec (num)
  (loop with res = 0
        for c across num do
           (setf res (+ (* 2 res) (- (char-int c) 48)))
        finally (return res)))

(defun expand (line)
  (apply #'concatenate `(string ,@(loop for c across line collect (hex->bin c)))))

(defun read-packet (line offset)
  (let ((version (bin->dec (subseq line offset (+ offset 3))))
        (id (bin->dec (subseq line (+ offset 3) (+ offset 6))))
        (cur-offset (+ offset 6)))
    (cond
      ((equal id 4)                    ; the paquet is a literal value
       (let ((num 0))
         (do ((stop nil))
             (stop)
           ;; if it's the last five bits, we'll stop after reading them.
           (if (equal (aref line cur-offset) #\0) (setf stop t))
           (setf num (+ (* 16 num) (bin->dec (subseq line (+ cur-offset 1) (+ cur-offset 5)))))
           (incf cur-offset 5))
         `(,(- cur-offset offset) (,version ,id (,num)))))
      (t                         ; the paquet is an operator paquet
       (let ((lid (subseq line cur-offset (+ cur-offset 1))))
         (incf cur-offset)
         (cond
           ((equal lid "0") ; next 15 bits are the total length of subpackets
            (let ((total-length (bin->dec (subseq line cur-offset (+ cur-offset 15))))
                  (nb-read-bits 0)
                  (payload '()))
              (incf cur-offset 15)
              (do ()
                  ((>= nb-read-bits total-length))
                (destructuring-bind (read-bits packet) (read-packet line cur-offset)
                  (incf nb-read-bits read-bits)
                  (incf cur-offset read-bits)
                  (setf payload (cons packet payload))))
              `(,(- cur-offset offset) (,version ,id ,(reverse payload)))))
           ((equal lid "1") ; the next 11 bits are the number of subpackets
            (let ((nb-packets (bin->dec (subseq line cur-offset (+ cur-offset 11))))
                  (payload '()))
              (incf cur-offset 11)
              (loop for _ from 1 to nb-packets do
                (destructuring-bind (read-bits packet) (read-packet line cur-offset)
                  (incf cur-offset read-bits)
                  (setf payload (cons packet payload))))
              `(,(- cur-offset offset) (,version ,id ,(reverse payload)))))))))))

(defun sum-version (packets)
  (if (listp packets)
      (if (equal 3 (list-length packets))
          (+ (car packets) (apply #'+ (mapcar #'sum-version (caddr packets))))
          0)
      0))

(defun eval-packet (packet)
  (cond
    ((equal (cadr packet) 0) ; sum packet
     (apply #'+ (mapcar #'eval-packet (caddr packet))))
    ((equal (cadr packet) 1) ; product packet
     (apply #'* (mapcar #'eval-packet (caddr packet))))
    ((equal (cadr packet) 2) ; min packet
     (apply #'min (mapcar #'eval-packet (caddr packet))))
    ((equal (cadr packet) 3) ; max packet
     (apply #'max (mapcar #'eval-packet (caddr packet))))
    ((equal (cadr packet) 4) ; literal value packet
     (caaddr packet))
    ((equal (cadr packet) 5) ; greater than packet
     (if (apply #'> (mapcar #'eval-packet (caddr packet))) 1 0))
    ((equal (cadr packet) 6) ; lesser than packet
     (if (apply #'< (mapcar #'eval-packet (caddr packet))) 1 0))
    ((equal (cadr packet) 7) ; equal than packet
     (if (apply #'= (mapcar #'eval-packet (caddr packet))) 1 0))))

(defun day16-1 (packets) (sum-version packets))
(defun day16-2 (packets) (eval-packet packets))

(defun run ()
  (with-open-file (foo "../inputs/day16")
    (destructuring-bind (length packets) (read-packet (expand (read-line foo)) 0)
      (declare (ignore length))
      (format t "Day16:~%Solution 1: ~a~%Solution 2: ~a~%"
              (day16-1 packets)
              (day16-2 packets)))))

(run)
