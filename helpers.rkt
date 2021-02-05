;; helpers.rkt
#lang racket

(require csp
         racket/set
         racket/list)

(provide get-cells
         get-dim
         get-vals
         get-rows
         get-cols
         get-grids
         all-unique?
         cell-constraints
         row-uniqueness-constraints
         col-uniqueness-constraints
         grids-uniqueness-constraints
 )

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



