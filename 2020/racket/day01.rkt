#! /usr/bin/env racket
#lang racket/base

(require racket/file)

(module+ test
  (require rackunit)
  (define nums '(1721 979 366 299 675 1456)))


(define (part1 lst)
  (for*/first ([i lst]
               [j lst]
               #:when (= 2020 (+ i j)))
    (* i j)))

(module+ test
  (check-equal? (part1 nums) 514579))

(define (part2 lst)
  (for*/first ([i lst]
               [j lst]
               [k lst]
               #:when (= 2020 (+ i j k)))
    (* i j k)))

(module+ test
  (check-equal? (part2 nums) 241861950))

(module+ main
  (define lst (file->list "../inputs/day01"))
  (printf "part1: ~a~npart2: ~a~n" (part1 lst) (part2 lst)))
