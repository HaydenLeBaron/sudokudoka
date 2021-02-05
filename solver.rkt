;; Sudoku solver



#lang racket
(require csp)
(require racket/set)
(require racket/list)
(require rackunit)

;; TODO CHOOSE WHICH PUZZLE TO SOLVE HERE






;; PUT THE SPEC FOR A PUZZLE IN HERE. CELL LEVEL CONSTRAINTS GO HERE.


;; Used to generate a sudoku puzzle
(define empty-4x4-puzzle
  (list 0 0 0 0
        0 0 0 0
        0 0 0 0
        0 0 0 0)
  )

(define empty-5x5-puzzle
  (list 0 0 0 0 0
        0 0 0 0 0
        0 0 0 0 0
        0 0 0 0 0
        0 0 0 0 0
        )
  )



(define easy-4x4-puzzle
  (list 1 0 0 0
        0 0 0 4
        0 0 2 0
        0 3 0 0)
  )

(define easy-5x5-puzzle
  (list 1 0 0 4 0
        4 0 1 0 3
        0 3 0 5 0
        5 0 0 0 4
        0 4 0 0 0
  ))
;; (define soln-to-5x5-puzzle
;;   (list 1 2 3 4 5
;;         4 5 1 2 3
;;         2 3 4 5 1
;;         5 1 2 3 4
;;         3 4 5 1 2
;;         ))

(define empty-6x6-puzzle ;; Can't be solved in a reasonable amount of time
  (list 0 0 0 0 0 0
        0 0 0 0 0 0
        0 0 0 0 0 0
        0 0 0 0 0 0
        0 0 0 0 0 0
        0 0 0 0 0 0
        ))

(define easy-6x6-puzzle ;; If I add one more 0, takes too long to solve
  (list 0 5 0 0 4 0
        4 0 6 0 0 0
        0 0 5 4 0 1
        6 0 4 0 5 0
        0 4 0 6 0 3
        3 0 1 5 0 0
        ))
;; (define soln-to-easy-6x6-puzzle
;;   (list 1 5 3 2 4 6
;;         4 2 6 1 3 5
;;         2 3 5 4 6 1
;;         6 1 4 3 5 2
;;         5 4 2 6 1 3
;;         3 6 1 5 2 4
;;         ))


;; Wikipedia sudoku
(define wikipedia-9x9-puzzle
  (list 5 3 0  0 7 0  0 0 0
        6 0 0  1 9 5  0 0 0
        0 9 8  0 0 0  0 6 0

        8 0 0  0 6 0  0 0 3
        4 0 0  8 0 3  0 0 1
        7 0 0  0 2 0  0 0 6

        0 6 0  0 0 0  2 8 0
        0 0 0  4 1 9  0 0 5
        0 0 0  0 8 0  0 7 9))

;; Too easy sudoku

;; BKMRK: make incrementally harder
;; RN my solver isn't performant enough
(define easy-9x9-puzzle ;; (takes ~13 sec)
  ;; 3 missing from each row
  (list 8 0 7  1 0 4  3 9 0
        9 6 0  3 0 7  0 4 8
        3 0 1  0 8 0  7 5 2

        5 9 0  4 6 8  0 0 1
        4 7 0  0 1 3  6 0 9
        6 1 8  9 0 0  4 0 5

        7 0 0  2 3 5  0 1 4
        1 5 0  7 0 6  0 2 3
        2 0 9  8 4 0  5 0 7))

(define med-9x9-puzzle ;; (takes ~X sec) ;; Waited 3+ mins and it still hadn't finished
  ;; 4 missing from each row
  (list 8 0 7  1 0 0  3 9 0
        0 6 0  3 0 7  0 4 8
        0 0 1  0 8 0  7 5 2

        5 9 0  0 6 8  0 0 1
        4 7 0  0 1 0  6 0 9
        6 1 8  9 0 0  0 0 5

        7 0 0  2 3 0  0 1 4
        1 5 0  7 0 0  0 2 3
        2 0 9  8 0 0  5 0 7))



(define soln-to-easy-9x9-puzzle
  (list 8 2 7  1 5 4  3 9 6
        9 6 5  3 2 7  1 4 8
        3 4 1  6 8 9  7 5 2

        5 9 3  4 6 8  2 7 1
        4 7 2  5 1 3  6 8 9
        6 1 8  9 7 2  4 3 5

        7 8 6  2 3 5  9 1 4
        1 5 4  7 9 6  8 2 3
        2 3 9  8 4 1  5 6 7))



;; Easy sudoku https://sudoku.com/easy/
(define hard-9x9-puzzle ;; TAKES WAY TOO LONG TO BE SOLVED
  (list 0 9 1  0 5 0  6 8 0
        0 0 0  6 8 7  0 0 5
        8 0 0  0 1 3  0 2 0

        4 0 0  0 0 2  0 0 0
        0 0 2  0 0 8  7 6 0
        0 8 6  4 0 0  1 0 0

        3 0 4  8 0 0  2 5 0
        1 5 8  0 0 0  3 4 0
        0 2 9  0 0 5  0 7 1))

