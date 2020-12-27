#! /usr/bin/env racket
#lang racket

(define (line-to-list line)
  (match (cdr (regexp-match #px"(\\d+)-(\\d+) (\\w): (\\w+)" line))
         [(list min max letter pwd)
          `(,(string->number min) ,(string->number max) ,(string-ref letter 0) ,pwd)]
         ))

(define (load-passwords file-name)
  (map line-to-list (file->lines file-name)))

(define (valid-first-policy instance)
  (match instance
         [(list min max letter pwd)
          (let ([cnt
                  (length (filter (lambda (x) (char=? letter x)) (string->list pwd))) ])
                  (and (<= cnt max) (>= cnt min)))]))

(define (valid-second-policy instance)
  (match instance
         [(list min max letter pwd)
          (xor (char=? letter (string-ref pwd (- min 1)))
               (char=? letter (string-ref pwd (- max 1))))]))

(define (part1 lst)
  (length (filter valid-first-policy lst)))

(define (part2 lst)
  (length (filter valid-second-policy lst)))

(define input (load-passwords "../inputs/day02"))

(display (part1 input))
(display "\n")
(display (part2 input))
