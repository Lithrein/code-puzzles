#lang racket/base

(require racket/stream
         racket/file
         racket/list
         racket/match
         racket/cmdline
         racket/splicing)

(require (for-syntax racket/base)
         (for-syntax syntax/parse))

(struct ctx (pc mem regs stack) #:mutable)

(define +binary-file+ "challenge.bin")
(define +memsize+ (- (expt 2 16) 1))
(define +nb-regs+ 8)
(define +debug+ #f)

(define run-mode (make-parameter #f))
(define disassemble-mode (make-parameter #f))

(define (reg? addr)
  (and (>= addr 32768) (<= addr 32775)))

(define (valid-addr? addr)
  (and (>= addr 0) (<= addr 32767)))

(define (reg-number addr)
  (- addr 32768))

(define (reg-value ctx addr)
  (vector-ref (ctx-regs ctx) (reg-number addr)))

(define (read-mem ctx offset)
  (vector-ref (ctx-mem ctx) offset))

(define (read-mem/pc ctx offset)
  (vector-ref (ctx-mem ctx) (+ (ctx-pc ctx) offset)))

(define (read-arg ctx offset)
  (let ((addr (read-mem/pc ctx offset)))
    (cond
      [(valid-addr? addr) addr]
      [(reg? addr) (reg-value ctx addr)]
      [else 'err])))

(define (write-mem ctx addr val)
  (cond
    [(valid-addr? addr) (vector-set! (ctx-mem ctx) addr val)]
    [(reg? addr) (vector-set! (ctx-regs ctx) (reg-number addr) val)]
    [else 'err]))

(define (bool->integer b) (if b 1 0))

(struct instr
  (args debug-format disassembly-format io
   mem-update regs-update stack-update pc-update))

(define-for-syntax (instr-expand stx)
    (syntax-case stx ()
    [(hd . tl) (with-syntax ([nhd (instr-expand #'hd)]
                                 [ntl (instr-expand #'tl)])
                 #'(nhd . ntl))]
    [elem (let ((s (syntax->datum #'elem)))
           (cond
             [(number? s) #'elem]
             [(string? s) #'elem]
             [(symbol? s)
              (cond [(equal? (string-ref (symbol->string s) 0) #\%)
                     (let ((n (string->number (substring (symbol->string s) 1))))
                       #`(vector-ref args #,n))]
                    [(equal? (symbol->string s) "$ctx")  #'ctx]
                    [(equal? (symbol->string s) "$pc")  #'(ctx-pc ctx)]
                    [(equal? (symbol->string s) "$mem")  #'(ctx-mem ctx)]
                    [(equal? (symbol->string s) "$regs")  #'(ctx-regs ctx)]
                    [(equal? (symbol->string s) "$stack")  #'(ctx-stack ctx)]
                    [else #'elem])]
             [(equal? s '()) #'()]
             [else #'elem]))]))

(define-syntax (define-instr stx)
  (syntax-parse stx
    [(define-instr name
       (~alt (~optional (~seq #:args (args-ex:expr ...)))
             (~optional (~seq #:debug-format (debug-ex:expr ...)))
             (~optional (~seq #:disassembly-format (disassembly-ex:expr ...)))
             (~optional (~seq #:io (io-ex:expr ...)))
             (~optional (~seq #:mem-update (mem-update-ex:expr ...)))
             (~optional (~seq #:regs-update (regs-update-ex:expr ...)))
             (~optional (~seq #:stack-update (stack-update-ex:expr ...)))
             (~optional (~seq #:pc-update (pc-update-ex:expr ...))))
       ...)
     (with-syntax
       ([instr-name
        (datum->syntax #'name (string->symbol
                               (format "instr/~a" (syntax->datum #'name))))]
        [debug       (or (attribute debug-ex)        #'(""))]
        [disassembly (or (attribute disassembly-ex)  #'(""))]
        [io          (or (attribute io-ex)           #'(null))]
        [mem         (or (attribute mem-update-ex)   #'(null))]
        [regs        (or (attribute regs-update-ex)  #'(null))]
        [stack       (or (attribute stack-update-ex) #'((ctx-stack ctx)))]
        [pc          (or (attribute pc-update-ex)    #'((ctx-pc ctx)))])
        #`(define instr-name
            (instr
             (~? '(args-ex ...) '())
             (lambda (ctx args) #,@(instr-expand #'debug))
             (lambda (ctx args) #,@(instr-expand #'disassembly))
             (lambda (args) #,@(instr-expand #'io))
             (lambda (ctx args) #,@(instr-expand #'mem) (ctx-mem ctx))
             (lambda (ctx args) #,@(instr-expand #'regs) (ctx-regs ctx))
             (lambda (ctx args) #,@(instr-expand #'stack))
             (lambda (ctx args) #,@(instr-expand #'pc)))))]))

(define-syntax (define-unary-instr stx)
  (syntax-case stx ()
    [(_ name op)
     #'(define-instr name
          #:args (addr imm imm)
          #:mem-update ((write-mem $ctx %0 (op %1)))
          #:regs-update ((write-mem $ctx %0 (op %1)))
          #:pc-update ((+ 3 $pc)))]))

(define-syntax (define-binary-instr stx)
  (syntax-case stx ()
    [(_ name op)
     #'(define-instr name
          #:args (addr imm imm)
          #:mem-update ((write-mem $ctx %0 (op %1 %2)))
          #:regs-update ((write-mem $ctx %0 (op %1 %2)))
          #:pc-update ((+ 4 $pc)))]))

(splicing-let
    ([embed-uop (lambda (op) (lambda (x) (modulo (op x) (expt 2 15))))]
     [embed-bop (lambda (op) (lambda (x y) (modulo (op x y) (expt 2 15))))]
     [embed-bool (lambda (op) (lambda (x y) (bool->integer (op x y))))])
  (define-binary-instr add (embed-bop +))
  (define-binary-instr mul (embed-bop *))
  (define-binary-instr mod (embed-bop modulo))
  (define-unary-instr  not (embed-uop bitwise-not))
  (define-binary-instr and (embed-bop bitwise-and))
  (define-binary-instr or  (embed-bop bitwise-ior))
  (define-binary-instr eq  (embed-bool =))
  (define-binary-instr gt  (embed-bool >)))

(define-instr nop
  #:debug-format ("nop")
  #:pc-update ((+ 1 $pc)))

(define-instr in
  #:args (addr in)
  #:mem-update ((write-mem $ctx %0 %1))
  #:regs-update ((write-mem $ctx %0 %1))
  #:pc-update ((+ 2 $pc)))

(define-instr out
  #:args (imm)
  #:io ((write-byte %0))
  #:pc-update ((+ 2 $pc)))

(define-instr jmp
  #:args (imm)
  #:pc-update (%0))

(define-instr jt
  #:args (imm imm)
  #:pc-update ((if (= 0 %0) (+ 3 $pc) %1)))

(define-instr jf
  #:args (imm imm)
  #:pc-update ((if (= 0 %0) %1 (+ 3 $pc))))

(define-instr set
  #:args (reg imm)
  #:regs-update ((vector-set! $regs %0 %1))
  #:pc-update ((+ 3 $pc)))

(define-instr push
  #:args (imm)
  #:stack-update ((cons %0 $stack))
  #:pc-update ((+ 2 $pc)))

(define-instr pop
  #:args (addr stack)
  #:regs-update ((write-mem $ctx %0 %1))
  #:mem-update ((write-mem $ctx %0 %1))
  #:stack-update ((cdr $stack))
  #:pc-update ((+ 2 $pc)))

(define-instr rmem
  #:args (addr deref)
  #:regs-update ((write-mem $ctx %0 %1))
  #:mem-update ((write-mem $ctx %0 %1))
  #:pc-update ((+ 3 $pc)))

(define-instr wmem
  #:args (imm imm)
  #:regs-update ((write-mem $ctx %0 %1))
  #:mem-update ((write-mem $ctx %0 %1))
  #:pc-update ((+ 3 $pc)))

(define-instr call
  #:args (imm)
  #:stack-update ((cons (+ 2 $pc) $stack))
  #:pc-update (%0))

(define-instr ret
  #:args (stack)
  #:stack-update ((cdr $stack))
  #:pc-update (%0))

(define (process-args ctx arg-types)
  (define args (make-vector (length arg-types)))
  (for/fold ([i 0]) ([type arg-types])
    (case type
      ['imm   (vector-set! args i (read-arg ctx (+ i 1)))]
      ['in    (vector-set! args i (char->integer (read-char)))]
      ['addr  (vector-set! args i (read-mem/pc ctx (+ i 1)))]
      ['deref (vector-set! args i (read-mem ctx (read-arg ctx (+ i 1))))]
      ['stack (vector-set! args i (car (ctx-stack ctx)))]
      ['reg   (vector-set! args i (reg-number (read-mem/pc ctx (+ i 1))))])
    (+ i (bool->integer (or (equal? type 'imm)
                            (equal? type 'addr)
                            (equal? type 'reg)))))
  args)

(define (exec instr ctx)
  (let ((args (process-args ctx (instr-args instr))))
    ((instr-io instr) args)
    (set-ctx-mem! ctx ((instr-mem-update instr) ctx args))
    (set-ctx-stack! ctx ((instr-stack-update instr) ctx args))
    (set-ctx-regs! ctx ((instr-regs-update instr) ctx args))
    (set-ctx-pc! ctx ((instr-pc-update instr) ctx args))))

(define/match (instr->opcode instr)
  [(00) 'halt]      [(01) instr/set]  [(02) instr/push]
  [(03) instr/pop]  [(04) instr/eq]   [(05) instr/gt]
  [(06) instr/jmp]  [(07) instr/jt]   [(08) instr/jf]
  [(09) instr/add]  [(10) instr/mul]  [(11) instr/mod]
  [(12) instr/and]  [(13) instr/or]   [(14) instr/not]
  [(15) instr/rmem] [(16) instr/wmem] [(17) instr/call]
  [(18) instr/ret]  [(19) instr/out]  [(20) instr/in]
  [(21) instr/nop]  [(imm) `(imm ,imm)])

(define (step ctx)
  (let ((instr (vector-ref (ctx-mem ctx) (ctx-pc ctx))))
    (match (instr->opcode instr)
      ['halt `(halt . ctx)]
      [`(imm ,imm)  `(ko . ,(format "instr: ~a" imm))]
      [op `(ok . ,(exec op ctx))])))

(define (run-program ctx)
  (match (step ctx)
    [`(ok . ,_) (run-program ctx)]
    [`(ko . ,err) `(failure ,(format "pc: ~a" (ctx-pc ctx)) ,err)]
    [`(halt . ,_) 'success]))

(define (disassemble-program ctx)
  ;; un-implemented
  "")

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
