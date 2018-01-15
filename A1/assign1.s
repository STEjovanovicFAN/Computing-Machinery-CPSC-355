	
	!version 1 not-optimized
fmt:	.asciz "X: %d y: %d minimum: %d\n"
	.align 4
	.global main

main:	save %sp, -96, %sp 
	mov 100, %l0 		!minimum = 100
	mov -6, %l1		!make x = -6
	
test:	cmp %l1, 7		!compare x(-6) to 7
	bge done		!as long as x < 7
	nop
	
	mov %l1, %o0		!5*x^3
	mov %l1, %o1
	call .mul		!x*x
	nop
	mov %l1, %o1
	call .mul		!(x*x)*x
	nop
	mov 5, %o1
	call .mul		!((x*x)*x)*5
	nop
	mov %o0, %l2		!move result to %l2
	
	mov %l1, %o0		!27*x^2
	mov %l1, %o1
	call .mul		!x*x
	nop
	mov 27, %o1
	call .mul 		!(x*x)*27
	nop
	mov %o0, %l3		!move result to %l3

	mov 27, %o0		!27*x
	mov %l1, %o1		
	call .mul		!27*x
	nop
	mov %o0, %l4		!move result to %l4

	mov 43, %l5		!move final numeral to %l5
	
	add %l2, %l3, %l6	!5*x^3 + 27*x^2
	sub %l6, %l4, %l7	!(5*x^3 + 27*x^2) - 27*x
	sub %l7, %l5, %l6	!((5*x^3 + 27*x^2) - 27*x) -43

	cmp %l6, %l0
	bge pass
	nop
	mov %l6, %l0
	
pass:	
	set fmt, %o0
	mov %l1, %o1
	mov %l6, %o2
	mov %l0, %o3

	call printf
	nop	 

	inc %l1			!x++
	ba test
	nop			!go to top of loop(check condition)

done:

	mov 1, %g1
	ta 0	
