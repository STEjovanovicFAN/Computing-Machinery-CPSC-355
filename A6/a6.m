!Stefan Jovanovic
!CPSC 355
!A6

include(macro_defs.m)

define(FILE_NAME,	%l0)

	.section ".data"

fmt:	.asciz " x = %f radians\n"

fmtS:	.asciz " sine(x) = %f\n" 

fmtC:	.asciz " cosine(x) = %f\n\n"
	.align 	8
	
LOWER_LIMIT:	.double		0r0.0

DEGREE:		.double 	0r90.0

INCREMENT: 	.double		0r0.25

ABV:		.double		0r1.0e-10

PI2:		.double 	0r1.57079632679489661923

X:		.double		0r0.0

SINE:		.double		0r0.0

COSINE:		.double		0r0.0

	.section ".text"


local_var					!make a variable (buf) of how many bytes to read from
var(buf, 1,	1 * 8)				!the binary file

define(coin,	%l2)
define(zero,	%l3)


	.align 4
	.global	main
main:	save 	%sp,	(-92 - 8) & -8,	%sp	!fix how much memory we will need for the floats 
	
	ld 	[%i1 + 4],	%o0		!1rst argument, file name from command line
	
	clr	%o1				!2nd argument read only
	clr	%o2				!3rd argument not used 
	mov 	5,	%g1			!open the file 
	ta 	0				!trap always 

	bcc 	open_ok				!error check 
	nop
	
	mov 	1,	%g1 			!if it did not open we close program 
	ta 	0

open_ok:					!it opened the file and fd is in %o0
	mov	%o0,	FILE_NAME		!get copy of file name 

readLoop:
	mov 	FILE_NAME,	%o0		!first argument, file name
	add	%fp,	buf,	%o1		!2nd argument where bytes read will be stored 
	mov 	8,	%o2			!3rd argument how many bytes to read, 8
	mov 	3,	%g1			!request to read
	ta 	0				!trap always 
		
	cmp	%o0,	8			!check to see how many bytes were read 
	be	read_ok				!branch if the bytes read were 8
	nop
	
	mov 	1,	%g1			!did not read 8 bytes 
	ta 	0				!exit

read_ok:				
	ldd	[%fp + buf],	%f0		!get input in %f0 adn %f1
	set 	PI2,	%o2			!get pi/2 in address
	ldd	[%o2],	%f2			!get pi/2 in a f register
	
	fmuld	%f0,	%f2,	%f0		!put ans to %f0 - f1
	
	set 	DEGREE,	%o2			!get address to 90 into %f2-f3
	ldd 	[%o2],	%f2			!get 90 in f2-f3
	
	fdivd	%f0,	%f2,	%f6		!divide by 90 and put ans in %f6-f7
	
	set	X,	%l5			!address f0-f1 of X
	std	%f6,	[%l5]			!store x into x

	set 	fmt,	%o0			!print the value of x 
	ld	[%l5],	%o1			!print first portion of x (double)
	ld	[%l5 - 4],	%o2		!print second portion of x (double) 
	call 	printf
	nop
				
	call 	sine				!call for the sine value
	nop
	
	set 	SINE,	%l5			!get address of sine(x)
	set	fmtS,	%o0			!set to print sine(x)
	ld	[%l5],	%o1			!print first portion of sine(x)
	ld	[%l5-4],	%o2		!print second portion of sine(x)
	call	printf
	nop
	
						!call for the cosine value
	call 	cosine
	nop

	set 	COSINE,	%l5			!address of cosine(x)
	set 	fmtC,	%o0			!print cosine of x
	ld	[%l5],	%o1			!first portion of cosine(x)
	ld	[%l5-4],	%o2		!second portion of cosine(x)
	call 	printf
	nop


test:
	set	X,	%l5			!get X address
	ldd	[%l5],	%f0			!get X value
	set 	PI2,	%l4			!get pi/2 address
	ldd	[%l4],	%f2			!get pi/2 value

	fcmpd	%f0,	%f2			!compare X to pi/2
	nop
	
	fble	readLoop			!loop if X <= pi?2
	nop
	
	mov	FILE_NAME,	%o0		!move file name decriptor to first argument 
	mov	5,	%g1			!close the file
	nop 	

end:	  
	mov 	1,	%g1			!drop down and exit 
	ta 	0

	
	
sine:	save 	%sp,	(-92 -8) & -8,	%sp	!this is the key for what im using for %f registers since im not sure if macros will work and its too late to find out if they do because of the deadline
						!%f0-1 is total value of sine(x)
						!%f2-3 is the previous term 
						!%f4-5 is x^2
						!%f6-7 is the abs value (the value that must be satisfied before we break the loop)
						!%f10-11 is the factorial value
						!%f12-13 is the factorial counter
						!%f14-15 is just 1				
						!%f20-21 is temp %f

	mov	0,	zero
	mov	1,	coin			!set coin to be positive

	set 	X,	%l5			!get address of X
	ldd	[%l5],	%f0			!get value of X in %f0- %f1

	mov	6,	%i0			!store 6 into %i0 for the start value 
	std	%i0,	[%fp - 8]		!store to memory
	ldd	[%fp-8],%f10			!get from memory to float register
	fitod	%f10,	%f10			!convert the float register from int to double
	 	
	mov	3,	%i0			!counter of factorial
	std	%i0,	[%fp - 8]		!store to memory
	ldd 	[%fp-8],%f12			!get from memory to float register
	fitod	%f12,	%f12			!convert float register from int to double

	mov	1,	%i0			!put 1 into a register
	std	%i0,	[%fp - 8]		!put the register on stack
	ldd	[%fp-8],%f14			!take it out of the stack and into a float register
	fitod	%f14,	%f14			!convert float register from int to double

	fmuld	%f0,	%f0,	%f4		!%f4-5 == x^2
	fmuld	%f0,	%f4,	%f2		!x*x^2 into %f2-3	
	fdivd	%f2,	%f10,	%f2		!(x*x*x)/3! == (x^3)/6 in %f2-3
	
	set 	ABV,	%l5			!get address of 1.0e-10
	ldd	[%l5],	%f6			!1.0e-10 value in %f6
	
	fcmpd	%f2,	%f6			!see if term is less then 1.0e-10
	nop
	fbl	sineEnd				!if term is < 1.0e-10 then exit 
	nop

	fsubd	%f0,	%f2,	%f0		!x-(x^3/6) is out total so far

