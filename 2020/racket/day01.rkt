#! /usr/bin/env racket
#lang racket

(define (make-list-from-input in)
  (let ([val (read in)])
    (if (eof-object? val)
        '()
         (cons val (make-list-from-input in)))))

(define (part1 lst)
  (let ([res 0])
    (for ([i lst])
      (for ([j lst])
        (cond [ (= 2020 (+ i j)) (set! res (* i j))])))
    res))

(define (part2 lst)
  (let ([res 0])
    (for ([i lst])
      (for ([j lst])
        (for ([k lst])
          (cond [ (= 2020 (+ i j k)) (set! res (* i j k))]))))
  res))

(define in (open-input-file "../inputs/day01"))
(define lst (make-list-from-input in))
(write (part1 lst))
(display "\n")
(write (part2 lst))
