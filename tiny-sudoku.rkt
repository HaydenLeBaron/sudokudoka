;; 4x4 sudoku solver


;; EXAMPLE OF THE STRUCTURE OF A CSP
;; ---------------------------------
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



(define cells (range 16))
(define dim (sqrt (length cells)))
(define vals (range 1 (+ dim 1)))

(define (all-unique? a b c d)
  (= (length (list a b c d)) (length (set->list(list->set (list a b c d))))))



(define rows
  (for/list ([i dim])
    (filter (λ (cell) (= (quotient cell dim) i)) cells)))

(define cols
  (for/list ([i dim])
    (filter (λ (cell) (= (remainder cell dim) i)) cells)))

;; TODO: define grids

(define row-uniqueness-constraints
  (for/list ([i dim])
    (constraint (list-ref rows i) all-unique?)
  ))

(define col-uniqueness-constraints
  (for/list ([i dim])
    (constraint (list-ref cols i) all-unique?)
    ))

;; TODO: define grid constraints and add to constraints list

(define constraints
  (append
   row-uniqueness-constraints
   col-uniqueness-constraints
   (list (constraint cells board-spec))
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

;(current-inference forward-check) ;; Default is true

;; Selects next variable for assignment by choosing the one with the fewest values in its domain (aka minimum remaining values or mrv; see also minimum-remaining-values) and largest number of constraints (aka degree; see also max-degree). The idea is that this variable is likely to fail more quickly than others, so we’d rather trigger that failure as soon as we can (in which case we know we need to explore a different part of the state space).
(current-select-variable mrv-degree-hybrid)

;; Procedure that orders the remaining values in a domain. Default is #false, which means that the domain values are tried in their original order. If bad values are likely to be clustered together, it can be worth trying shuffle for this parameter, which randomizes which value gets chosen next. Shuffling is also helpful in CSPs where all the variable values must be different (because otherwise, the values for every variable are tried in the same order, which means that the search space is front-loaded with failure).
(current-order-values shuffle)

;; Helpful for which CSPs? Node consistency means that for any one-arity (aka unary) constraints on a variable, we can filter out any domain values that don’t satisfy the constraint, thereby reducing the size of the search space. So if the CSP starts with unary constraints, and the constraints foreclose certain values, node consistency can be useful. The cost of node consistency is proportional to the number of values in the domain (because all of them have to be tested).
;;Node consistency tends to be especially helpful in CSPs where all the assignment values have to be different, and even more so where the variables all have the same domain (say, 100 variables, each with a value between 0 and 99 inclusive). In a case like this, any assignment to one variable means that value can no longer be used by any other variable. Node consistency will remove these values from the other variable domains, thereby pruning the search space aggressively.
(current-node-consistency #t)

;;Whether constraints are reduced in arity where possible. This usually helps, so the default is #true.
;;Why does it help? Because lower-arity constraints tend to be faster to test, and the solver can use node consistency on one-arity constraints (see current-node-consistency).
;;For instance, suppose we have variables representing positive integers a and b and the constraint says (< a b). Further suppose that b is assigned value 5. At that point, this constraint can be expressed instead as the one-arity function (< a 5). This implies that there are only four possible values for a (namely, '(1 2 3 4))). If node consistency is active, the domain of a can immediately be checked to see if it includes any of those values. But none of this is possible if we don’t reduce the arity.
; (current-arity-reduction #t) ;; Default is true



;; NOTE: default solution method is back-tracking
(define sudoku
 (make-csp vars constraints))

;(print vars)
;(print "\n")
;(print constraints)


(define soln (solve sudoku))
(print soln)

