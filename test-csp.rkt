#lang racket

(require csp)
(require math/number-theory)

; EXAMPLE OF THE STRUCTURE OF A CSP
 ;;---------------------------------
 ;; Define constraint-satisfaction problem

(define (valid-triple? x y z)
  (= (expt z 2) (+ (expt x 2) (expt y 2))))


 (define triples
   (let ([domain (range 1 2)])
     (make-csp
      (list (var 'a domain)
            (var 'b domain)
            (var 'c domain))
      (list (constraint (list 'a 'b 'c) valid-triple?)
            (constraint (list 'a 'b) <=)
            (constraint (list 'a 'b 'c) coprime?)))))

;; Find all solutions
 (solve* triples)


