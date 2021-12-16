(in-package :cl-user)

(defmacro define-package-from-list (lst)
  `(progn
   ,@(loop for day in lst collect
           `(uiop:define-package ,day
               (:use #:common-lisp)))))

(define-package-from-list
  (:day01 :day02 :day03 :day04 :day05
   :day09 :day10 :day11 :day12 :day13
   :day14 :day15 :day16))
