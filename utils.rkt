;; utils.rkt

#lang racket

(provide print-soln)
(provide raw-soln->soln)



;; BKRMK: TODO: separate printing aspect from soln creation aspect of this function

(define (raw-soln->soln raw-soln)
  (for/list ([i (length raw-soln)])
    (cdr (list-ref raw-soln i))))


(define (print-soln soln dim)

  (if (not (list? soln))
      (printf "No solution")
        (for ([i dim])
          (for ([j dim])
            (printf "~a " (list-ref soln (+ (* i dim) j)))
            )
          (printf "\n")
          ))

  (printf "\n")
  )