(define empty-9x9-puzzle
  (list 0 0 0  0 0 0  0 0 0
        0 0 0  0 0 0  0 0 0
        0 0 0  0 0 0  0 0 0

        0 0 0  0 0 0  0 0 0
        0 0 0  0 0 0  0 0 0
        0 0 0  0 0 0  0 0 0

        0 0 0  0 0 0  0 0 0
        0 0 0  0 0 0  0 0 0
        0 0 0  0 0 0  0 0 0))


(define (get-cells puzzle) (range (length puzzle)))
(define (get-dim puzzle) (sqrt (length puzzle)))
(define (get-vals dim) (range 1 (+ dim 1)))



(define (get-rows cells)
  (for/list ([i (get-dim cells)])
    (filter (λ (cell) (= (quotient cell (get-dim cells))
                         i))
            cells)))

(define (get-cols cells)
  (for/list ([i (get-dim cells)])
    (filter (λ (cell) (= (remainder cell (get-dim cells))
                         i))
            cells)))


(define (get-grids puzzle)
  (case (get-dim puzzle)
      [(4) (list '(0 1 4 5) '(2 3 6 7)
                  '(8 9 12 13) '(10 11 14 15))]
    [(9) (list '(0 1 2 9 10 11 18 19 20) '(3 4 5 12 13 14 21 22 23) '(6 7 8 15 16 17 24 25 26)
           '(27 28 29 36 37 38 45 46 47) '(31 32 39 40 41 48 49 50) '(33 34 35 42 43 44 51 52 53)
           '(54 55 56 63 64 65 72 73 74) '(57 58 59 66 67 68 75 76 77) '(60 61 62 69 70 71 78 79 80))]
      ;[else (raise-argument-error 'grids "4 or 9" dim "Invalid dim to function grids")])
    [else (list)]))

(define (all-unique? . xs)
  (= (length xs) (length (set->list(list->set xs)))))


(define (cell-constraints puzzle)
  (for/list ([i (get-cells puzzle)]
             #:when (not (= (list-ref puzzle i) 0)))  ; blank cells are 0
    (constraint (list (list-ref (get-cells puzzle) i))
                (λ (x)
                  (= x (list-ref puzzle i))))))

(define (row-uniqueness-constraints puzzle)
  (for/list ([i (get-dim puzzle)])
    (constraint (list-ref (get-rows (get-cells puzzle)) i)
                all-unique?)))

(define (col-uniqueness-constraints puzzle)
  (for/list ([i (get-dim puzzle)])
    (constraint (list-ref (get-cols (get-cells puzzle)) i)
                all-unique?)))

(define (grids-uniqueness-constraints puzzle)
  (if (empty? (get-grids puzzle))
      '()
      (for/list ([i (get-dim puzzle)])
        (constraint (list-ref (get-grids puzzle) i)
                    all-unique?))))





;; =====================
;; UTILITIES
;; =====================

(define (print-soln raw-soln dim)

  (if (not (list? raw-soln))
      (printf "No solution")

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
  )


;(check-equal? (all-unique? 1 2 3 4) #t)
;(check-equal? (all-unique? 1 1 2 3) #f)


;; =====================
;; SOLVE
;; =====================


;; Current solver algorithm used to solve the CSP. Choose between:
;; - backtracking-solver (default. Guarenteed to find soln eventually)
;; - min-conflicts-solver (more probabalistic) -- Seemed way slower in my experiemnts
(current-solver backtracking-solver)



(current-inference forward-check) ;; Default is true

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
(current-arity-reduction #t) ;; Default is true




;; MAIN
 ;; (define (solve-puzzle)
 ;;  (print-soln
 ;;   (solve (make-csp vars constraints)))
 ;;  )


;; BKRMK TODO: IMPLEMENT
;; (define (generate-board dim)

;;   (cond
;;     [(= dim 4) (void )]
;;     [(= dim 5) (void )]
;;     [(= dim 6) (void )]
;;     [(= dim 9) (void )]
;;     )

;;   )



(define (solve-puzzle puzzle)
  (define constraints
    (append (row-uniqueness-constraints puzzle)
            (col-uniqueness-constraints puzzle)
            (grids-uniqueness-constraints puzzle)
            (cell-constraints puzzle)
            ))

  (define vars
    (for/list ([i (get-cells puzzle)])
      (var i (get-vals (get-dim (get-cells puzzle))))))


  (print-soln
   (solve (make-csp vars constraints))
   (get-dim puzzle)
   ))


;; RUN
(solve-puzzle easy-5x5-puzzle)
