(defparameter fileList '()) ;i copy file into this list
(defparameter output '());list that will print on the screen
(defparameter op "operator")
(defparameter key "keyword")
(defparameter ident "identifier")
(defparameter *name* '());holds identier name
(defparameter *flag* 0) ;determines number negatif or not, 0 means non-negative, 1 means negative

(defun fill-list (); read and copy file into a list
	(with-open-file (s "myprogram.coffee")
  	(loop for c = (read-char s nil)
       	if (not (null c))
        	do  (setq fileList (append fileList (list c)))
        else do(return))))

(defun list-to-string (li); converts list to string
    (format nil "~{~A~}" li))

(defun digit-count(li); counts how many digit a number have
	(cond 
	( (null li) 
		0)
	( (not (digit-char-p (car li)))
		0)
	(t	
		(+ 1 (digit-count (cdr li))))))

(defun number-skip(li); skips through amount of number of digits
	(cond 
		( (null li) 
			nil)
	( (not (digit-char-p (car li)))
		li)
	(t	
		(number-skip (cdr li)))))

(defun ident-skip(li); skips through amount of number of characters that identifier have
	(cond 
		( (null li) 
			nil)
	( (not (alpha-char-p (car li)))
		li)
	(t	
		(ident-skip (cdr li)))))

(defun ident-name(li); determines name of the identifier
	(cond 
		( (null li) 
			nil)
	( (not (alpha-char-p (car li)))
		*name*)
	(t	
		(progn
		(setq *name* (append (list (car li)) *name*))
		(ident-name (cdr li))))))

(defun lexer(li);lexer function
	(cond 
		( (null li)
			nil )
		
		( (char= #\( (car li));"(" operator
			(progn 
				(setq token_pair '())
				(setq token_pair (cons "(" token_pair))
				(setq token_pair (cons op token_pair))
				(setq output (cons token_pair output))
				(lexer (cdr li))) )

		( (char= #\+ (car li));"+" operator
			(progn 
				(setq token_pair '())
				(setq token_pair (cons "+" token_pair))
				(setq token_pair (cons op token_pair))
				(setq output (cons token_pair output))
				(lexer (cdr li))) )

		( (char= #\- (car li));"-" operator
			(if (not (digit-char-p (cadr li))); if - not followed by a digit
					(progn 
						(setq token_pair '())
						(setq token_pair (cons "-" token_pair))
						(setq token_pair (cons op token_pair))
						(setq output (cons token_pair output))
						(lexer (cdr li)))
			(progn
				(setq *flag* 1)
				(lexer (cdr li)))))
	 			

		( (and (eq #\* (car li)) (eq #\space (cadr li)));"*" operator
			(progn 
				(setq token_pair '())
				(setq token_pair (cons "*" token_pair))
				(setq token_pair (cons op token_pair))
				(setq output (cons token_pair output))
				(lexer (cdr li))) )

		( (char= #\/ (car li));"/" operator
			(progn 
				(setq token_pair '())
				(setq token_pair (cons "/" token_pair))
				(setq token_pair (cons op token_pair))
				(setq output (cons token_pair output))
				(lexer (cdr li))) )

		( (char= #\) (car li));")" operator
			(progn 
				(setq token_pair '())
				(setq token_pair (cons ")" token_pair))
				(setq token_pair (cons op token_pair))
				(setq output (cons token_pair output))
				(lexer (cdr li))) )

		( (char= #\* (car li));"**" operator
			(if (and (eq #\* (cadr li)) (eq #\space (caddr li)))
				(progn 
					(setq token_pair '())
					(setq token_pair (cons "**" token_pair))
					(setq token_pair (cons op token_pair))
					(setq output (cons token_pair output))
					(lexer (cddr li))) ))
		
		( (and (eq #\d (nth 0 li)) (eq #\e (nth 1 li)) (eq #\f (nth 2 li)) (eq #\f (nth 3 li)) 
		  (eq #\u (nth 4 li)) (eq #\n (nth 5 li)) (eq #\space (nth 6 li)));deffun keyword 
		    (progn
		    	(setq token_pair '())
		    	(setq token_pair (cons "deffun" token_pair))
				(setq token_pair (cons key token_pair))
				(setq output (cons token_pair output))
				(lexer (cdr (cdr (cddddr li))))) )
 		
 		( (and (eq #\i (nth 0 li)) (eq #\f (nth 1 li)) (eq #\space (nth 2 li)));if keyword 
 		  (progn
		    	(setq token_pair '())
		    	(setq token_pair (cons "if" token_pair))
				(setq token_pair (cons key token_pair))
				(setq output (cons token_pair output))
				(lexer (cddr li))) )
 		
 		( (and (eq #\e (nth 0 li)) (eq #\q (nth 1 li)) (eq #\u (nth 2 li)) (eq #\a (nth 3 li));equal keyword 
		  (eq #\l (nth 4 li)) (eq #\space (nth 5 li)))
		    (progn
		    	(setq token_pair '())
		    	(setq token_pair (cons "equal" token_pair))
				(setq token_pair (cons key token_pair))
				(setq output (cons token_pair output))
				(lexer (cdr (cddddr li)))) )

 		( (and (eq #\a (nth 0 li)) (eq #\n (nth 1 li)) (eq #\d (nth 2 li)) (eq #\space (nth 3 li)));and keyword
 			(progn
		    	(setq token_pair '())
		    	(setq token_pair (cons "and" token_pair))
				(setq token_pair (cons key token_pair))
				(setq output (cons token_pair output))
				(lexer (cdddr li))) )
		( (and (eq #\o (nth 0 li)) (eq #\r (nth 1 li)) (eq #\space (nth 2 li)));or keyword
 			(progn
		    	(setq token_pair '())
		    	(setq token_pair (cons "or" token_pair))
				(setq token_pair (cons key token_pair))
				(setq output (cons token_pair output))
				(lexer (cddr li))) )
		( (and (eq #\s (nth 0 li)) (eq #\e (nth 1 li)) (eq #\t (nth 2 li)) (eq #\space (nth 3 li)));set keyword
 			(progn
		    	(setq token_pair '())
		    	(setq token_pair (cons "set" token_pair))
				(setq token_pair (cons key token_pair))
				(setq output (cons token_pair output))
				(lexer (cdddr li))) )
		( (and (eq #\f (nth 0 li)) (eq #\o (nth 1 li)) (eq #\r (nth 2 li)) (eq #\space (nth 3 li)));for keyword
 			(progn
		    	(setq token_pair '())
		    	(setq token_pair (cons "for" token_pair))
				(setq token_pair (cons key token_pair))
				(setq output (cons token_pair output))
				(lexer (cdddr li))) )
 		
 		( (and (eq #\n (nth 0 li)) (eq #\o (nth 1 li)) (eq #\t (nth 2 li)) (eq #\space (nth 3 li)));not keyword
 			(progn
		    	(setq token_pair '())
		    	(setq token_pair (cons "and" token_pair))
				(setq token_pair (cons key token_pair))
				(setq output (cons token_pair output))
				(lexer (cdddr li))) )

 		( (and (eq #\a (nth 0 li)) (eq #\p (nth 1 li)) (eq #\p (nth 2 li)) (eq #\e (nth 3 li)) 
		  (eq #\n (nth 4 li)) (eq #\d (nth 5 li)) (eq #\space (nth 6 li)));append keyword
		    (progn
		    	(setq token_pair '())
		    	(setq token_pair (cons "append" token_pair))
				(setq token_pair (cons key token_pair))
				(setq output (cons token_pair output))
				(lexer (cdr (cdr (cddddr li))))) )

 		( (and (eq #\c (nth 0 li)) (eq #\o (nth 1 li)) (eq #\n (nth 2 li)) (eq #\c (nth 3 li)) 
		  (eq #\a (nth 4 li)) (eq #\t (nth 5 li)) (eq #\space (nth 6 li)));concat keyword
		    (progn
		    	(setq token_pair '())
		    	(setq token_pair (cons "concat" token_pair))
				(setq token_pair (cons key token_pair))
				(setq output (cons token_pair output))
				(lexer (cdr (cdr (cddddr li))))) )

 		( (and (eq #\w (nth 0 li)) (eq #\h (nth 1 li)) (eq #\i (nth 2 li)) (eq #\l (nth 3 li))
		  (eq #\e (nth 4 li)) (eq #\space (nth 5 li)));while keyword 
		    (progn
		    	(setq token_pair '())
		    	(setq token_pair (cons "while" token_pair))
				(setq token_pair (cons key token_pair))
				(setq output (cons token_pair output))
				(lexer (cdr (cddddr li)))) )

 		( (and (eq #\e (nth 0 li)) (eq #\x (nth 1 li)) (eq #\i (nth 2 li)) (eq #\t (nth 3 li)) 
		  (eq #\space (nth 4 li)));exit keyword
		    (progn
		    	(setq token_pair '())
		    	(setq token_pair (cons "exit" token_pair))
				(setq token_pair (cons key token_pair))
				(setq output (cons token_pair output))
				(lexer (cddddr li))) )

 		( (and (eq #\t (nth 0 li)) (eq #\r (nth 1 li)) (eq #\u (nth 2 li)) (eq #\e (nth 3 li)) 
		  (or (eq #\space (nth 4 li)) (eq #\newline (nth 4 li)) (eq #\tab (nth 4 li)) (eq nil (nth 4 li))));true boolean
		    (progn
		    	(setq token_pair '())
		    	(setq token_pair (cons "true" token_pair))
				(setq token_pair (cons key token_pair))
				(setq output (cons token_pair output))
				(lexer (cddddr li))) )
 		( (and (eq #\f (nth 0 li)) (eq #\a (nth 1 li)) (eq #\l (nth 2 li)) (eq #\s (nth 3 li)) 
		  (eq #\e (nth 4 li)) (or (eq #\space (nth 5 li)) (eq #\newline (nth 5 li)) (eq #\tab (nth 5 li)) (eq nil (nth 5 li))));false boolean
		    (progn
		    	(setq token_pair '())
		    	(setq token_pair (cons "false" token_pair))
				(setq token_pair (cons key token_pair))
				(setq output (cons token_pair output))
				(lexer (cdr (cddddr li)))) )
 		
 		( (digit-char-p (car li));detects numbers
 			(if (not (and (eq #\0 (car li)) (> (digit-count li) 1)))
	 			(progn
	 				(setq num 0)
	 				(setq v (digit-count li))
	 				
	 				(loop for i from 0 to (- v 1)
	 					do (setq num (+ num (* (expt 10 (- v i 1)) (- (char-code (nth i li)) 48))))) 
	 				
	 				(if (eq 1 *flag*)
	 					(setq num (* -1 num)))
	 				
	 				(setq *flag* 0)
	 				
	 				(setq token_pair '())
			    	(setq token_pair (cons (write-to-string num) token_pair))
					(setq token_pair (cons "integer" token_pair))
					(setq output (cons token_pair output))
					(setq li (number-skip li))
					(lexer li))
	 		(progn
	 			(write "Error a number can't start with zero according to g++.pdf, i ignored it")
	 			(terpri)
	 			(setq li (number-skip li))
	 			(lexer li))) )
		
		(t	
			(if (not (or (eq #\space (car li)) (eq #\newline (car li)) (eq #\tab (car li))))
				(progn
					(ident-name li)
			    	(setq token_pair '())
			    	(setq token_pair (cons (list-to-string (reverse *name*)) token_pair))
					(setq token_pair (cons ident token_pair))
					(setq output (cons token_pair output))
					(setq li (ident-skip li))
					(setq *name* '())
					(lexer li)) 
			(lexer (cdr li))))))


(defun main()
	(fill-list)
	(lexer fileList)
	(format t "~s~%" (reverse output)))

(main)