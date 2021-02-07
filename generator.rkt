;; generator.rkt
#lang racket

(require "solver.rkt"
         "example-sudokus.rkt"
         "utils.rkt"
         racket/set
         )

(provide generate-board)


(define (gen-rand-filled-boards empty-board num-attempts)
  (set->list (list->set (for/list ([i num-attempts]) (solve-puzzle empty-board)))))

(define (blank-out-cells percent-blank filled-board)
  (for/list ([el filled-board])
    (if (< (random 100) percent-blank)
        (* 0 el)
        el
        )))


(define (generate-board dim)

  (let ([choose-rand-elmnt
         (λ (l) (list-ref l (random (length l))))])
    (cond
      [(= dim 4)
       (blank-out-cells 70 (choose-rand-elmnt
                            (gen-rand-filled-boards empty-4x4-puzzle 21)))]
      [(= dim 5)
       (blank-out-cells 60 (choose-rand-elmnt
                            (gen-rand-filled-boards empty-5x5-puzzle 2)))]
      [(= dim 6)
       (blank-out-cells 50 (choose-rand-elmnt
                            (gen-rand-filled-boards empty-6x6-puzzle 2)))]
      [(= dim 9)
       (blank-out-cells 40 (choose-rand-elmnt
                            (gen-rand-filled-boards empty-9x9-puzzle 2)))])
    ))


;; RUN
;(print-soln (generate-board 4) 4)