sineLoop:
	fmuld	%f2,	%f4,	%f2		!we multiply the last term by x^2
	
	faddd	%f12,	%f14,	%f12		!update the factorial counter by 1 (counter ++) (n-1)	
	faddd	%f12,	%f14,	%f20		!update the factorial counter by 1 again	(n)
	fmuld	%f12,	%f20,	%f20		!multiply the values together 

	fdivd	%f2,	%f20,	%f2		!(x^n)/(n-2)!*(n-1)*(n)
	faddd	%f12,	%f14,	%f12		!update counter to match the correct value for the counter
	
						!this %f2 is our new term

sineTest:
	fcmpd	%f2,	%f6			!see if term is less than 
	nop
	fbl	sineEnd				!exit if it is
	nop

	cmp	zero,	coin			!see if coin is negative
	bne	positiveS			! if coin is 0 then drops down to negativeS, otherwise positiveS branch
	nop
	
	negativeS:
		fsubd	%f0,	%f2,	%f0	!subtract total and the next term

		mov	1,	coin		!change for next term to be added
			
		ba	sineLoop		!go through the sine loop again
		nop

		
	positiveS:
		faddd	%f0,	%f2,	%f0	!add the total to the next term
		
		mov	0,	coin		!change for next term to be subtracted

		ba	sineLoop		!go through the sine loop again
		nop


sineEnd:
	set	SINE,	%l5			!get address of global sine 
	std	%f0,	[%l5]			!store the total into sine global
	
	ret
	restore




cosine:	save	%sp,	(-92 - 8) & -8,	%sp
						!%f0-1 is our total value of cosine(x)
						!%f2-3 is our previous term
						!%f4-5 is x^2
						!%f6-7 is our ASV
						!%f10-11 is the factorial value
						!%f12-13 is the factorial counter
						!%f14-15 is 1

	mov	1,	coin			!coin is positive
	mov 	0,	zero

	set	X, 	%l5			!X address
	ldd	[%l5],	%f16			!X value in %f0
	
	mov 	2,	%i0			!2 is our factorial value %f10
	std	%i0,	[%fp - 8]		!store on stack
	ldd	[%fp-8],%f10			!take out of stack into %f register 
	fitod	%f10,	%f10			!convert from int to double float

	mov 	2,	%i0			!2 is our factorial counter %f12
	std	%i0,	[%fp -8]		!store 2 on stack
	ldd	[%fp-8],%f12			!take from stack and into %f register
	fitod	%f12,	%f12			!convert it from int to double

	mov 	1,	%i0			!just 1	%f14
	std	%i0,	[%fp - 8]		!store on stack
	ldd	[%fp-8],%f14			!load from stack into %f register
	fitod	%f14,	%f0			!set total to 1 so far
	fitod	%f14,	%f14			!convert it from int to double
	
	fmuld	%f16,	%f16,	%f4		!%f4-5 is x^2
	fdivd	%f4,	%f10,	%f2		!f2 is our term (x^2)/2!

	set 	ABV,	%l5			!1.0e-10 address
	ldd	[%l5],	%f6			!1.0e-10 value
			

	fcmpd	%f2,	%f6			!check if term is < 1.0e-10
	nop
	fbl	cosEnd				!if it is then branch to end
	nop

	fsubd	%f0,	%f2,	%f0		!total == 1 - (x^2)/2!

cosLoop:
	fmuld	%f2,	%f4,	%f2		!last term * x^2

	faddd	%f12,	%f14,	%f12		!factorial counter ++
	faddd	%f12,	%f14,	%f20		!factorial counter ++ in different register this time
	fmuld	%f12,	%f20,	%f20		!(n-1)*(n)

	fdivd	%f2,	%f20,	%f2		!(x^n)/(n-2)!*(n-1)*n
	faddd	%f12,	%f14,	%f12		!update counter

						!this is our new term
cosTest:
	fcmpd	%f2,	%f6			!test if < 1.0e-10
	nop
	fbl	cosEnd				!if it is then branch to end
	nop
	
	cmp	zero,	coin			!see if we should add or subtract
	bne	positiveC			!branch to add if it should be added 
	nop

	negativeC:
		fsubd	%f0,	%f2,	%f0	!total - new term
		
		mov	1,	coin		!make it so next term is added
		
		ba 	cosLoop			!go back to loop and continue through loop
 		nop
	
	positiveC:
		faddd	%f0,	%f2,	%f0	!total + new term
		
		mov 	0, 	coin		!make it so that next term is subtracted
		
		ba cosLoop			!go back to loop and continue through loop
		nop

cosEnd:
	set 	COSINE,	%l5			!get global address of cosine 
	std	%f0,	[%l5]			!store total value in cosine global 
	
	ret 
	restore


