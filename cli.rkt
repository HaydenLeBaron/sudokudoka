#lang racket

(require "solver.rkt"
         "generator.rkt"
         "utils.rkt"
         )


(define (main)
 (begin
   (printf "-----------------------------------------------------\n")
   (printf "WELCOME to Sudokudoka: a sudoku solver & generator.\n")
   (printf "\nChoose an option below:\n")
   (printf "[0]\tSolve\n[1]\tGenerate\n")
   (let ([solve/gen-option (read-line (current-input-port) 'any)])
     (cond
       [(equal? solve/gen-option "0") ;; Solve
        (begin
          (printf "Choose an option below:\n")
          (printf "[4]\t4x4\n[5]\t5x5\n[6]\t6x6\n[9]\t9x9\n")
          (printf "Then type <dim> rows of <dim> space-separated numbers.\n")
          (let ([dim-option (string->number (read-line (current-input-port) 'any))])
            (let ([puzzle (get-puzzle-from-user dim-option)])
              (begin
                (printf "\n")
                (printf "SOLUTION:\n")
                (print-soln (solve-puzzle puzzle) dim-option)
                (printf "\n")))))]
       [(equal? solve/gen-option "1") ;; Generate
        (begin
          (printf "Choose an option below:\n")
          (printf "[4]\t4x4\n[5]\t5x5\n[6]\t6x6\n[9]\t9x9\n")
          (let ([dim-option (string->number (read-line (current-input-port) 'any))])
            (begin
              (printf "\n")
              (print-soln (generate-board dim-option) dim-option)
              (printf "\n"))
            ))]
       [else (printf "Invalid option")]))))


(main)
