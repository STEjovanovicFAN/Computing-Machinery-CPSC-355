!Stefan Jovanovic
!UC ID:	10135783

.global main

fmt1:	.asciz "Product before: %x\n"		!format of product after	
	.align 4	

fmt2:	.asciz "Mulitiplier before: %x\n"	!format of mulitplier before
	.align 4

fmt3:	.asciz "Multiplicand before: %x\n"	!format of multiplicand before
	.align 4

fmt4:	.asciz "Product after: %x\n\n"		!format of product after 
	.align 4

fmt5:	.asciz "Mulitiplier after: %x\n"	!format of multiplier after 
	.align 4

fmt6:	.asciz "Mutiplicand after: %x\n"	!format of mutiplicand
	.align 4

	!%l0 is the multiplicand
	!%l1 is the mulitplier
	!%l2 is the negative check condition
	!%l3 is the product
	!%l4 is storage of random stuff
	!%l5 is the loop counter
	!%l6 is the loop condition
	!%l7	is storage of random stuff
	
	!code was getting messy, this ^ is a note to self 

main:	
	save	%sp,	-96,	%sp

set1:	
	set 	0x04ee67b7,	%l0	!multiplicand
	set 	0x072e8b8c,	%l1	!multiplier
	

	set 	fmt2,	%o0		!set fmt
	call 	printf			!print
	mov	%l1,	%o1		!move to print (print multiplier)

	set 	fmt3, 	%o0		!set fmt
	call 	printf			!print
	mov	%l0,	%o1		!move to print	(print multiplicand)

	srl	%l1,	31,	%l2	!shift right to last digit (multiplier) and store last digit into %l2 for checking if it is negative or not

	mov 	0,	%l3		!make product = 0
	mov 	0,	%l5		!make counter = 0

	set	fmt1,	%o0		!set fmt
	call 	printf
	mov 	%l3,	%o1		!move to print (print product)

	ba 	condition1			!for loop start
	mov 	32,	%l6		!make %l6 = 32	(delay slot)

startloop1:

	and	%l1,	1,	%l4	!get multiplier right most bit and set in %l4

	cmp 	%l4,	1		!check if right most bit of multiplier is 1
	bne	skip1			!goes to skip if 0, otherwise it adds product + multiplicand 
	nop
	add 	%l3,	%l0,	%l3	!add product + multipicand and store in product
	
skip1:
	and 	%l3, 	1, 	%l4	!get right most bit in product and store in %l4
	sll	%l4,	31,	%l7	!moves right most from product to left most bit	
	
	srl	%l1, 	1,	%l1	!multiplier shift right by 1
	or	%l7,	%l1,	%l1	!right most bit of product moves to leftmost bit of multiplier
	sra	%l3,	1,	%13	!product shift by 1 to the right
	
	inc	%l5			!increment loop counter

condition1:
	cmp	%l5,	%l6		!compare that i < 32
	bl	startloop1		!branches to the start of the loop if i < 32
	nop	

ifnegative1:
	cmp	%l2,	1		!compare if %l2 > 0
	bne	notneg1			!goes to notneg if it is not negative, otherwise
	nop
	sub	%l3,	%l0,	%l3	!otherwise product - multiplicand and store into product
	
notneg1:	

	set 	fmt5,	%o0
	call 	printf
	mov 	%l1,	%o1		!print after multiplier

	set 	fmt6,	%o0	
	call 	printf	
	mov	%l0,	%o1		!print after multiplicand
	
	set 	fmt4,	%o0
	call 	printf
	mov	%l3,	%o1		!print after product

set2:	
	set 	0x04ee67b7,	%l0	!multiplicand
	set 	0xf8d17474,	%l1	!multiplier
	
	set 	fmt2,	%o0		!set fmt
	call 	printf			!print
	mov	%l1,	%o1		!move to print (print multiplier)
	
	set 	fmt3, 	%o0		!set fmt
	call 	printf			!print
	mov	%l0,	%o1		!move to print	(print multiplicand)

	srl	%l1,	31,	%l2	!shift right to last digit (multiplier) and store last digit into %l2

	mov 	0,	%l3		!make product = 0
	mov 	0,	%l5		!make counter = 0

	set	fmt1,	%o0		!set fmt
	call 	printf
	mov 	%l3,	%o1		!move to print (print product)

	ba 	condition2			!for loop start
	mov 	32,	%l6		!make %l6 = 32	(delay slot)

