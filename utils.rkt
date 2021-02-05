;; utils.rkt

#lang racket

(provide print-soln)

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

