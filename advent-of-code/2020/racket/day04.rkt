#! /usr/bin/env racket
#lang racket/base

(require racket/file
         racket/match
         racket/string)

(module+ test
  (require rackunit)
  (define seems-valid1
    "ecl:gry pid:860033327 eyr:2020 hcl:#fffffd byr:1937 iyr:2017 cid:147 hgt:183cm")
  (define seems-invalid1
    "iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884 hcl:#cfa07d byr:1929")
  (define seems-valid2
    "hcl:#ae17e1 iyr:2013 eyr:2024 ecl:brn pid:760753108 byr:1931 hgt:179cm")
  (define seems-invalid2
    "hcl:#cfa07d eyr:2025 pid:166559648 iyr:2011 ecl:brn hgt:59in")
  (define invalid1
    "eyr:1972 cid:100 hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926")
  (define invalid2
    "iyr:2019 hcl:#602927 eyr:1967 hgt:170cm ecl:grn pid:012533040 byr:1946")
  (define invalid3
    "hcl:dab227 iyr:2012 ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277")
  (define invalid4
    "hgt:59cm ecl:zzz eyr:2038 hcl:74454a iyr:2023 pid:3556412378 byr:2007")
  (define valid1
    "pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980 hcl:#623a2f")
  (define valid2
    "eyr:2029 ecl:blu cid:129 byr:1989 iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm")
  (define valid3
    "hcl:#888785 hgt:164cm byr:2001 iyr:2015 cid:88 pid:545766238 ecl:hzl eyr:2022")
  (define valid4
    "iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719"))


(define (hash-from-passport passport)
  (make-hash (map (lambda (x) (cons (car x) (cadr x)))
                  (map (lambda (str) (string-split str ":"))
                       (string-split passport " ")))))

(define (load-passport-from-file file)
  (define/match (group passports pass rawlst)
    [ (_ _ '())          (cons (string-join pass) passports) ]
    [ (_ _ `( "" . ,xs)) (group (cons (string-join pass) passports) '() xs) ]
    [ (_ _ `( ,x . ,xs)) (group passports (cons x pass) xs) ])
  (map hash-from-passport (group '() '() (file->lines file))))

(define (seems-valid passport)
  (define keys '("byr" "iyr" "eyr" "hgt" "hcl" "ecl" "pid"))
  (foldl (lambda (key acc) (and acc (hash-has-key? passport key))) #t keys))

(module+ test
  (check-equal? (seems-valid (hash-from-passport seems-valid1)) #t)
  (check-equal? (seems-valid (hash-from-passport seems-invalid1)) #f)
  (check-equal? (seems-valid (hash-from-passport seems-valid2)) #t)
  (check-equal? (seems-valid (hash-from-passport seems-invalid2)) #f))

(define (is-valid passport)
  (define (valid-byr byr)
    (define byr_num (string->number byr))
    (and (<= 1920 byr_num) (<= byr_num 2002)))
  (define (valid-iyr iyr)
    (define iyr_num (string->number iyr))
    (and (<= 2010 iyr_num) (<= iyr_num 2020)))
  (define (valid-eyr eyr)
    (define eyr_num (string->number eyr))
    (and (<= 2020 eyr_num) (<= eyr_num 2030)))
  (define (valid-hgt hgt)
    (list? (regexp-match #px"^1(?:[5-8][0-9]|9[0-3])cm$|^(?:59|6[0-9]|7[0-6])in$" hgt)))
  (define (valid-hcl hcl)
    (list? (regexp-match #px"^#[0-9a-f]{6}$" hcl)))
  (define (valid-ecl ecl)
    (list? (regexp-match #px"^amb|blu|brn|gry|grn|hzl|oth$" ecl)))
  (define (valid-pid pid)
    (list? (regexp-match #px"^[0-9]{9}$" pid)))
  (define (all? pred lst)
    (foldl (lambda (el acc) (and acc (pred el))) #t lst))
  (define rules `(,`("byr" ,valid-byr) ,`("iyr" ,valid-iyr) ,`("eyr" ,valid-eyr)
                  ,`("hgt" ,valid-hgt) ,`("hcl" ,valid-hcl) ,`("ecl" ,valid-ecl)
                  ,`("pid" ,valid-pid)))
  (all? (match-lambda [`(,id ,policy) (policy (hash-ref passport id))]) rules))

(module+ test
  (check-equal? (is-valid (hash-from-passport invalid1)) #f)
  (check-equal? (is-valid (hash-from-passport invalid2)) #f)
  (check-equal? (is-valid (hash-from-passport invalid3)) #f)
  (check-equal? (is-valid (hash-from-passport invalid4)) #f)
  (check-equal? (is-valid (hash-from-passport valid1))   #t)
  (check-equal? (is-valid (hash-from-passport valid2))   #t)
  (check-equal? (is-valid (hash-from-passport valid3))   #t)
  (check-equal? (is-valid (hash-from-passport valid4))   #t))

(module+ main
  (define (part1 passports)
    (length (filter seems-valid passports)))

  (define (part2 passports)
    (length (filter is-valid (filter seems-valid passports))))

  (define input (load-passport-from-file "../inputs/day04"))
  (printf "part1: ~a~npart2: ~a~n" (part1 input) (part2 input)))
