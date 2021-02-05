;; example-sudokus.rkt


#lang racket

(provide empty-4x4-puzzle
         empty-5x5-puzzle
         easy-4x4-puzzle
         easy-5x5-puzzle
         empty-6x6-puzzle
         easy-6x6-puzzle
         wikipedia-9x9-puzzle
         easy-9x9-puzzle
         med-9x9-puzzle
         hard-9x9-puzzle
         empty-9x9-puzzle)



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



