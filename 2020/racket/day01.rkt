#! /usr/bin/env racket
#lang racket/base

(define (make-list-from-input in)
  (let ([val (read in)])
    (if (eof-object? val)
        '()
         (cons val (make-list-from-input in)))))

(define (part1 lst)
  (for*/first ([i lst]
               [j lst]
               #:when (= 2020 (+ i j)))
    (* i j)))

(define (part2 lst)
  (for*/first ([i lst]
               [j lst]
               [k lst]
               #:when (= 2020 (+ i j k)))
    (* i j k)))

(define in (open-input-file "../inputs/day01"))
(define lst (make-list-from-input in))
(printf "part1: ~a~npart2: ~a~n" (part1 lst) (part2 lst))
