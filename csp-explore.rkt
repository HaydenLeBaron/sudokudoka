

#lang racket
(require csp)
(require math/number-theory)
(require racket/set)
(require rackunit)



;; EXAMPLE
;; ;; valid-triple constraint
;; (define (valid-triple? x y z)
;;   (= (expt z 2) (+ (expt x 2) (expt y 2))))


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


(define cells (range 81))
(define vals (range 1 10))
(define (all-unique? num-list)
  (= (length num-list) (length (list->set num-list))))

(define (num-at-idx=arg? num-list idx arg)
  (= (list-ref num-list idx) arg))




;; TODO: figure out the idiomatic way to express this concisely
(define row0-cells (filter (λ (cell) (= (quotient cell 9) 0)) cells))
(define row1-cells (filter (λ (cell) (= (quotient cell 9) 1)) cells))
(define row2-cells (filter (λ (cell) (= (quotient cell 9) 2)) cells))
(define row3-cells (filter (λ (cell) (= (quotient cell 9) 3)) cells))
(define row4-cells (filter (λ (cell) (= (quotient cell 9) 4)) cells))
(define row5-cells (filter (λ (cell) (= (quotient cell 9) 5)) cells))
(define row6-cells (filter (λ (cell) (= (quotient cell 9) 6)) cells))
(define row7-cells (filter (λ (cell) (= (quotient cell 9) 7)) cells))
(define row8-cells (filter (λ (cell) (= (quotient cell 9) 8)) cells))

(define col0-cells (filter (λ (cell) (= (remainder cell 9) 0)) cells))
(define col1-cells (filter (λ (cell) (= (remainder cell 9) 1)) cells))
(define col2-cells (filter (λ (cell) (= (remainder cell 9) 2)) cells))
(define col3-cells (filter (λ (cell) (= (remainder cell 9) 3)) cells))
(define col4-cells (filter (λ (cell) (= (remainder cell 9) 4)) cells))
(define col5-cells (filter (λ (cell) (= (remainder cell 9) 5)) cells))
(define col6-cells (filter (λ (cell) (= (remainder cell 9) 6)) cells))
(define col7-cells (filter (λ (cell) (= (remainder cell 9) 7)) cells))
(define col8-cells (filter (λ (cell) (= (remainder cell 9) 8)) cells))






(define constraints
  (list
    	(constraint row0-cells all-unique?)
        (constraint row1-cells all-unique?)
        (constraint row2-cells all-unique?)
        (constraint row3-cells all-unique?)
        (constraint row4-cells all-unique?)
        (constraint row5-cells all-unique?)
        (constraint row6-cells all-unique?)
        (constraint row7-cells all-unique?)
        (constraint row8-cells all-unique?)
    	  (constraint col0-cells all-unique?)
        (constraint col1-cells all-unique?)
        (constraint col2-cells all-unique?)
        (constraint col3-cells all-unique?)
        (constraint col4-cells all-unique?)
        (constraint col5-cells all-unique?)
        (constraint col6-cells all-unique?)
        (constraint col7-cells all-unique?)
        (constraint col8-cells all-unique?)
        ;; TODO: add grid constraints

        ;; TODO: add individual constraints for wikipedia example
        (constraint num-at-idx=arg? cells IDX ARG)


	)
  )

;; TODO: figure out the idiomatic way to express this concisely
(define vars
  (list (var 0 vals)
        (var 1 vals)
        (var 2 vals)
        (var 3 vals)
        (var 4 vals)
        (var 5 vals)
        (var 7 vals)
        (var 8 vals)
        (var 9 vals)
        (var 10 vals)
        (var 11 vals)
        (var 12 vals)
        (var 13 vals)
        (var 14 vals)
        (var 15 vals)
        (var 16 vals)
        (var 17 vals)
        (var 18 vals)
        (var 19 vals)
        (var 20 vals)
        (var 21 vals)
        (var 22 vals)
        (var 23 vals)
        (var 24 vals)
        (var 25 vals)
        (var 26 vals)
        (var 27 vals)
        (var 28 vals)
        (var 29 vals)
        (var 30 vals)
        (var 31 vals)
        (var 32 vals)
        (var 33 vals)
        (var 34 vals)
        (var 35 vals)
        (var 36 vals)
        (var 37 vals)
        (var 38 vals)
        (var 39 vals)
        (var 40 vals)
        (var 41 vals)
        (var 42 vals)
        (var 43 vals)
        (var 44 vals)
        (var 45 vals)
        (var 46 vals)
        (var 47 vals)
        (var 48 vals)
        (var 49 vals)
        (var 50 vals)
        (var 51 vals)
        (var 52 vals)
        (var 53 vals)
        (var 54 vals)
        (var 55 vals)
        (var 56 vals)
        (var 57 vals)
        (var 58 vals)
        (var 59 vals)
        (var 60 vals)
        (var 61 vals)
        (var 62 vals)
        (var 63 vals)
        (var 64 vals)
        (var 65 vals)
        (var 66 vals)
        (var 67 vals)
        (var 68 vals)
        (var 69 vals)
        (var 70 vals)
        (var 71 vals)
        (var 72 vals)
        (var 73 vals)
        (var 74 vals)
        (var 75 vals)
        (var 76 vals)
        (var 77 vals)
        (var 78 vals)
        (var 79 vals)
        (var 80 vals)))



(define sudoku
  (make-csp vars constraints))

;; =====================
;; TESTS
;; =====================


(check-equal? (all-unique? (list 1 2 3 4 5)) #t)
(check-equal? (all-unique? (list 1 1 2 3 4 5)) #t)

(current-inference forward-check)
(current-select-variable mrv-degree-hybrid)
(current-order-values shuffle)
(current-node-consistency #t)
(current-arity-reduction #t)


(solve sudoku)
