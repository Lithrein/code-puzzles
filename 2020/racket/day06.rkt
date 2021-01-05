#! /usr/bin/env racket
#lang racket/base

(require racket/file
         racket/function
         racket/match
         racket/set
         racket/string)

(define (sets-from-group grp)
  (map list->set (map string->list grp)))

(define (load-answers-group-from-file file)
  (define/match (group answer-grps grp rawlst)
    [ (_ _ '())          (cons grp answer-grps) ]
    [ (_ _ `( "" . ,xs)) (group (cons grp answer-grps) '() xs) ]
    [ (_ _ `( ,x . ,xs)) (group answer-grps (cons x grp) xs) ])
  (map sets-from-group (group '() '() (file->lines file))))

(define (part1 answer-grps)
  (foldl + 0 (map (compose set-count (curry apply set-union)) answer-grps)))

(define (part2 answer-grps)
  (foldl + 0 (map (compose set-count (curry apply set-intersect)) answer-grps)))

(module+ main
  (define input (load-answers-group-from-file "../inputs/day06"))
  (printf "part1: ~a~npart2: ~a~n" (part1 input) (part2 input)))