startloop2:

	and	%l1,	1,	%l4	!get multiplier right most bit and set in %l4

	cmp 	%l4,	1		!check if right most bit of multiplier is 1
	bne	skip2			!goes to skip if 0, otherwise it adds product + multiplicand 
	nop
	add 	%l3,	%l0,	%l3	!add product + multipicand and store in product
	
skip2:
	and 	%l3, 	1, 	%l4	!get right most bit in product and store in %l4
	sll	%l4,	31,	%l7	!moves right most from product to left most bit	
	
	srl	%l1, 	1,	%l1	!multiplier shift right by 1
	or	%l7,	%l1,	%l1	!right most bit of product moves to leftmost bit of multiplier
	sra	%l3,	1,	%13	!product shift by 1 to the right
	
	inc	%l5			!increment counter

condition2:
	cmp	%l5,	%l6		!check that i < 32
	bl	startloop2		!branches to top if i < 32
	nop	

ifnegative2:
	cmp	%l2,	1		!compare if %l2 > 0
	bne	notneg2			!goes to notneg if it is not negative, otherwise
	nop
	sub	%l3,	%l0,	%l3	!otherwise product - multiplicand and store into product
	
notneg2:	

	set 	fmt5,	%o0
	call 	printf
	mov 	%l1,	%o1		!print after multiplier

	set 	fmt6,	%o0	
	call 	printf	
	mov	%l0,	%o1		!print after multiplicand

	set 	fmt4,	%o0
	call 	printf
	mov	%l3,	%o1		!print after product

set3:	
	set 	0xfb119849,	%l0	!multiplicand
	set 	0xf8d17474,	%l1	!multiplier

	set 	fmt2,	%o0		!set fmt
	call 	printf			!print
	mov	%l1,	%o1		!move to print (print multiplier)	

	set 	fmt3, 	%o0		!set fmt
	call 	printf			!print
	mov	%l0,	%o1		!move to print	(print multiplicand)

	srl	%l1,	31,	%l2	!shift right to last digit (multiplier) and store last digit into %l2

	mov 	0,	%l3		!make product = 0
	mov 	0,	%l5		!make counter = 0

	set	fmt1,	%o0		!set fmt
	call 	printf
	mov 	%l3,	%o1		!move to print (print product)

	ba 	condition3			!for loop start
	mov 	32,	%l6		!make %l6 = 32	(delay slot)

startloop3:

	and	%l1,	1,	%l4	!get multiplier right most bit and set in %l4

	cmp 	%l4,	1		!check if right most bit of multiplier is 1
	bne	skip3			!goes to skip if 0, otherwise it adds product + multiplicand 
	nop
	add 	%l3,	%l0,	%l3	!add product + multipicand and store in product
	
skip3:
	and 	%l3, 	1, 	%l4	!get right most bit in product and store in %l4
	sll	%l4,	31,	%l7	!moves right most from product to left most bit	
	
	srl	%l1, 	1,	%l1	!multiplier shift right by 1
	or	%l7,	%l1,	%l1	!right most bit of product moves to leftmost bit of multiplier
	sra	%l3,	1,	%13	!product shift by 1 to the right
	
	inc	%l5			!increment counter

condition3:
	cmp	%l5,	%l6		!check that i < 32
	bl	startloop3		!branches to top if i < 32
	nop	

ifnegative3:
	cmp	%l2,	1		!compare if %l2 > 0
	bne	notneg3			!goes to notneg if it is not negative, otherwise
	nop
	sub	%l3,	%l0,	%l3	!otherwise product - multiplicand and store into product
	
notneg3:	
	
	set 	fmt5,	%o0
	call 	printf
	mov 	%l1,	%o1		!print after multiplier
	
	set 	fmt6,	%o0	
	call 	printf	
	mov	%l0,	%o1		!print after multiplicand

	set 	fmt4,	%o0
	call 	printf
	mov	%l3,	%o1		!print after product
	
end:
	mov 	1,	%g1		!end program
	ta	0
