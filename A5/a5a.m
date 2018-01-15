!Stefan Jovanovic
!a5 part a
!CPSC 355

include(macro_defs.m)				!file in folder
	
	.section ".data"
ch_m:	.byte	0			
			
fmt:	.asciz  "%c"				!get values

print:	.asciz	"%c\n"				!print values

space:	.asciz	" "

plus:	.asciz 	"+"

minus:	.asciz 	"-"

times:	.asciz 	"*"
	
bracket: .asciz "("

	!begin_struct(char)
	!field(op_m, 1)
	!end_struct(char)

!local_var
!var(op_m, 1)

	.align 4
	.global find
find:	save	%sp,	-96,	%sp

	whileLoop:
		
		set 	fmt,	%o0		!what the user can enter
		set 	ch_m,	%o1		!the ch value is in %o1

		call	scanf			!get input from user
		nop

	testCondition:
		ldub	[%o1],	%l1		!load ch_m

		!set 	space,	%o5 		!space is ' '
		!ldub	[%o5],	%o5
		cmp	%l1,	' '		!compare space with ch
		be	whileLoop		!if ch is ' ' do while loop again 
		nop				
		
	end1:
	
	ret 	
	restore
	
	.align 4
	.global expression	
expression:	save	%sp, 	-96,	%sp

	call	term
	nop
	
	set	ch_m,	%l5
	set 	plus,	%l2
	set 	minus,	%l3

	!ldub	[%l2],	%l2			!get char of plus
	!ldub	[%l3],	%l3			!get char of minus	
	
	testCondition2:
		ldub 	[%l5],	%l6
		cmp	%l6,	'+'		!cmp ch_m with plus 
		be	whileLoop2
		nop

		cmp	%l6,	'-'		!cmp ch_m with minus
		be	whileLoop2
		nop
	
	 	ba	end2			!do not do loop if not plus or minus, just end
		nop		

	whileLoop2:
		stub	%l6,	[%fp+(-1)]	!set op_m = ch_m
		ldub	[%fp+(-1)],	%l4	!get value of op and put into register %o4
		
		call 	find
		nop

		call 	term 
		nop
	
		set	fmt,	%o0
		mov	%l4,	%o1		!load address of op_m
		call 	printf
		nop
		
		ba	testCondition2
		nop
	
	end2:
	
	ret
	restore 
	
	.align 4
	.global term
term:	save	%sp,	-96,	%sp
	
	call	factor
	nop

	whileLoopTest3:
		!set	times,	%l4		
		!ldub	[%l4],	%l4
		set	ch_m,	%l2	
		ldub	[%l2],	%l3		!get op_m value
		
		cmp	%l3,	'*'		!comapre ch_m with *
		bne	end3			!not equal? end.
		nop

	whileLoop3:
		call 	find
		nop

		call 	factor
		nop
	
		set 	fmt,	%o0		!set print
		mov 	%l4,	%o1		!mov value of * to %o1 to print
		call 	printf
		nop		

		ba	whileLoopTest3
		nop

	end3:


	ret 
	restore	

	.align 4
	.global factor
factor:	save	%sp,	-96,	%sp

	set	ch_m,	%l2
	!set 	bracket,	%l3

	!ld	[%l3],	%l3	
	ldub	[%l2],	%l4
	
	cmp	%l4,	'('			!cmp ch_m and (
	bne	else1
	nop

	if1:
		call	find
		nop

		call 	expression
		nop
		
		ba	end4
		nop
	else1:
		set	fmt,	%o0
		mov 	%l4,	%o1
		call 	printf
		nop

	end4:
		
		call 	find
		nop
	
		ret
		restore	


