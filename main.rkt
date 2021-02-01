#lang racket/base

(require rackunit)

;; ---------------------------------------------
;; MAIN
;; ---------------------------------------------

;; Takes a sudoku board (list) and solves it.
(define (solve-sudoku sudoku idx)
  ; For each 0 cell in the list:
  ;   Plug in a random number from the set of numbers meeting the following constraints:
  ;    * The number is 1-9
  ;    * The number meets the row, col, and grid constraints
  ;   If no number in the set meets this requirement, backtrack

  ; Take the current sudoku and try to plug in constraint meeting num to idx.
  ; If

  (if (isempty valid-set)
      #f
      )

  )

;; ---------------------------------------------
;; HELPERS
;; ---------------------------------------------



;; Take
(define (check-set-constraint row)
  ...
  )



;; Takes a row (list). Returns true
;; if row constraint met. False otherwise.
;; TODO: implement
(define (check-row-constraint row)
  ...(check-set-constraint row)...
  )


;; Takes a column (list). Returns true
;; if column constraint met. False otherwise.
;; TODO: implement this in terms of the row-checking constraint function
(define (check-col-constraint col)
  ...(check-set-constraint (col)...
  )

;; Takes a grid (list). Returns true
;; if grid constraint met. False otherwise.
;; TODO: implement
(define (check-grid-constraint grid)

  ...
  )

;; ---------------------------------------------
;; TEST HELPERS
;; ---------------------------------------------

;; Example from https://en.wikipedia.org/wiki/Sudoku_solving_algorithms
(define ex1-sudoku
  (list
           5 3 0  0 7 0  0 0 0
           6 0 0  1 9 5  0 0 0
           0 9 8  0 0 0  0 6 0

           8 0 0  0 6 0  0 0 3
           4 0 0  8 0 3  0 0 1
           7 0 0  0 2 0  0 0 6

           0 6 0  0 0 0  2 8 0
           0 0 0  4 1 9  0 0 5
           0 0 0  0 8 0  0 7 9
           )
  )


(define good-row1
  (list (1 2 3  4 5 6  7 8 9)))
(define good-row2
  (list (1 4 7  2 5 8  3 6 9)))
(define bad-repeat-row1
  (list (1 2 3  4 5 5  7 8 9)))
(define bad-repeat-row2
  (list (1 2 3  4 5 6  9 8 9)))
(define bad-has0-row1
  (list (1 2 0  4 5 6  7 8 9)))
(define bad-has0-row2
  (list (1 2 3  4 0 6  7 8 9)))
(define bad-has0-row3
  (list (1 2 3  4 0 6  7 8 0)))


;; ---------------------------------------------
;; TESTS
;; ---------------------------------------------


;; check-row-constraint
;; --------------------
(check-equal? (check-row-constraint good-row1) #t)
(check-equal? (check-row-constraint good-row2) #t)
(check-equal? (check-row-constraint bad-repeat-row1) #f)
(check-equal? (check-row-constraint bad-repeat-row2) #f)
(check-equal? (check-row-constraint bad-has0-row1) #f)
(check-equal? (check-row-constraint bad-has0-row2) #f)
(check-equal? (check-row-constraint bad-has0-row3) #f)

;; check-grid-constraint
;; --------------------
(check-equal? (check-grid-constraint good-grid1) #t)
(check-equal? (check-grid-constraint good-grid2) #t)
(check-equal? (check-grid-constraint bad-repeat-grid1) #f)
(check-equal? (check-grid-constraint bad-repeat-grid2) #f)
(check-equal? (check-grid-constraint bad-has0-grid1) #f)
(check-equal? (check-grid-constraint bad-has0-grid2) #f)
(check-equal? (check-grid-constraint bad-has0-grid3) #f)






