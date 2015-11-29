.set WORM_CHAR, 111
.set APPLE_CHAR, 36
.set WORM_MAX_LEN, 50
.set SCREEN_SIZE, 50
.set MAX_APPLES, 100

.section .bss
	body:	.fill WORM_MAX_LEN, 8	#Reserve space for worm body

.section .data
	nrOfApples:		.long	0

	currentLength:	.long	0 #set to len
	direction:		.long	0
	hit:			.long	0
	done:			.long	0
	input:			.long	0xffffffff


.section .text
.globl start_game
start_game:

	#Move function arguments into memory
	movl	4(%esp), %eax
	movl	%eax, currentLength
	movl	8(%esp), %eax
	movl	%eax, nrOfApples
	
	#Init snake body
	movl	(currentLength), %ecx
bodyInit:
	movl	body, %ebx	#Get the address of the body
	movl	%ecx, %eax
	imull	$2, %eax
	addl	%eax, %ebx	#Calculate and get the right address
	
	
	
	loop	bodyInit
	
	
	call	nib_init
	
label: 
	
	movl	currentLength, %ebx
	pushl	%ebx
	pushl	$10
	pushl	$10
	
	call	nib_put_scr
	addl	$12, %esp
	jmp		label
	
	call	nib_end

