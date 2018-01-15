!Stefan Jovanovic
!10135783
!CPSC 355

!note this runs array sorted in an infinite loop, not sure why this bug happens but i included another file where i changed one line of code and only runs the random array, ps. i spent 2 hours trying to fix this bug, i wish that i could say this statement was a lie...



!define(`local_var', `!local variables define(`last_sym', 0)')
!define(`var', `define(`last_sym', 
!eval((last_sym -ifelse($3,,$2,$3)) & -$2)) $1 = last_sym')

define(size,	40)		!make size of the array = 40
define(int, 	4)		!make elements in the array be 4 bytes (interger)

define(size_r,	%l0)
define(gap_r, 	%l1)
define(i_r, 	%l2)
define(j_r, 	%l3)
define(temp_r,	%l4)
define(pH_r,	%l5)		!place holder
define(point_r,	%i6)		!pointer of memory
define(value_r,	%l6)		!value of element

define(firElement,	%o4)	!value of first element of array
define(secElement,	%o5)	!value of second element of array
define(point1_r,	%o0)	!first pointer
define(point2_r,	%o1)	!second pointer


!local_var
!var(iv_s,	int,	int*size)

header1:	.asciz	"Non-Sorted Array\n"	!header for non-sorted array
		.align 4

header2:	.asciz 	"Sorted Array\n"	!header for sorted array
		.align 4

arrayPrint:	.asciz	"v[%d] = %d\n"		!takes 2 values and prints them in that order


.global main
main:	save	%sp, -96, %sp	!make frame pointer = stack pointer
	
	mov 	size, 	size_r		!initalize size_r to 40
	mov	size_r,	%o0

	sll	%o0,	2,	%o0	!multiply size by 4 since we need 4 bytes for elements in the stack
	sub	%sp,	%o0,	%sp	!make space for 40*4 bytes of memory to store our int array[]
	
	mov 	1,	i_r		!this is our counter for fill loop, initalize counter

fillArrayLoop:
	call	rand			!call random function
	nop
	mov	%o0, 	%l6		!move random interger to register

	set 	0xFF,	%l7		!set 0xFF to register !nop spot 
		
	and 	%l6,	%l7,	%o0	!makes it so it is positive and mod 256
	mov	%o0,	temp_r		!move the result into a register to temporary store

	sll	i_r,	2,	%o0	!take counter and i*4, this is to calculate the memory location
	
	sub	%fp, 	%o0,	pH_r	!place holder = %fp - counter*4
	st	temp_r,	[pH_r]		!store our random variable into the array at place holder 

	inc	i_r			!increment i_r by 1

fillTest:
	cmp 	i_r,	size		!compare counter to size of array
	ble	fillArrayLoop		!branches to fillLoop if the counter <= size of array
	nop
					!otherwise fall through to the setup of displayArray

	set	header1, %o0		!set to print header for non-sorted array
	call 	printf
	mov 	1,	i_r		!set counter for display array !nop spot	

displayArray:	
	sll	i_r,	2,	%o0		!take counter and *4 and store in temp (counter*4)
	sub	%fp,	%o0,	%o0	
	
	ld	[%o0], 		value_r		!get element of array at counter*4
	sub 	i_r,	1,	temp_r		!substract counter by 1 to format for print
	
	mov	temp_r,		%o1		!move to print
	mov	value_r,	%o2

	set 	arrayPrint,	%o0		!print
	call 	printf
	nop			 
	
	inc	i_r				!counter++

displayArrayTest:
	cmp	i_r, 	size			!compare counter to size of array 
	ble	displayArray			!if counter <= size of array brach to displayArray
	nop

						!otherwise set up for the shellSortLoop
	srl	size_r,	1,	gap_r		!gap = size/2
	ba 	shellSortTest	
	nop

shellSortLoop:
	ba	secondLoopTest			!test second loop guard
	nop

secondLoop:
	
	ba	thirdLoopTest			!test 3rd loop guard
	nop


thirdLoop:
	
	st	%i0,	[point2_r]		!v[j + gap] = v[j]	switch places if v[j] > v[j + gap]
	st	%i1,	[point1_r]		!v[j] = v[j + gap]

	sub	j_r,	gap_r,	j_r		!update j counter for 3rd loop guard




thirdLoopTest:
	cmp	j_r,	0			!comapre 0 and j
	bl	if				!if j < 0 go to if 
	nop					!else continue to rest of code in loop test 3
	
	add	j_r,	1,	temp_r		!temp = j + 1
	sll	temp_r,	2,	temp_r		!temp = temp * 4

	sub	%fp,	temp_r,	point1_r	!take %fp - counter * 4(bytes for integers) to get first index of array
	ld	[point1_r],	%i0		!get first element from array and store to firElement
	  
	add	gap_r,	j_r,	temp_r		!temp = gap + j
	inc	temp_r				!temp =(gap + j) + 1,	add one to get next element in array
	
	sll	temp_r,	2,	temp_r		!temp =((gap + j) + 1) * 4, multi by 4 to get bytes for ints
	
	sub	%fp,	temp_r,	point2_r	!take %fp - (counter +1) *4 (bytes for int) to get second index of array					
	ld	[point2_r],	%i1		!get second element from array and store to secElement

	cmp	%i0,	%i1			!compare the 2 elements, v[j] to v[j + gap]
	bg	thirdLoop			!execute third loop to switch places if v[j] < v[j + gap]
	nop

if:
	inc 	i_r				!incement i for second loop guard 
	


secondLoopTest:
	cmp	i_r,	size_r			!compare i and size
	bl	secondLoop			!branches if i < size
	sub	i_r,	gap_r,	j_r		!initalize j = i - gap !nop spot		


	srl	gap_r,	1,	gap_r		!gap = gap/2	!counter for first loop guard

shellSortTest:				!test first loop guard
	cmp	gap_r,	0		!compare gap and 0
	bg	shellSortLoop		!branches if gap > 0 			
	mov	gap_r,	i_r		!initalize i =  gap	!nop spot 
	
			
					!exit loop, set header for printing array and counter 
	set 	header2,	%o0
	call 	printf
	nop

	mov	1,	i_r		

displayArraySorted:
	sub	%fp,	%o5,	%o5	
	
	ld	[%o5], 		value_r		!get element of array at counter*4
	sub 	i_r,	1,	temp_r		!substract counter by 1 to format for print
	
	mov	temp_r,		%o1		!move to print
	mov	value_r,	%o2

	set 	arrayPrint,	%o0		!print
	call 	printf
	nop			 
	
	inc	i_r				!counter++		
	
displayArrayTestSorted:
	cmp	i_r, 	size			!compare counter to size of array 
	ble	displayArray			!if counter <= size of array brach to displayArray
	sll	i_r,	2,	%o5		!nop spot
	

	mov 	1, 	%g1		!end program
	ta	0	
