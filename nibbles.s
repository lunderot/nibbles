.section .data

.set CONSTANT, 20
.set WORM_CHAR, 111
.set APPLE_CHAR, 36

nrOfApples:		.long	0
maxLength:		.long	0

currentLength:	.long	0 #set to len
direction:		.long	0
hit:			.long	0
done:			.long	0
input:			.long	0xffffffff


.section .text
.globl start_game
start_game:

	movl	4(%esp), %eax
	movl	%eax, maxLength
	movl	8(%esp), %eax
	movl	%eax, nrOfApples
	
	call	nib_init
	
label: 
	
	movl	maxLength, %ebx
	pushl	%ebx
	pushl	$10
	pushl	$10
	
	call	nib_put_scr
	addl	$12, %esp
	jmp		label
	
	call	nib_end

