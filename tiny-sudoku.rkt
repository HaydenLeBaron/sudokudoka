;; Sudoku solver


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






(define (all-unique? . xs)
  (= (length xs) (length (set->list(list->set xs)))))


(define cells (range 16))
(define dim (sqrt (length cells)))
(define vals (range 1 (+ dim 1)))


;; PUT THE SPEC FOR A PUZZLE IN HERE. CELL LEVEL CONSTRAINTS GO HERE.

;; blank cells are marked with 0s
(define puzzle
  (list 1 0 0 0
        0 0 0 4
        0 0 2 0
        0 3 0 0)
  )

(define rows
  (for/list ([i dim])
    (filter (λ (cell) (= (quotient cell dim) i)) cells)))

(define cols
  (for/list ([i dim])
    (filter (λ (cell) (= (remainder cell dim) i)) cells)))

(define (grids dim)
  (case dim
      [(4) (list '(0 1 4 5) '(2 3 6 7)
                      '(8 9 12 13) '(10 11 14 15))]
    [(9) (list '(0 1 2 9 10 11 18 19 20) '(3 4 5 12 13 14 21 22 23) '(6 7 8 15 16 17 24 25 26)
           '(27 28 29 36 37 38 45 46 47) '(31 32 39 40 41 48 49 50) '(33 34 35 42 43 44 51 52 53)
           '(54 55 56 63 64 65 72 73 74) '(57 58 59 66 67 68 75 76 77) '(60 61 62 69 70 71 78 79 80))]
      [else (raise-argument-error 'grids "4 or 9" dim "Invalid dim to function grids")])
  )



(define cell-constraints
  (for/list ([i cells]
             #:when (not (= (list-ref puzzle i) 0)))  ; blank cells are 0
    (constraint (list (list-ref cells i))
                (λ (x)
                  (= x (list-ref puzzle i))
                  ))))

(define row-uniqueness-constraints
  (for/list ([i dim])
    (constraint (list-ref rows i) all-unique?)
  ))

(define col-uniqueness-constraints
  (for/list ([i dim])
    (constraint (list-ref cols i) all-unique?)
    ))

(define grids-uniqueness-constraints
  (for/list ([i dim])
    (constraint (list-ref (grids dim) i) all-unique?)
    )
  )



(define constraints
  (append row-uniqueness-constraints
          col-uniqueness-constraints
          grids-uniqueness-constraints
          cell-constraints
          ))


(define vars
  (for/list ([i cells])
    (var i vals)))



;; =====================
;; UTILITIES
;; =====================

(define (print-soln raw-soln)
  (let ([soln
         (for/list ([i (length raw-soln)])
           (cdr (list-ref raw-soln i)))
         ])
    (for ([i dim])
      (for ([j dim])
        (printf "~a " (list-ref soln (+ (* i dim) j)))
        )
      (printf "\n")
    )))


(check-equal? (all-unique? 1 2 3 4) #t)
(check-equal? (all-unique? 1 1 2 3) #f)


;; =====================
;; SOLVE
;; =====================



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


(define raw-soln (solve sudoku))
(print-soln raw-soln)

