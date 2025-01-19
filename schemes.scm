;;;
;;; Troyisms for Scheme, Lisp, Elisp.
;;;

;; Updates January 2025: I've been working in C for a long time but I
;; am turning back to Scheme. There are two Scheme based texts I want
;; to work through, _Simply_Scheme:_Introducing_Computer_Science_ and
;; the venerable _Structure_and_Interpretation_of_Computer_Programs_
;; (SICP).
;;
;; Both books have their own layer over Scheme, and thus neither is
;; a Scheme textbook, but the focus is on thinking differently.
;;
;; Current plan is to finish _Simply_Scheme_ (SS) then go back to
;; finish _Essential_Lisp_ (EL) before moving to SICP. SS bills itself
;; as an introduction to SICP for the less mathematically inclined. It
;; avoids mutation and focuses on functional programming.
;;
;; I'm reviewing and updating these notes based on my current
;; understanding of things Scheme.


;; There are likely better ways to do some of these things, but I
;; haven't learned them yet. I'm just enjoying programming again.
;;
;; Sections:
;;
;; * Parenthetically
;; * Looping Constructs or Special Forms
;; * Let Forms and Nested Definitions
;; * Nil Punning
;; * Which revision of Scheme to use?
;; * Variable Arguments.
;; * Last Item in a List
;; * Atomic Listlessness
;; * Missing Relational Operators
;; * Time Time Time Look What's Become of Me
;; * Simple Formatting of Strings
;; * Destructive Functions or Shoot Your Foot Off
;; * List splices? Slices?
;; * Property Lists


;;;
;;; Parenthetically
;;;

;; The plethora of parenthesis has actually not been the problem that
;; some fear. If you let your editor format your code, you can usually
;; ignore the parens as you read. When I first ran into forced formats
;; with gofmt I was resistant. I have other ideas about how to format
;; code, but I've learned to accept it as a good thing. Expend skull
;; sweat on something that matters.
;;
;; Using a parenthesis aware editor and mode, such as emacs with
;; either paredit or lispy, is helpful. The transition to thinking of
;; your code in terms of sexps and not characters or tokens took a
;; while, and early on I found myself in cursing matches with paredit.
;;
;; After working without paredit for a while I began to see the common
;; mistakes/typos I was making and saw how paredit or lispy might
;; help, but I haven't been able to stick with either. Old fingers and
;; old habits. I will try them from time to time and maybe one time
;; I'll keep one.
;;
;; The reason to prefer lispy over paredit is that it provides single
;; character almost vi like keystrokes for some common commands. I've
;; nothing against key chording, but my fingers know basic vi
;; navigation and so this comes naturally.
;;
;; abo-abo on github provides documentation and tutorial videos for
;; his lispy. NOTE: abo-abo seems to have gone into semi-retirement
;; since children came into his life. But there are others on GitHub
;; who work on his projects. It is also common for Emacs packages to
;; reach a stable state and then go years without updates.


;;;
;;; Looping Constructs or Special Forms
;;;

;; Scheme prefers recursion to the special forms supporting loops in
;; Lisp. Two are provided by Scheme: `while' and `do'. I have a mental
;; block regarding the `do' form in Scheme and will almost always use
;; some other way to build a loop.
;;
;; (while (cond)
;;   body)
;;
;; (do ((var1 init1 incr1) (...))
;;     ((exit test) optional result expression)
;;     body for side effects only, you can not
;;     persist changes to the variables defined
;;     above)
;;
;; Both forms support (break) and (continue) which do what you expect.


;;;
;;; Let Forms and Nested Definitions
;;;

;; All the cool kids use `let'/`let*'/`letrec*' and so on. Me, I'm an
;; old retired assembler programmer from the mainframe world. I'm only
;; cool when my big iron is water cooled.
;;
;; I still use `let'/`let*' and family when appropriate, but my early
;; Pascal days have me falling back into creating local functions and
;; variables using nested `define's.
;;
;; Lexical scope is your friend. Use it.
;;
;; This simplifies parameter passing, reduces name space pollution,
;; and postpones structuring decisions that I feel have to be made up
;; front with the `let' family of forms.
;;
;; I usually refactor to `let'ish code once I feel things are nearing
;; their final form.


;;;
;;; Nil Punning
;;;
;;; or
;;;
;;; What do you get the man who needs nothing?
;;;

;; Scheme doesn't pun around with `nil' the way Common Lisp does. This
;; was a source of some frustration while working through the old Lisp
;; text _Essential_Lisp_. I like the punning, but I also understand
;; why Scheme doesn't use it.
;;
;; One apparent idiom in Lisp is returning nil from a function. I
;; don't usually care what a function returns if the function'
;; return value is not meant to be used (IE, it's a procedure and
;; not a function) but when testing in the repl Guile at least is
;; noisy and distracting in printing the return value.
;;
;; If the return value is #<unspecified> then Guile says nothing.
;;
;; This shuts Guile up. Since nothing is specified, we get the
;; #<unspecified> value. The defined name could be nil, but in the
;; spirit of not punning:

