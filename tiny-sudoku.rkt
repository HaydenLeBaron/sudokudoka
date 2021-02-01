;; 4x4 sudoku solver



;; ;; Define constraint-satisfaction problem
;; (define triples
;;   (let ([domain (range 1 30)])
;;     (make-csp
;;      (list (var 'a domain)
;;            (var 'b domain)
;;            (var 'c domain))
;;      (list (constraint (list 'a 'b 'c) valid-triple?)
;;            (constraint (list 'a 'b) <=)
;;            (constraint (list 'a 'b 'c) coprime?)))))

;; ;; Find all solutions
;; (solve* triples)




#lang racket
(require csp)
(require math/number-theory)
(require racket/set)
(require rackunit)

(define cells (range 16))
(define vals (range 1 5))
(define (all-unique? a b c d)
  (= (length (list a b c d)) (length (set->list(list->set (list a b c d))))))

;(define (num-at-cellidx=arg? idx arg)
;(= (list-ref cells idx) arg))



;; TODO: figure out the idiomatic way to express this concisely
(define row0-cells (filter (λ (cell) (= (quotient cell 4) 0)) cells))
(define row1-cells (filter (λ (cell) (= (quotient cell 4) 1)) cells))
(define row2-cells (filter (λ (cell) (= (quotient cell 4) 2)) cells))
(define row3-cells (filter (λ (cell) (= (quotient cell 4) 3)) cells))

(define col0-cells (filter (λ (cell) (= (remainder cell 4) 0)) cells))
(define col1-cells (filter (λ (cell) (= (remainder cell 4) 1)) cells))
(define col2-cells (filter (λ (cell) (= (remainder cell 4) 2)) cells))
(define col3-cells (filter (λ (cell) (= (remainder cell 4) 3)) cells))



(define (board-spec a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15)
  (and
   (= a0 1)
   ;(= a2 x)
   ;(= a3 x)
   ;(= a4 x)
   ;(= a5 x)
   ;(= a6 x)
   (= a7 4)
   ;(= a8 x)
   ;(= a9 x)
   (= a10 2)
   ;(= a11 x)
   ;(= a12 x)
   (= a13 3)
   ;(= a14 x)
   ;(= a15 x)
   ))


(define constraints
  (list

   ;; Row uniqueness constraints
   (constraint row0-cells all-unique?)
   (constraint row1-cells all-unique?)
   (constraint row2-cells all-unique?)
   (constraint row3-cells all-unique?)

   ;; Column uniqueness constraints
   (constraint col0-cells all-unique?)

   (constraint col2-cells all-unique?)
   (constraint col3-cells all-unique?)

   ;; Grid uniqueness constraints
   ;; TODO: add grid constraints

   ;; Individual cell constraints

   ;; TODO: wrap up into one function that takes all cells
   ;; and their corresponding expected values
   (constraint cells board-spec)
   ;(constraint '(0) (num-at-cellidx=arg? 0 3))
   ;(constraint '(2) (num-at-cellidx=arg? 2 4))
   ;(constraint '(5) (num-at-cellidx=arg? 5 1))
   ;(constraint '(7) (num-at-cellidx=arg? 7 2))
   ;(constraint '(9) (num-at-cellidx=arg? 9 4))
   ;(constraint '(11) (num-at-cellidx=arg? 11 3))
   ;(constraint '(12) (num-at-cellidx=arg? 12 2))
   ;(constraint '(14) (num-at-cellidx=arg? 14 1))
	))

;; TODO: figure out the idiomatic way to express this concisely
(define vars
  (list (var 0 vals)
        (var 1 vals)
        (var 2 vals)
        (var 3 vals)
        (var 4 vals)
        (var 5 vals)
        (var 6 vals)
        (var 7 vals)
        (var 8 vals)
        (var 9 vals)
        (var 10 vals)
        (var 11 vals)
        (var 12 vals)
        (var 13 vals)
        (var 14 vals)
        (var 15 vals)
        )
  )

;; =====================
;; UTILS
;; =====================

;(define (print-sudoku sudoku)
;  ...sudoku...
;  )


;; =====================
;; TESTS
;; =====================


(check-equal? (all-unique? 1 2 3 4) #t)
(check-equal? (all-unique? 1 1 2 3) #f)

(current-inference forward-check)
(current-select-variable mrv-degree-hybrid)
(current-order-values shuffle)
(current-node-consistency #t)
(current-arity-reduction #t)

;(define sudoku
;(make-csp vars constraints))

;(print vars)
;(print "\n")
;(print constraints)

(define soln (solve (make-csp vars constraints)))
(print soln)

