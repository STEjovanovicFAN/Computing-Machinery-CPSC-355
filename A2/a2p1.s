!Stefan Jovanovic
!UC ID: 10135783

.global main

fmt1:	.asciz "Inital check: %x\n"	!format of inital
	.align 4

fmt2:	.asciz "Rightmost: %d\n"	!format of rightmost
	.align 4

fmt3:	.asciz "Number of bits: %d\n"	!format of bits
	.align 4

fmt4:	.asciz "Final: %x\n\n"		!final format
	.align 4

main:	
	save 	%sp, 	-96, 	%sp
	
set1:	
	set 	0x49D723, 	%l0	!set 1
	
	mov 	%l0, 	%o1		!move to print
	set 	fmt1, 	%o0		!set format of print
	call 	printf			!print %l0
	mov 	11, 	%l4		!set the right shift to 11 (delay slot)
	
	srl 	%l0, 	%l4, 	%l1	!shift %l0 by 11 right and put in %l1

	mov 	%l1, 	%o1		!move %l1 to print
	set 	fmt2, 	%o0		!set format of print
	call 	printf			!print
	mov 	23, 	%l4		!32 - (11+9) = 22 (delay slot)
	
	sll 	%l1, 	%l4, 	%l2	!shift left by 12 

	mov 	%l2, 	%o1		!move to print
	set 	fmt3, 	%o0		!set format
	call 	printf			!print
	mov 	23, 	%l4		!32 - 9 = 23 (delay slot) 
	
	srl 	%l2, 	%l4, 	%l3	!shift right by 23 and put result into %l3
	
	mov 	%l3, 	%o1		!move to print
	set 	fmt4, 	%o0		!set format
	call 	printf			!print
	

set2:	
	set 	0x1BA621B0, 	%l0	!set 1	(delay slot to call print above: ps didnt want to ruin format)
	
	mov 	%10, 	%o1		!move to print
	set 	fmt1, 	%o0		!set format of print
	call 	printf			!print %l0
	mov 	4, 	%l4		!set the right shift by 4 (delay slot)
	
	srl 	%l0, 	%l4, 	%l1	!shift %l0 by 4 right and put result in %l1
	
	mov 	%l1, 	%o1		!move %l1 to print
	set 	fmt2,	 %o0		!set format of print
	call 	printf			!print
	mov 	28, 	%l4		!32 - (4) = 28	(delay slot)

	sll 	%l1, 	%l4,	 %l2	!shift left by 28 

	mov 	%l2, 	%o1		!move to print
	set 	fmt3,	%o0		!set format
	call 	printf			!print
	mov 	28, 	%l4		!32 - 4 = 28 (delay slot)
	
	srl 	%l2, 	%l4, 	%l3	!shift right by 28 and put result into %l3
	
	mov 	%l3, 	%o1		!move to print
	set 	fmt4, 	%o0		!set format
	call 	printf			!print

set3:	
	set 	0xDEADBEEF, 	%l0	!set 1	(delay slot for the print above)
	
	mov 	%l0, 	%o1		!move to print
	set 	fmt1, 	%o0		!set format of print
	call 	printf			!print %l0
	mov 	8, 	%l4		!set the right shift to 8 (delayslot)
	
	srl 	%l0, 	%l4, 	%l1	!shift %l0 by 8 right and put in %l1

	mov 	%l1, 	%o1		!move %l1 to print
	set 	fmt2, 	%o0		!set format of print
	call 	printf			!print
	mov 	10, 	%l4		!32 - 22 = 10 (delay slot)
	
	sll 	%l1, 	%l4, 	%l2	!shift left by 10 

	mov 	%l2, 	%o1		!move to print
	set 	fmt3, 	%o0		!set format
	call 	printf			!print
	mov 	10, 	%l4		!32 - 22 = 10	(delay slot) 
	
	srl 	%l2, 	%l4, 	%l3	!shift right by 10 and put result into %l3
	
	mov 	%l3, 	%o1		!move to print
	set 	fmt4,	%o0		!set format
	call 	printf			!print
	nop				!I tried removing this delay slot with the (mov 1, %g1) 
					!however the program didnt go back to the control terminal after program executed, so i just left the nop in place 
	
	mov 	1, 	%g1		!delay slot
	ta 	0
