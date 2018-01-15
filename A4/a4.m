!Stefan Jovanovic
!10135783
!Assignment 4


include(macro_defs.m)				!file in folder 

firstCircleLabel:
	.asciz "First circle coordinates: \n"	!first circle label
	.align 4

secondCircleLabel:
	.asciz "Second circle coordinates: \n"	!second circle label
	.align 4

coodinates:
	.asciz "x: %d, y: %d, r: %d \n"		!print coordinates
	.align 4

fmt:	
	.asciz "%d \n"
	.align 4


define(TRUE, 1)				!define true
define(FALSE, 0)			!define false

define(fc_x,	%l0)			!first circle x
define(fc_y,	%l1)			!first circle y
define(fc_r,	%l2)			!first circle r
define(sc_x,	%l3)			!second circle x
define(sc_y,	%l4)			!second circle y
define(sc_r,	%l5)			!second circle r

define(fc_v,	%o3)			!first circle value
define(sc_v,	%o4)			!second circle value

	begin_struct(point)				!struct of x and y points
	field(x, 4)
	field(y, 4)
	end_struct(point)

	begin_struct(circle)				
	field(origin, align_of_point, size_of_point)	!nested struct of orign contains x and y
	field(r, 4)					!struct of radius 
	end_struct(circle)

	local_var
	var(firstC_c, align_of_point, size_of_point)
	var(secC_c, align_of_point, size_of_point)
	
	.global main
main:	
	!There is a bug in my program that sets my second circle to x = 0, y=0, and r =0
	!although my first circle coordinates are x = 0, y = 0, and r =1
	!so it sets 1 for radius in the first circle but 0 for the second even though they call the same subroutine

	!went through gdb and it confirms that the first circle radius is 1 and second circle radius is 0
	!becuase went through to the equals function and found that first circle radius is 1 and second radius is 0
	!the print initial values for the second circle just use the first circle values?- cant confirm

	!in my equals function cannot actually change the boolean to true because radius 1 != 0 
	!so had to modify code to actually allow it to pass to read the rest of the program

	!in second circle, again r * 7 = 0 because radius == 0 so it shows up as 0 cant fix becuase bug in code for initalizing
	
	!bug again in first circle in the move function, not sure why its 7 and not 3 for x value 

	!can i schedule an appointment with you after you grade my assignment, beacuse i spent over 4 hours asking friends, looking for solutions,
	!debugging using gdb, looking for answers online, looking through notes, going line by line printing values, rearranging code etc.
	!i would really like to find out what was wrong with my program beacuse i might have gone insane from this assignment and dont know what to do

	save	%sp,	(-92 + last_sym) & -8,	%sp	

	!first Circle	
	add	%fp,	firstC_c,	%o0		!get address of first circle
	st	%o0,	[%sp + 64]			!store address on stack

	call newCircle					!initalize circle
	mov	%o0,	%l0				!nop spot, just moves address to %l0 because print uses %o0
	.word	size_of_circle
	
	set 	firstCircleLabel, 	%o0		!print circle label 
	call 	printf
	nop	

       	ld	[%l0 + circle_origin + point_x],	%o1	!get x value and put into register
	ld	[%l0 + circle_origin + point_y],	%o2	!get y value and store in register
	ld 	[%l0 + circle_r],			%o3	!get r value and store in register
  
	set 	coodinates,	%o0			!display coordinates
	call 	printf
	nop

	!second Circle
	add 	%fp,	secC_c,		%o0		!get address of second circle
	st 	%o0,	[%sp + 64]			!store the address on the stack 12 bytes away from 1rst circle
	
	call 	newCircle				!initalize circle 
	mov 	%o0,	%l0				!nop spot, just moves address to %l0 beacuse print uses %o0
	.word 	size_of_circle	

	set 	secondCircleLabel,	%o0		!print second circle label
	call 	printf
	nop

	ld	[%l0 + circle_origin + point_x],	%o1	!get value of x and store in register
	ld	[%l0 + circle_origin + point_y],	%o2	!get value of y and store in register
	ld	[%l0 + circle_r],			%o3	!get value of r and store in register 

	set 	coodinates,	%o0			!print coodinates
	call 	printf
	nop

