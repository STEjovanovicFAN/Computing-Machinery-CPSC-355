define (x_r, %l1)		!x_r is x in  resigter l1
define (minimum_r, %l0)		!m_r is minimum in resiter l0
define (y_r, %l6)		!y_r is in register l6

fmt:	.asciz "X: %d y: %d minimum: %d\n"
	.align 4
	.global main

main:	save %sp, -96, %sp 
	mov 100, minimum_r 	!minimum = 100
	mov -6, x_r		!make x = -6
	
test:	cmp x_r, 7		!compare x(-6) to 7
	bge done		!as long as x < 7
	mov 1, %g1
	
	mov x_r, %o0		!5*x^3
	call .mul		!x*x
	mov x_r, %o1
	call .mul		!(x*x)*x
	mov x_r, %o1
	call .mul		!((x*x)*x)*5
	mov 5, %o1
	mov %o0, %l2		!move result to %l2
	
	mov x_r, %o0		!27*x^2
	call .mul		!x*x
	mov x_r, %o1
	call .mul 		!(x*x)*27
	mov 27, %o1
	mov %o0, %l3		!move result to %l3

	mov 27, %o0		!27*x		
	call .mul		!27*x
	mov x_r, %o1
	mov %o0, %l4		!move result to %l4

	mov 43, %l5		!move final numeral to %l5
	
	add %l2, %l3, %l6	!5*x^3 + 27*x^2
	sub %l6, %l4, %l7	!(5*x^3 + 27*x^2) - 27*x
	sub %l7, %l5, y_r	!((5*x^3 + 27*x^2) - 27*x) -43

	cmp y_r, %l0
	bge pass
	nop			!cant erase nop need above things
	mov y_r, minimum_r
	
pass:	
	set fmt, %o0
	mov x_r, %o1
	mov y_r, %o2

	call printf
	mov minimum_r, %o3	 		

	ba test
	inc %x_r		!x++ and go back to top of loop

done:	ta 0	
