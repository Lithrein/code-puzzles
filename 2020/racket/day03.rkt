#lang racket

(define (load-map-from file-name)
  (list->vector (map
    (lambda (str) (list->vector (string->list str)))
      (file->lines file-name))))

(define (count-tree array x y)
 (let ([height (vector-length array)]
       [width (vector-length (vector-ref array 0))])
  (define (walk-cnt i j)
    (if (< i height)
       (if (char=? (vector-ref (vector-ref array i) j) #\#)
           (+ 1 (walk-cnt (+ i x) (modulo (+ j y) width)))
           (walk-cnt (+ i x) (modulo (+ j y) width)))
       0))
  (walk-cnt 0 0)))

(define input (load-map-from "inputs/day03"))

(define (day03 array slopes)
  (foldl
    (lambda (slope res) (* res (count-tree array (car slope) (cadr slope))))
    1 slopes))

(define (part1 array)
  (day03 array '((1 3))))

(define (part2 array)
  (day03 array '((1 1) (1 3) (1 5) (1 7) (2 1))))

(display (part1 input))
(display "\n")
(display (part2 input))
