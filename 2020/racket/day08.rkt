#! /usr/bin/env racket
#lang racket/base

(require racket/file
         racket/function
         racket/match
         racket/string)

(define (sets-from-group grp)
  (map list->set (map string->list grp)))

(define (load-prgm-from-file file)
  (list->vector (map (lambda (str)
                       ((match-lambda
                          [`(,op ,nb) `(,op ,(string->number nb))])
                        (string-split str " ")))
                     (file->lines file))))

(define (part1 prgm)
  (define visited (make-hash))
  (define len (vector-length prgm))
  (define (exec pc acc)
    (cond
      [(or (hash-has-key? visited pc) (>= pc len)) acc]
      [else (hash-set! visited pc #t)
        (match (vector-ref prgm pc)
          [`( "acc" ,nb ) (exec (+ 1 pc) (+ nb acc))]
          [`( "jmp" ,nb ) (exec (+ pc nb) acc)]
          [`( "nop" ,nb ) (exec (+ 1 pc) acc)])]))
  (exec 0 0))

(define (part2 prgm)
  0)

(module+ main
  (define input (load-prgm-from-file "../inputs/day08"))
  (printf "part1: ~a~npart2: ~a~n" (part1 input) (part2 input)))
