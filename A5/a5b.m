!Stefan Jovanovic
!A5 part b
!CPSC 355

.global main
	
	.align 4
	.global months
months: .word jan_m, feb_m, mar_m, apr_m, may_m, jun_m, jul_m, aug_m, sep_m, oct_m, nov_m, dec_m

jan_m:	.asciz "January"
	!.align 4
feb_m:	.asciz "Febuary"
	!.align 4
mar_m:	.asciz "March"
	!.align 4
apr_m:	.asciz "April"
	!.align 4
may_m:	.asciz "May"
	!.align 4
jun_m:	.asciz "June"
	!.align 4
jul_m:	.asciz "July"
	!.align 4
aug_m:	.asciz "August"
	!.align 4
sep_m:	.asciz "September"
	!.align 4
oct_m:	.asciz "October"
	!.align 4
nov_m:	.asciz "November"
	!.align 4
dec_m:	.asciz "December"
	!.align 4

fmt:	.asciz "%s %sth, %s\n"
	.align 4

fmtError:	.asciz "ERROR IN ARGUMENTS"
		.align 4

main:	save	%sp,	-96,	%sp
	
	!first see if there are 3 arguments 
	cmp	%i0,	4
	bne	error1				!no 3 arguments then throw error
	nop

	ld	[%i1 + 4],	%o0		!first argument month
	
	call 	atoi				!change month into int from string
	nop
	
	mov	%o0,	%l0			!need register for print

check1:
	mov 	0,	%l2
	cmp	%l0,	%l2
	ble	error1
	nop

	mov	13,	%l2
	cmp	%l0,	%l2
	bge	error1
	nop


	dec 	%l0				!decriment because array is 0-11
	sll	%l0,	2,	%l0		!multiply by 4 (word)

	ld	[%i1 + 8],	%o2		!second argument day

	ld	[%i1 + 12],	%o3		!third argument year	

	set 	months,	%o1
	add	%o1,	%l0,	%o1		!add offset to month 
	ld	[%o1],	%o1			

!argCheck2:
!	ld	[%i1 + 8],	%l6
!	mov	%l6,	%o0
!	
!	call 	atoi
!	nop
!		
!	cmp	%o0,	1			!cmp day with 1
!	bl	error1
!	nop
!
!	cmp	%o0,	31			!cmp day with 31
!	bg	error1
!	nop
!
!argCheck3:
!	ld	[%i1 + 12],	%o0
!	call	atoi
!	nop
!
!	cmp	%o0,	0
!	bl	error1
!	nop	

	set 	fmt,	%o0
	call 	printf
	nop	
	
	ba 	end1
	nop

error1:
	set 	fmtError,	%o0
	call	printf
	nop	

	end1:
	
		mov	1,	%g1
		ta 	0
	

