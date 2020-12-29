#! /usr/bin/env racket
#lang racket/base

(require racket/file
         racket/match
         racket/bool)

(define/match (line-to-list line)
  [((pregexp #px"(\\d+)-(\\d+) (\\w): (\\w+)" (list _ min max letter pwd)))
   (list (string->number min) (string->number max) (string-ref letter 0) pwd)])

(define (load-passwords file-name)
  (map line-to-list (file->lines file-name)))

(define/match (valid-first-policy instance)
  [((list min max letter pwd))
   (define cnt (length (filter (lambda (x) (char=? letter x)) (string->list pwd))))
   (and (<= cnt max) (>= cnt min))])

(define/match (valid-second-policy instance)
  [((list min max letter pwd))
   (xor (char=? letter (string-ref pwd (- min 1)))
        (char=? letter (string-ref pwd (- max 1))))])

(define (part1 lst)
  (length (filter valid-first-policy lst)))

(define (part2 lst)
  (length (filter valid-second-policy lst)))

(define input (load-passwords "../inputs/day02"))
(printf "part1: ~a~npart2: ~a~n" (part1 input) (part2 input))
