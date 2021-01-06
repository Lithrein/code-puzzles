#! /usr/bin/env racket
#lang racket/base

(require racket/file
         racket/match
         racket/string)

(module+ test
  (require rackunit))

(define/match (list->pair lst)
  [ (`(,a . (,b . ,xs))) (cons a b) ]
  [ (_) (write "error: list should have at least 2 elements") ])

(define (any? lst) (foldl (lambda (x y) (or x y)) #f lst))

(define (load-bags lines)
  (define (line->bag-entry line)
    (define/match (to-entry lst)
      [ (`(,a . ,b)) (cons b (string->number a)) ]
      [ (_) (write "error: list should have at least 2 elements") ])
    (match-define (list bag bags) (string-split line " bags contain "))
    (cons bag
          (make-hash (map (compose to-entry list->pair)
                          (regexp-match* #px"(\\d+) (.[^,]*) bag"
                                         line
                                         #:match-select cdr)))))
  (make-hash (map line->bag-entry lines)))

(define (part1 lst)
  (define/match (can-contain-shiny bag)
    [ ( "shiny gold" ) #t ]
    [ ( _ ) (any? (map can-contain-shiny (hash-keys (hash-ref lst bag))))])
  (- (length (filter can-contain-shiny (hash-keys lst))) 1))

(define (part2 lst)
  (define (how-much-in [bag "shiny gold"])
    (foldl + 0 (hash-map (hash-ref lst bag) (lambda (k v) (+ v (* v (how-much-in k)))))))
  (how-much-in))

(module+ main
  (define lst (load-bags (file->lines "../inputs/day07")))
  (printf "part1: ~a~npart2: ~a~n" (part1 lst) (part2 lst)))