(define nothing)


;;;
;;; Which revision of Scheme to use?
;;;

;; Neither Guile nor Chez will allow me to load the support files for
;; SS, and I assume they'll have problems with SICP when I get there.
;; Both books are from the R5RS erra of Scheme while both Guile and
;; Chez are R6RS or R7 small. It originally didn't occur to me that
;; this would matter, but it does. The SS code redefines some
;; primitives and Guile behaves badly when I try it while Chez flat
;; out refuses to allow it.
;;
;; I don't know I'll need or want things like `nothing' back in the R5
;; world, or if I'll even want it as my Scheme becomes more idiomatic.


;;;
;;; Variable Arguments.
;;;

;; Both Lisp and Scheme have wonderful syntax and support for variable
;; number of arguments to functions. I came up with the code below
;; while experimenting and decided to keep it here as a reminder of
;; how some of these things work.
;;
;; Functions such as min or max in Scheme already do this, but but for
;; illustration:

(define (applicator f xs)
  (cond ((null? xs) #f)
        ((not (list? xs)) xs)
        ((and (= 1 (length xs)) (list? (car xs))) (apply f (car xs)))
        (else apply f xs)))
(define (min-of . xs) (applicator min xs))
(define (max-of . xs) (applicator max xs))
(define (sum-of . xs) (applicator + xs))


;;;
;;; Last Item in a List
;;;

;; (last) is part of srfi-1, which you would think is automatically
;; imported but it isn't in Guile. It is in Chicken. Chez appears to
;; not include srfi implementations and I haven't needed to download
;; the libraries.
;;
;; If you need a last in a hurry ...
;;
;; Scheme doesn't have a last function, at least not under that name.
;; While my eyes are open for a better implementation or the "real"
;; Scheme function for this, the following helpers suffice.
;;
;; They are unguarded. You pass something that isn't a list, you get
;; what you deserve.
;;
;; I got the impression that reverse is not considered an expensive
;; operation from several items I saw on Stack Overflow.

(define (last xs)
  "Naive implementation of CL's LAST to get a list containing the
final item (final cdr if you will) of XS."
  (list (car (reverse alist))))
(define (last-item x)
  "Return the last element of list X."
  (car (reverse x)))


;;;
;;; Atomic Listlessness
;;;

;; Scheme doesn't define an atom? predicate. I'm not sure if this is
;; completely correct, but it's quick and easy.

(define (atom? x)
  "Semantics unclear as yet, but atoms aren't lists so."
  (not (list? x)))


;;;
;;; Missing Relational Operators
;;;

;; Lisp has predicates for comparing symbols by their "names" such as
;; alphalesserp. I don't like that name, even if I replace the "p"
;; with "?" the way it should be.
;;
;; Note that these are case sensitive. I think that's appropriate
;; for the likely usage, but it's easy enough to change if not.

(define (symbol< x y) (string< (symbol->string x) (symbol->string y)))
(define (symbol= x y) (string= (symbol->string x) (symbol->string y)))
(define (symbol> x y) (string> (symbol->string x) (symbol->string y)))


;;;
;;; Time Time Time Look What's Become of Me
;;;

;; There is profiling support in at least Guile and probably all
;; the other Schemes. For quick comparisons without needing to
;; mess with too many libraries or configuration options, this
;; gets the job done.
;;
;; The time is a dotted pair (seconds since 1970 . microseconds).
;;
;; The operation should be quoted to allow deferred evaluation.
;; Example: (duration '(permut '(a b c))).

(define (duration x)
  "Time the duration of sexp X using time of day.
You need to quote X."
  (let ((start '(0 . 0)) (stop '(0 . 0)) (capture '()))
    (set! start (gettimeofday))
    (set! capture (eval x (interaction-environment)))
    (set! stop (gettimeofday))
    (display capture)(newline)
    (display "start at: ")(display start)(newline)
    (display " stop at: ")(display stop)(newline)
    ;; todo, calculate difference
    ))


;;;
;;; Simple Formatting of Strings
;;;

;; A quick reference to format:
;;
;; (format port format-string varargs)
;;
;; Where port is an output port, if #f then the result is returned as
;; a string object.
;;
;; format-string is a normal string that may contain text replacements:
;;     ~a insert the text of arg as if printed by display
;;     ~s                                         write
;;     ~% insert newline
;;     ~~ insert tilde


;;;
;;; Destructive Functions or Shoot Your Foot Off
;;;

;; Destructive functions are those that update a Lisp structure in
;; place.
;;
;; Most functions in Lisp and Scheme return new objects instead of
;; modifying the object they were passed. This is generally a good
;; thing but there are times for performance reasons that updating
;; something directly is appropriate.
;;
;; Lisp and Scheme have differing names for the three main functions
;; I have learned.
;;
;;    Lisp           Scheme              Notes
;;    ----           ------              -----
;;    nconc          append!             No Cons cells Created
;;    rplaca         set-car!            RePLAce CAr
;;    rplacd         set-cdr!            RePLAce CDr
;;
;; Above, car is of course the first cell of the list, while cdr is
;; the rest of the list. Replacing the cdr of a 15 item list with a
;; single atom will leave you with a 2 item list.
;;
;; Scheme also provides list-set! to update any cons cell in the a
;; list by its offset (0 = car, length-1 = final cdr). While the prior
;; set-car! and set-cdr! take values (that may be lists), the
;; list-set! function takes a cons cell.
;;
;; I'm not fond of either set of names, but the following allows me to
;; use more standard Lisp code easily:

(define nconc append!)
(define (rplaca xs v) (set-car! xs v))
(define (rplacd xs v) (set-cdr! xs v))

;; Note that Scheme provides list-set! list offset value where value
;; should be a pair (cons cell) to write over the currently existing
;; cell.


;;;
;;; List splices? Slices?
;;;

;; There are many cases where a list or an item in a list participates
;; in another list. If you append list b to list a, the tail of the
;; result is the original b, which can still be access as b. This is
;; one reason for the bias against updating in Lisp and Scheme.

;;;
;;; Property Lists
;;;

;; Properties are key-value pairs stored by Lisp or Scheme linked
;; to specific objects. Storage details are implementation defined.
;;
;; Property lists predate Common Lisp and were not consistently
;; implemented. Scheme still provides them mostly for backwards
;; compatability and ease of porting legacy Lisp code to Scheme.
;;
;; The Guile documents encourage the use of more modern ideas
;; like objects, but it's still worth understanding property
;; lists.
;;
;; From scheme.org it's clear that several Scheme implementations
;; support some form of property list but there are differing
;; implementations. Chez Scheme seems close to the Lisp used in
;; the text I'm learning from (dating back to 1987) but I'm using
;; Guile.
;;
;;    Lisp                Guile Scheme
;;    ----                ------------
;;    get                 symbol-property
;;    putprop             set-symbol-property!
;;    remprop             symbol-property-remove!
;;
;; There is no symbol-plist or other analog to get a list of all
;; the proper keys. Chez Scheme looks as if it might provide
;; better functionality here. Guile isn't allowing any obvious means
;; of reflection here.
;;
;; I learned about property lists from the text Essential Lisp. It
;; provides a couple of wrapper functions in an acknowledgement of
;; the lack of standardization of properties in Common Lisp.
;;
;; Here are some helper functions based on those suggested in
;; the text, modified for Guile Scheme. The functions are putprop,
;; get (and getprop if you prefer the symmetry), remprop,
;; and newatom.
;;
;; Support functions load-properties and dump-properties can be
;; used to populate properties on atoms.

(define (putprop atom value property)
  "Assign a property to the ATOM (or symbol) with the key PROPERTY
and the specified VALUE.

This function is from chapter 11 of the text Essential Lisp,
modified for Guile Scheme 3.07."
  (set-symbol-property! atom property value))

(define (get atom property)
  "Get the value of the PROPERTY from the ATOM (or symbol). In
Common Lisp get is a built in.

This function is from chapter 11 of the text Essential Lisp,
modified for Guile Scheme 3.07."
  (symbol-property atom property))

(define (getprop atom property)
  "Another name for get."
  (get atom property))

(define (remprop atom property)
  "Remove a PROPERTY from an ATOM (symbol).

This function is in support of the API presented in chapter 11 of
the text Essential Lisp, modified for Guile Scheme 3.07."
  (symbol-property-remove! atom property))

(define (newatom stem)
  "Create a new atom (symbol) named by combining STEM with a system
generated value. In Guile Scheme, an odometer value. If the stem is
not a symbol or string, a generic stem of #{ g<number>}# is created.
The embedded space is deliberate.

This function is from chapter 11 of the text Essential Lisp,
modified for Guile Scheme 3.07."

  (cond ((string? stem) (gensym stem))
        ((symbol? stem) (gensym (symbol->string stem)))
        (else (gensym))))

(define (load-properties atom properties)
  "Set PROPERTIES on an ATOM (symbol). The PROPERTIES list should
hold a list of alternating keys and values.

Created for work on chapter 11 of Essential Lisp, and counts on the
API described there."
  (if (null? properties)
      atom
      (begin (putprop atom (cadr properties) (car properties))
             (load-properties atom (cdr (cdr properties))))))

(define (dump-properties atom properties)
  "Show any properties for ATOM that match the keys in list
PROPERTIES. A property value of '\nl means issue a newline after
displaying the property."
  (display atom)(display " ")
  (let ((xs properties))
    (while (not (null? xs))
      (cond ((equal? '\nl (car xs)) (newline))
            (else (display (car xs))(display ": ")
                  (display (get atom (car xs)))
                  (display " ")))
      (set! xs (cdr xs))))
  (display ""))

;; I don't know if these are needed with Chicken Scheme. So time
;; will tell.
