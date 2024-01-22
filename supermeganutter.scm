;   _________________
;  /                 \
;  | SuperMegaNutter |
;  \_________________/

; Version 'b7'
; Author: dusthillresident@gmail.com https://github.com/dusthillresident

; This is SuperMegaNutter, a pseudo random number generator.

; I tested it with practrand, with two test rig versions written in C that generate 32bit integers, one with the bits in normal order and one reversed. They both seemed to pass the full 32TB practrand test.

; It's built on the technique I invented, called "nutting".
; "Nutting" is to take the result of a multiplication fmod 1.0.
; The design uses two state variables, nn1 and nn2,
;  which increment and decrement steadily by some set values,
;  along with the product of the nutting operations,
;  and which eventually wrap around so that their values stay within a minimum and a maximum limit.
; The wrapping around is known as the "sideways nutting action".

; For more info, see https://www.bbcbasic.net/forum/viewtopic.php?t=1572

; I designed and implemented this generator to use only floating point multiplications, with the intention of making it more likely to work in several different implementations of Scheme, because not every implementation provides procedures for bitwise operations on integers (xor etc)
; I've tested this in:
;  Guile 3.0.5
;  elk 3.99.8-4.2build1 (ubuntu)
;  scm 5f2

; I made this after I read Dorai Sitaram's "teach yourself scheme in fixnum days", where they wrote: https://ds26gte.github.io/tyscheme/index-Z-H-7.html#TAG:__tex2page_sec_5.3
; > "Writing your own version of random in Scheme requires quite a bit of mathematical chops to get something acceptable. We won’t get into that here."

; -------------------------------------------------------------------------------

; Create a SuperMegaNutter generator instance
(define (create-generator)
 (define (fnf v) (- v (truncate v)))
 (let ((nn1 0.0) (nn2 0.0))
  ; SuperMegaNutter, version 'b7'.
  (define (SuperMegaNutter_b7)
   (set! nn1 (+ nn1 0.499743730631690299468026764666361))
   (if (> nn1 2147483647.0)
    (set! nn1 (fnf nn1)))
   (set! nn2 (- nn2 (+ 0.619712099029093592809216927916784 (* 0.01 (fnf nn1)))))
   (if (< nn2 0.0)
    (set! nn2 (+ nn2 2147483647.0)))
   (let ( (a (fnf (* nn1 (fnf (* nn1 0.70635556640556476940272083033647) ) (fnf (* nn1 0.96241840600902081782173280676402)))))
          (b (fnf (* nn2 (fnf (* nn2 0.41059769134948776074925592402104) ) (fnf (* nn2 0.83598420020319692166434447425947))))) )
    (set! nn1 (- nn1 (* 0.249871861 (fnf (+ a b)))))
    (fnf (+ (- (* a 2.79218049951371579168124556907984) a) b (fnf (* (fnf (+ nn1 nn2)) 1.1235804235832785923589346329))))))
  ; Argument handling wrapper for SuperMegaNutter.
  (lambda (. args)
   (if (null? args)
    (SuperMegaNutter_b7)
    (let ( (argument (car args))
           (rest (cdr args))     )
     ; Single number n as argument - request a number in the range from 0 to n not-inclusive, which can be an exact integer or a real.
     (cond 
      ((and (number? argument) (null? rest))
       (cond
        ; request a real within a specified range
        ((inexact? argument)
         (* (SuperMegaNutter_b7) argument))
        ; request an integer within a specified range
        ((exact? argument)
         (inexact->exact (truncate (* (SuperMegaNutter_b7) argument))))
        ; error if given some sort of number we don't know about
        (else (error "Unhandled number type"))))
      ; 'seed' - get/set the seed
      ((eq? argument 'seed)
       (if (null? rest)
        ; Call with no argument to obtain the current state
        (list nn1 nn2)
        ; Call with argument to set the state. argument must be a list of two numbers between 0.0 and 2147483647.0
        (let ((seed (car rest)))
         (if (and (= (length seed) 2) (number? (car seed)) (number? (cadr seed)))
          (begin
           (for-each
            (lambda (n)
             (if (or (< n 0.0) (> n 2147483647.0))
              (error "Invalid seed")))
            seed)
           (set! nn1 (car seed))
           (set! nn2 (cadr seed)))
          (error "Invalid argument, expecting a list of two numbers between 0.0 and 2147483647.0")))))
      ; 'proc' - get the SuperMegaNutter generator procedure for this instance, perhaps useful if it's desired to avoid the extra overhead of the argument handling wrapper.
      ((eq? argument 'proc)
       SuperMegaNutter_b7)
      ; Throw an error if given an invalid argument
      (else (error "Unhandled argument"))))))))

; ----------------------------------------------------------------------------------
; ---- Demonstrations of the features of this implementation of SuperMegaNutter ----
; ----------------------------------------------------------------------------------

; Demonstration of creating a SuperMegaNutter generator instance
(define rnd (create-generator))

; Demonstration of getting a random value between 0.0 and 1.0 (not inclusive)
(display "This number will be between 0.0 and 1.0 but not equal to 1.0")
(newline)
(display (rnd))
(newline)

; Demonstration of getting a random integer in range 0 to 100
(display "This number will be between 0 and 100: ")
(newline)
(display (rnd 100))
(newline)

; Demonstration of getting a random real number in range 0.0 to 100.0
(display "This number will be between 0.0 and 100.0: ")
(newline)
(display (rnd 100.0))
(newline)

; Demonstration of obtaining the state, and setting the state
(define saved-state (rnd 'seed))
(display "The same number will be printed twice:")
(newline)
(display (rnd))
(newline)
(rnd 'seed saved-state)
(display (rnd))
(newline)

; Demonstration of obtaining the SuperMegaNutter procedure, to call it directly in order to avoid the extra overhead of checking and processing arguments
(define smn (rnd 'proc))
(display "Calling SuperMegaNutter directly")
(newline)
(display (smn))
(newline)