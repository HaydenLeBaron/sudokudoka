;; solver.rkt


#lang racket


(require csp
         racket/set
         racket/list
         "example-sudokus.rkt"
         "helpers.rkt"
         "utils.rkt"
         )

(provide solve-puzzle)


#| Current solver algorithm used to solve the CSP. Choose between:
- backtracking-solver (default. Guarenteed to find soln eventually)
- min-conflicts-solver (more probabalistic) -- Seemed way slower in my experiemnts |#
(current-solver backtracking-solver)

#| Default: current-inference forward-check|#
(current-inference forward-check)

#|
Selects next variable for assignment by choosing the one with the fewest values in its domain (aka minimum remaining values or mrv; see also minimum-remaining-values) and largest number of constraints (aka degree; see also max-degree). The idea is that this variable is likely to fail more quickly than others, so we’d rather trigger that failure as soon as we can (in which case we know we need to explore a different part of the state space). |#
(current-select-variable mrv-degree-hybrid)

#| Procedure that orders the remaining values in a domain. Default is #false, which means that the domain values are tried in their original order. If bad values are likely to be clustered together, it can be worth trying shuffle for this parameter, which randomizes which value gets chosen next. Shuffling is also helpful in CSPs where all the variable values must be different (because otherwise, the values for every variable are tried in the same order, which means that the search space is front-loaded with failure). |#
(current-order-values shuffle)

#| Helpful for which CSPs? Node consistency means that for any one-arity (aka unary) constraints on a variable, we can filter out any domain values that don’t satisfy the constraint, thereby reducing the size of the search space. So if the CSP starts with unary constraints, and the constraints foreclose certain values, node consistency can be useful. The cost of node consistency is proportional to the number of values in the domain (because all of them have to be tested).
;;Node consistency tends to be especially helpful in CSPs where all the assignment values have to be different, and even more so where the variables all have the same domain (say, 100 variables, each with a value between 0 and 99 inclusive). In a case like this, any assignment to one variable means that value can no longer be used by any other variable. Node consistency will remove these values from the other variable domains, thereby pruning the search space aggressively. |#
(current-node-consistency #t)


#| Whether constraints are reduced in arity where possible. This usually helps, so the default is #true.
Why does it help? Because lower-arity constraints tend to be faster to test, and the solver can use node consistency on one-arity constraints (see current-node-consistency).
For instance, suppose we have variables representing positive integers a and b and the constraint says (< a b). Further suppose that b is assigned value 5. At that point, this constraint can be expressed instead as the one-arity function (< a 5). This implies that there are only four possible values for a (namely, '(1 2 3 4))). If node consistency is active, the domain of a can immediately be checked to see if it includes any of those values. But none of this is possible if we don’t reduce the arity. |#
(current-arity-reduction #t)



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

  (raw-soln->soln (solve (make-csp vars constraints)))
  )



;; RUN
(print-soln (solve-puzzle easy-4x4-puzzle) (get-dim easy-4x4-puzzle))

