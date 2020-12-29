#! /usr/bin/env racket
#lang racket/base

(require racket/file)

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

(define lst (file->list "../inputs/day01"))
(printf "part1: ~a~npart2: ~a~n" (part1 lst) (part2 lst))