if:		
	add	%fp,	firstC_c,	%o0		!get address of first circle, first argument 
	add	%fp,	secC_c,		%o1		!nop spot, get address of second circle, second argument
	
	call 	equal
	nop
	
	cmp 	%o0,	0				!compare global variable to 1
	bne	done					!if not equal to 1 (true) then end program 
	nop
	
	add 	%fp,	firstC_c,	%o0		!nop spot, get address of first circle
				
							!prep for move subroutine 
							!%o0 is in the first circle already 
	mov 	3,	%o5				!move 3 into spot for arguments 
	mov 	-5,	%o2				!nop spot, move -5 into spot for arguments 
	call 	move
	nop
							!prep for expand subroutine 
	add 	%fp,	secC_c,		%o0		!address of second circle in arguments 					
	mov 	7,	%o1				!nop spot, move 7 into spot for arguments 
	call 	expand
	nop

	set 	firstCircleLabel,	%o0		!print first circle change
	call 	printf
	nop
		
	add 	%fp,	firstC_c,	%l0		!get address of first circle
	add 	%fp,	secC_c,		%l1		!get address of second circle

	ld	[%l0 + circle_origin + point_x],	%o1	!get value of fc x	
	ld	[%l0 + circle_origin + point_y],	%o2	!get value of fc y
	ld 	[%l0 + circle_r],			%o3	!get r of fc

	set 	coodinates,	%o0
	call 	printf
	nop

	set 	secondCircleLabel,	%o0		!print sc label
	call	printf
	nop

	ld	[%l1 + circle_origin + point_x],	%o1	!get x of sc
	ld 	[%l1 + circle_origin + point_y],	%o2	!get y of sc
	ld 	[%l1 + circle_origin + point_y],	%o3	!get r of sc
	
	set 	coodinates,	%o0
	call 	printf
	nop

done:
	mov	1,	%g1
	ta	0


newCircle:	save	%sp,	(-92 + last_sym) & -8,	%sp

		ld	[%fp + 64],	%l0				!get address
		
		mov	1,	%o1
		
		st	%g0,	[%fp + circle_origin + point_x]		!make origin.x = 0
		st	%g0,	[%fp + circle_origin + point_y]		!make origin.y = 0		
		st	%o1,	[%fp + circle_r]			!make r = 1
		
		ld	[%fp + circle_origin + point_x],	%l1	!get x value
		st	%l1,	[%l0 + circle_origin + point_x]		!set in main	
		
		ld	[%fp + circle_origin +  point_y],	%l1	!get y value 
		st	%l1,	[%l0 + circle_origin + point_y]		!set in main

		ld	[%fp + circle_r],	%l1			!get r value 
		st	%l1,	[%l0 + circle_r]			!set in main

		jmpl	%i7 + 12,	%g0
		restore
	

	
equal:	save 	%sp,	(-92 + last_sym) & -8,	%sp
	
	mov 	%i0,	%l0
	mov	%i1,	%l1
	
	mov	FALSE,	%i0						!make our boolean == false (0)

	ld	[%l0 + circle_origin + point_x],	fc_v		!first circle x	
	ld	[%l1 + circle_origin + point_x],	sc_v		!second circle x

	!start loop
	cmp	fc_v,	sc_v					!compare the two circles x's
	bne 	endLoop						!end loop if they are nto equal to each other
	nop							!cant optimize because need values as is 

	ld 	[%l0 + circle_origin + point_y],	fc_v	!first circle y
	ld 	[%l1 + circle_origin + point_y],	sc_v	!second circle y

	cmp	fc_v,	sc_v					!comapre the two circles y's
	bne	endLoop						!end loop if the are not equal to each other 
	nop
		
	ld 	[%l0 + circle_r],		fc_v		!first circle r
	ld 	[%l1 + circle_r],		sc_v		!second circle e		

	cmp	fc_v,	sc_v					!comapre the two circles r's
	bne	endLoop						!end loop if they are not equal to each other 
	nop				

	mov	TRUE,	%i0		!change our boolean to true if x, y, and r are the same for both circles

endLoop:				!end loop 
	
	ret
	restore


	.global move
move:	
	ld	[%o0 + circle_origin + point_x],	%o3		!get first circle x
	ld	[%o0 + circle_origin + point_y],	%o4		!get first circle y
	
	st	%g0,	[%o0 + circle_origin + point_x]			!set x = 0
	st 	%g0,	[%o0 + circle_origin + point_y]			!set y = 0

	add 	%o5,	%o3,	%o3					!fc_v = 0 + 3
	st 	%o3,	[%o0 + circle_origin + point_x]			!store value of fc_v into fc_x

	sub	%o2,	%o4,	%o4					!%o4 = 0 - 5
	st 	%o4,	[%o0 + circle_origin + point_y]			!store value of %o4 into fc_y
	
	retl
	nop


	.global expand
expand: 
	ld	[%o0 + circle_r],	%o2		!get radius of second circle
	
	smul	%o2,	%o1,	%o2			!r= 1*7
	nop		
	
	st	%o1,	[%o0 + circle_r]		!store value 7 into sc_r

	retl 
	nop
