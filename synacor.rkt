#lang racket/base

(require racket/stream
         racket/file
         racket/list
         racket/match
         racket/cmdline)

(struct ctx (pc mem regs stack) #:mutable)

(define +binary-file+ "dump")
(define +memsize+ (- (expt 2 16) 1))
(define +nb-regs+ 8)
(define +debug+ #f)

(define run-mode (make-parameter #f))
(define disassemble-mode (make-parameter #f))

(define/match (instr->opcode instr)
  [(00) 'halt]
  [(01) 'set]
  [(02) 'push]
  [(03) 'pop]
  [(04) 'eq]
  [(05) 'gt]
  [(06) 'jmp]
  [(07) 'jt]
  [(08) 'jf]
  [(09) 'add]
  [(10) 'mul]
  [(11) 'mod]
  [(12) 'and]
  [(13) 'or]
  [(14) 'not]
  [(15) 'rmem]
  [(16) 'wmem]
  [(17) 'call]
  [(18) 'ret]
  [(19) 'out]
  [(20) 'in]
  [(21) 'nop]
  [(imm) `('imm ,imm)])

;; (define (new-ctx)
;;   (ctx 0
;;        (make-vector +memsize+ 0)
;;        (make-vector +nb-regs+ 0)
;;        '()))

(define (mem-at-pc ctx offset)
  (let ((val (vector-ref (ctx-mem ctx) (+ (ctx-pc ctx) offset))))
    (cond
      [(< val 32768) val]
      [(< val 32776) (vector-ref (ctx-regs ctx) (- val 32768))])))

(define (do-out ctx)
  (when +debug+
    (display (format "do-out ~a(~a)~n" (mem-at-pc ctx 1) (vector-ref (ctx-mem ctx) (+ 1 (ctx-pc ctx))))))
  (write-byte (mem-at-pc ctx 1))
  (set-ctx-pc! ctx (+ 2 (ctx-pc ctx)))
  ctx)

(define (do-noop ctx)
  (when +debug+
    (display (format "nop~n")))
  (set-ctx-pc! ctx (+ 1 (ctx-pc ctx)))
  ctx)

(define (do-jmp ctx)
  (when +debug+
    (display (format "jmp to ~a(~a)~n" (mem-at-pc ctx 1) (vector-ref (ctx-mem ctx) (+ 1 (ctx-pc ctx))))))
  (set-ctx-pc! ctx (mem-at-pc ctx 1))
  ctx)

(define (do-jf ctx)
  (when +debug+
    (display (format "jf ~a(~a) to ~a(~a)~n"
                     (mem-at-pc ctx 1) (vector-ref (ctx-mem ctx) (+ 1 (ctx-pc ctx)))
                     (mem-at-pc ctx 2) (vector-ref (ctx-mem ctx) (+ 2 (ctx-pc ctx))))))
  (cond
    [(= 0 (mem-at-pc ctx 1)) 
     (when +debug+
       (display (format "jf'ed~n")))
     (set-ctx-pc! ctx (mem-at-pc ctx 2))]
    [else
     (when +debug+
       (display (format "no jf'ed~n")))
     (set-ctx-pc! ctx (+ (ctx-pc ctx) 3))])
  ctx)

(define (do-jt ctx)
  (when +debug+
    (display (format "jt ~a(~a) to ~a(~a)~n"
                     (mem-at-pc ctx 1) (vector-ref (ctx-mem ctx) (+ 1 (ctx-pc ctx)))
                     (mem-at-pc ctx 2) (vector-ref (ctx-mem ctx) (+ 2 (ctx-pc ctx))))))
  (cond
    [(not (= 0 (mem-at-pc ctx 1))) 
     (when +debug+
       (display (format "jt'ed~n")))
     (set-ctx-pc! ctx (mem-at-pc ctx 2))]
    [else
     (when +debug+
       (display (format "no jt'ed~n")))
     (set-ctx-pc! ctx (+ (ctx-pc ctx) 3))])
  ctx)

(define (do-set ctx)
  (when +debug+
    (display (format "set reg ~a(~a) to ~a(~a)~n"
                     (- (vector-ref (ctx-mem ctx) (+ 1 (ctx-pc ctx))) 32768)
                     (vector-ref (ctx-mem ctx) (+ 1 (ctx-pc ctx)))
                     (mem-at-pc ctx 2)
                     (vector-ref (ctx-mem ctx) (+ 2 (ctx-pc ctx))))))
  (vector-set! (ctx-regs ctx) (- (vector-ref (ctx-mem ctx) (+ 1 (ctx-pc ctx))) 32768) (mem-at-pc ctx 2))
  (set-ctx-pc! ctx (+ (ctx-pc ctx) 3))
  ctx)

(define (do-add ctx)
  (let ((a (vector-ref (ctx-mem ctx) (+ 1 (ctx-pc ctx))))
        (res (modulo (+ (mem-at-pc ctx 2) (mem-at-pc ctx 3)) (expt 2 15))))
    (when +debug+
      (display (format "~a = ~a(~a) + ~a(~a) (mod 32768) = ~a"
                       a (mem-at-pc ctx 2) (vector-ref (ctx-mem ctx) (+ (ctx-pc ctx) 2))
                       (mem-at-pc ctx 3) (vector-ref (ctx-mem ctx) (+ (ctx-pc ctx) 3))
                       res))) 
    (cond
      [(< a 32768) (vector-set! (ctx-mem ctx) a res)]
      [(< a 32776) (vector-set! (ctx-regs ctx) (- a 32768) res)]))
  (set-ctx-pc! ctx (+ (ctx-pc ctx) 4))
  ctx)

(define (do-mul ctx)
  (let ((a (vector-ref (ctx-mem ctx) (+ 1 (ctx-pc ctx))))
        (res (modulo (* (mem-at-pc ctx 2) (mem-at-pc ctx 3)) (expt 2 15))))
    (when +debug+
      (display (format "~a = ~a(~a) * ~a(~a) (mod 32768) = ~a"
                       a (mem-at-pc ctx 2) (vector-ref (ctx-mem ctx) (+ (ctx-pc ctx) 2))
                       (mem-at-pc ctx 3) (vector-ref (ctx-mem ctx) (+ (ctx-pc ctx) 3))
                       res))) 
    (cond
      [(< a 32768) (vector-set! (ctx-mem ctx) a res)]
      [(< a 32776) (vector-set! (ctx-regs ctx) (- a 32768) res)]))
  (set-ctx-pc! ctx (+ (ctx-pc ctx) 4))
  ctx)

(define (do-mod ctx)
  (let ((a (vector-ref (ctx-mem ctx) (+ 1 (ctx-pc ctx))))
        (res (modulo (modulo (mem-at-pc ctx 2) (mem-at-pc ctx 3)) (expt 2 15))))
    (when +debug+
      (display (format "~a = ~a(~a) mod ~a(~a) (mod 32768) = ~a"
                       a (mem-at-pc ctx 2) (vector-ref (ctx-mem ctx) (+ (ctx-pc ctx) 2))
                       (mem-at-pc ctx 3) (vector-ref (ctx-mem ctx) (+ (ctx-pc ctx) 3))
                       res))) 
    (cond
      [(< a 32768) (vector-set! (ctx-mem ctx) a res)]
      [(< a 32776) (vector-set! (ctx-regs ctx) (- a 32768) res)]))
  (set-ctx-pc! ctx (+ (ctx-pc ctx) 4))
  ctx)

(define (mem-at-addr ctx addr)
    (cond
      [(< addr 32768) (vector-ref (ctx-mem ctx) addr)]
      [(< addr 32776) (vector-ref (ctx-regs ctx) (- addr 32768))]))

(define (do-rmem ctx)
  (let ((a (vector-ref (ctx-mem ctx) (+ 1 (ctx-pc ctx))))
        (b (vector-ref (ctx-mem ctx) (mem-at-pc ctx 2))))
    (when +debug+
      (display (format "rmem:~n"))
      (display (format "read ~a(~a) and write it into ~a~n" b (mem-at-pc ctx 2) a)))
    (cond
      [(< a 32768) (vector-set! (ctx-mem ctx) a b)]
      [(< a 32776) (vector-set! (ctx-regs ctx) (- a 32768) b)]))
  (set-ctx-pc! ctx (+ (ctx-pc ctx) 3))
  ctx)

(define (do-wmem ctx)
  (let ((a (mem-at-pc ctx 1))
        (b (mem-at-pc ctx 2)))
    (when +debug+
      (display (format "wmem:~n"))
      (display (format "write ~a into ~a(~a)~n" (mem-at-pc ctx 2) a (mem-at-pc ctx 1))))
    (cond
      [(< a 32768) (vector-set! (ctx-mem ctx) a b)]
      [(< a 32776) (vector-set! (ctx-regs ctx) (- a 32768) b)]))
  (set-ctx-pc! ctx (+ (ctx-pc ctx) 3))
  ctx)

(define (do-eq ctx)
  (let ((a (vector-ref (ctx-mem ctx) (+ 1 (ctx-pc ctx))))
        (res (if (= (mem-at-pc ctx 2) (mem-at-pc ctx 3)) 1 0)))
    (cond
      [(< a 32768) (vector-set! (ctx-mem ctx) a res)]
      [(< a 32776) (vector-set! (ctx-regs ctx) (- a 32768) res)]))
  (set-ctx-pc! ctx (+ (ctx-pc ctx) 4))
  ctx)

(define (do-gt ctx)
  (let ((a (vector-ref (ctx-mem ctx) (+ 1 (ctx-pc ctx))))
        (res (if (> (mem-at-pc ctx 2) (mem-at-pc ctx 3)) 1 0)))
    (cond
      [(< a 32768) (vector-set! (ctx-mem ctx) a res)]
      [(< a 32776) (vector-set! (ctx-regs ctx) (- a 32768) res)]))
  (set-ctx-pc! ctx (+ (ctx-pc ctx) 4))
  ctx)

(define (do-and ctx)
  (let ((a (vector-ref (ctx-mem ctx) (+ 1 (ctx-pc ctx))))
        (res (bitwise-and (mem-at-pc ctx 2) (mem-at-pc ctx 3))))
    (cond
      [(< a 32768) (vector-set! (ctx-mem ctx) a res)]
      [(< a 32776) (vector-set! (ctx-regs ctx) (- a 32768) res)]))
  (set-ctx-pc! ctx (+ (ctx-pc ctx) 4))
  ctx)

(define (do-or ctx)
  (let ((a (vector-ref (ctx-mem ctx) (+ 1 (ctx-pc ctx))))
        (res (bitwise-ior (mem-at-pc ctx 2) (mem-at-pc ctx 3))))
    (cond
      [(< a 32768) (vector-set! (ctx-mem ctx) a res)]
      [(< a 32776) (vector-set! (ctx-regs ctx) (- a 32768) res)]))
  (set-ctx-pc! ctx (+ (ctx-pc ctx) 4))
  ctx)

(define (do-not ctx)
  (let ((a (vector-ref (ctx-mem ctx) (+ 1 (ctx-pc ctx))))
        (res (modulo (bitwise-not (mem-at-pc ctx 2)) (expt 2 15))))
    (cond
      [(< a 32768) (vector-set! (ctx-mem ctx) a res)]
      [(< a 32776) (vector-set! (ctx-regs ctx) (- a 32768) res)]))
  (set-ctx-pc! ctx (+ (ctx-pc ctx) 3))
  ctx)

(define (do-push ctx)
  (when +debug+
    (display "push:\n"))
  (set-ctx-stack! ctx (cons (mem-at-pc ctx 1) (ctx-stack ctx)))
  (set-ctx-pc! ctx (+ (ctx-pc ctx) 2))
  ctx)

(define (do-pop ctx)
  (when +debug+
    (display "pop:\n"))
  (let ((res (car (ctx-stack ctx)))
        (a (vector-ref (ctx-mem ctx) (+ 1 (ctx-pc ctx)))))
    (cond
      [(< a 32768) (vector-set! (ctx-mem ctx) a res)]
      [(< a 32776) (vector-set! (ctx-regs ctx) (- a 32768) res)]))
  (set-ctx-stack! ctx (cdr (ctx-stack ctx)))
  (set-ctx-pc! ctx (+ (ctx-pc ctx) 2))
  ctx)

(define (do-call ctx)
  (when +debug+
    (display "call:\n"))
  (set-ctx-stack! ctx (cons (+ 2 (ctx-pc ctx)) (ctx-stack ctx)))
  (set-ctx-pc! ctx (mem-at-pc ctx 1))
  ctx)

(define (do-ret ctx)
  (set-ctx-pc! ctx (car (ctx-stack ctx)))
  (set-ctx-stack! ctx (cdr (ctx-stack ctx)))
  ctx)

;; (define (do-dump ctx)
;;   (with-output-to-file "dump"
;;     (lambda () (map write-byte
;;                     (flatten (map (lambda (i) `(,(bitwise-and i (- (expt 2 8) 1)) . ,(arithmetic-shift i -8))) (vector->list (ctx-mem ctx))))))
;;     #:exists 'replace
;;     #:mode 'binary)
;;   ctx)

(define (do-in ctx)
  (let ((a (vector-ref (ctx-mem ctx) (+ 1 (ctx-pc ctx))))
        (c (char->integer (read-char))))
    (when +debug+
      (display (format "store ~a in ~a~n" c a)))
    (cond
      [(< a 32768) (vector-set! (ctx-mem ctx) a c)]
      [(< a 32776) (vector-set! (ctx-regs ctx) (- a 32768) c)]))
  (set-ctx-pc! ctx (+ (ctx-pc ctx) 2))
  ctx)

(define (do-one-step ctx)
  (let ((instr (vector-ref (ctx-mem ctx) (ctx-pc ctx))))
    (when +debug+
      (read-line)
      (display (format "~a(~a)~nregs: ~a~nstack: ~a~n~n"
                       (ctx-pc ctx) (instr->opcode instr) (ctx-regs ctx) (ctx-stack ctx))))
    (match (instr->opcode instr)
      ['halt `('halt . ctx)]
      ['set  `('ok . ,(do-set ctx))]
      ['push `('ok . ,(do-push ctx))]
      ['pop  `('ok . ,(do-pop ctx))]
      ['eq   `('ok . ,(do-eq ctx))]
      ['gt   `('ok . ,(do-gt ctx))]
      ['jmp  `('ok . ,(do-jmp ctx))]
      ['jt   `('ok . ,(do-jt ctx))]
      ['jf   `('ok . ,(do-jf ctx))]
      ['add  `('ok . ,(do-add ctx))]
      ['mul  `('ok . ,(do-mul ctx))]
      ['mod  `('ok . ,(do-mod ctx))]
      ['and  `('ok . ,(do-and ctx))]
      ['or   `('ok . ,(do-or ctx))]
      ['not  `('ok . ,(do-not ctx))]
      ['rmem `('ok . ,(do-rmem ctx))]
      ['wmem `('ok . ,(do-wmem ctx))]
      ['call `('ok . ,(do-call ctx))]
      ['ret  `('ok . ,(do-ret ctx))]
      ['out  `('ok . ,(do-out ctx))]
      ['in   `('ok . ,(do-in ctx))]
      ['nop  `('ok . ,(do-noop ctx))]
      [_     `('ko . ,(format "instr: ~a" instr))])))

(define (run-program ctx)
  (match (do-one-step ctx)
    [`('ok . ,_) (run-program ctx)]
    [`('ko . ,err) `('failure ,(format "pc: ~a" (ctx-pc ctx)) ,err)]
    [`('halt . ,_) 'success]))


(define (disassemble-program ctx)
  (cond
    [(<  (ctx-pc ctx) 30050)
     (match (instr->opcode (vector-ref (ctx-mem ctx) (ctx-pc ctx)))
       ['halt
        (display (format "~a: halt~n" (ctx-pc ctx)))
        (set-ctx-pc! ctx (+ (ctx-pc ctx) 1))]
       ['set
        (display (format  "~a: set ~a ~a~n" (ctx-pc ctx)
                          (mem-at-pc ctx 1) (mem-at-pc ctx 2)))
        (set-ctx-pc! ctx (+ (ctx-pc ctx) 3))]
       ['push
        (display (format "~a: push ~a~n" (ctx-pc ctx)
                         (vector-ref (ctx-mem ctx) (+ 1 (ctx-pc ctx)))))
        (set-ctx-pc! ctx (+ (ctx-pc ctx) 2))]
       ['pop
        (display (format "~a: pop ~a~n" (ctx-pc ctx)
                         (vector-ref (ctx-mem ctx) (+ 1 (ctx-pc ctx)))))
        (set-ctx-pc! ctx (+ (ctx-pc ctx) 2))]
       ['eq
        (display (format "~a: eq ~a ~a ~a\n" (ctx-pc ctx)
                         (vector-ref (ctx-mem ctx) (+ 1 (ctx-pc ctx)))
                         (mem-at-pc ctx 2) (mem-at-pc ctx 3)))
        (set-ctx-pc! ctx (+ (ctx-pc ctx) 4))]
       ['gt
        (display (format "~a: gt ~a ~a ~a\n" (ctx-pc ctx)
                         (vector-ref (ctx-mem ctx) (+ 1 (ctx-pc ctx)))
                         (mem-at-pc ctx 2) (mem-at-pc ctx 3)))
        (set-ctx-pc! ctx (+ (ctx-pc ctx) 4))]
       ['jmp
        (display (format "~a: jmp ~a~n" (ctx-pc ctx) (mem-at-pc ctx 1)))
        (set-ctx-pc! ctx (+ (ctx-pc ctx) 2))]
       ['jt
        (display (format "~a: jt ~a ~a~n" (ctx-pc ctx)
                         (vector-ref (ctx-mem ctx) (+ 1 (ctx-pc ctx)))
                         (mem-at-pc ctx 2)))
        (set-ctx-pc! ctx (+ (ctx-pc ctx) 3))]
       ['jf
        (display (format "~a: jf ~a ~a~n" (ctx-pc ctx)
                         (vector-ref (ctx-mem ctx) (+ 1 (ctx-pc ctx)))
                         (mem-at-pc ctx 2)))
        (set-ctx-pc! ctx (+ (ctx-pc ctx) 3))]
       ['add
        (display (format  "~a: add ~a ~a ~a ~n" (ctx-pc ctx)
                          (mem-at-pc ctx 1) (mem-at-pc ctx 2) (mem-at-pc ctx 3)))
        (set-ctx-pc! ctx (+ (ctx-pc ctx) 4))]
       ['mul
        (display (format  "~a: mul ~a ~a ~a ~n" (ctx-pc ctx)
                          (mem-at-pc ctx 1) (mem-at-pc ctx 2) (mem-at-pc ctx 3)))
        (set-ctx-pc! ctx (+ (ctx-pc ctx) 4))]
       ['mod
        (display (format  "~a: mod ~a ~a ~a ~n" (ctx-pc ctx)
                          (mem-at-pc ctx 1) (mem-at-pc ctx 2) (mem-at-pc ctx 3)))
        (set-ctx-pc! ctx (+ (ctx-pc ctx) 4))]
       ['and
        (display (format  "~a: and ~a ~a ~a ~n" (ctx-pc ctx)
                          (mem-at-pc ctx 1) (mem-at-pc ctx 2) (mem-at-pc ctx 3)))
        (set-ctx-pc! ctx (+ (ctx-pc ctx) 4))]
       ['or
        (display (format  "~a: or ~a ~a ~a ~n" (ctx-pc ctx)
                          (mem-at-pc ctx 1) (mem-at-pc ctx 2) (mem-at-pc ctx 3)))
        (set-ctx-pc! ctx (+ (ctx-pc ctx) 4))]
       ['not
        (display (format "~a: not ~a ~a~n" (ctx-pc ctx)
                         (vector-ref (ctx-mem ctx) (+ 1 (ctx-pc ctx)))
                         (mem-at-pc ctx 2)))
        (set-ctx-pc! ctx (+ (ctx-pc ctx) 3))]
       ['rmem
        (display (format "~a: rmem ~a ~a~n" (ctx-pc ctx)
                         (vector-ref (ctx-mem ctx) (+ 1 (ctx-pc ctx)))
                         (vector-ref (ctx-mem ctx) (+ 2 (ctx-pc ctx)))))
        (set-ctx-pc! ctx (+ (ctx-pc ctx) 3))]
       ['wmem
        (display (format "~a: wmem ~a ~a~n" (ctx-pc ctx)
                         (vector-ref (ctx-mem ctx) (+ 1 (ctx-pc ctx)))
                         (vector-ref (ctx-mem ctx) (+ 2 (ctx-pc ctx)))))
        (set-ctx-pc! ctx (+ (ctx-pc ctx) 3))]
       ['call
        (display (format  "~a: call ~a~n" (ctx-pc ctx)
                          (vector-ref (ctx-mem ctx) (+ 1 (ctx-pc ctx)))))
        (set-ctx-pc! ctx (+ (ctx-pc ctx) 2))]
       ['ret
        (set-ctx-pc! ctx (+ (ctx-pc ctx) 1)) (display "ret\n")]
       ['out
        (display (format "~a: out ~a~n" (ctx-pc ctx) (integer->char (mem-at-pc ctx 1))))
        (set-ctx-pc! ctx (+ (ctx-pc ctx) 2))]
       ['in
        (set-ctx-pc! ctx (+ (ctx-pc ctx) 2)) (display "in\n")]
       ['nop
        (display (format "~a: nop~n" (ctx-pc ctx)))
        (set-ctx-pc! ctx (+ (ctx-pc ctx) 1))]
       [`('imm ,imm)
        (display (format "~a: $~a~n" (ctx-pc ctx) (integer->char imm)))
        (set-ctx-pc! ctx (+ (ctx-pc ctx) 1))])
     (disassemble-program ctx)]))


(define (file->memory path)
  (define (process lst acc)
    (match lst
      [`(,fst ,snd . ,rest) (process rest (cons (+ fst (* 256 snd)) acc))]
      [`() (reverse acc)]))
  (list->vector (process (bytes->list (file->bytes path)) '())))

(define (run-file path)
  (run-program (ctx 0
                    (file->memory path)
                    (make-vector +nb-regs+ 0)
                    '())))

(define (disassemble-file path)
  (disassemble-program (ctx 0
                    (file->memory path)
                    (make-vector +nb-regs+ 0)
                    '())))

(command-line
 #:program "synacor"
 #:once-any
 [("-r" "--run") "run the synacor vm" (run-mode #t)]
 [("-d" "--disassemble") "disassemble" (disassemble-mode #t)])

(cond
  [(run-mode) (run-file +binary-file+)]
  [(disassemble-mode) (disassemble-file +binary-file+)])
