;; utils.rkt

#lang racket

(provide print-soln)
(provide raw-soln->soln)
(provide get-puzzle-from-user)




(define (get-puzzle-from-user dim)
  (map string->number
       (append*
        (map string-split (for/list ([i dim])
                            (read-line (current-input-port) 'any))))))

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
