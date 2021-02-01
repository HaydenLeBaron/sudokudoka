#lang racket
(require csp)

(define (make-base-sudoku)
  (define sudoku (make-csp))

  (define cells (range 81))
  (add-vars! sudoku cells (range 1 10))

  (for ([i 9])
    (define row-cells (filter (λ (cell) (= (quotient cell 9) i)) cells))
    (add-all-diff-constraint! sudoku row-cells)

    (define col-cells (filter (λ (cell) (= (remainder cell 9) i)) cells))
    (add-all-diff-constraint! sudoku col-cells))

  (define box-starts '(0 3 6 27 30 33 54 57 60))
  (define box-offsets '(0 1 2 9 10 11 18 19 20))
  (for ([start box-starts])
    (add-all-diff-constraint! sudoku (map (curry + start) box-offsets)))

  sudoku)

(define (make-sudoku-board . strs)
  (define sudoku (make-base-sudoku))
  (define vals (for*/list ([str (in-list strs)]
                           [c (in-string str)]
                           #:unless (memv c '(#\- #\|)))
                 (string->number (string c))))
  (for ([(val vidx) (in-indexed vals)]
        #:when val)
    (add-constraint! sudoku (curry = val) (list vidx)))
  sudoku)

(current-inference forward-check)
(current-select-variable mrv-degree-hybrid)
(current-order-values shuffle)
(current-node-consistency #t)
(current-arity-reduction #t)

(solve (make-sudoku-board
        "  8|   | 45"
        "   | 8 |9  "
        "  2|4  |   "
        "-----------"
        "5  |  1|76 "
        " 1 | 7 | 8 "
        " 79|5  |  1"
        "-----------"
        "   |  7|4  "
        "  7| 6 |   "
                "65 |   |3  "))
