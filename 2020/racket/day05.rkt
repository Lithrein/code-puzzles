#! /usr/bin/env racket
#lang racket/base

(require racket/file
         racket/match
         racket/string)

(define (load-seats-from-file file)
  (define/match (list-to-seat lst)
    [ (`(#\B . ,xs)) (+ 1 (* 2 (list-to-seat xs))) ]
    [ (`(#\R . ,xs)) (+ 1 (* 2 (list-to-seat xs))) ]
    [ (`(#\F . ,xs)) (* 2 (list-to-seat xs)) ]
    [ (`(#\L . ,xs)) (* 2 (list-to-seat xs)) ]
    [ (`()) 0 ]
    [ ( _ ) (write "error while parsing seat") ])
  (define (string-to-seat s) (list-to-seat (reverse (string->list s))))
  (map string-to-seat (file->lines file)))

(module+ main
  (define (part1 seats)
    (foldl max 0 input))

  (define (part2 seats)
    (define sorted-seats (sort input <))
    (for/first ([i sorted-seats]
                [j (cdr sorted-seats)]
                #:when (= 2 (abs (- i j))))
               (+ 1 i)))

  (define input (load-seats-from-file "../inputs/day05"))
  (printf "part1: ~a~npart2: ~a~n" (part1 input) (part2 input)))
