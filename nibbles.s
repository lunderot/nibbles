.section .data

wormChar:	.long	111
appleChar:	.long	36
nrOfApples: .long	0
maxLength:	.long	0

.section .text
.globl start_game
start_game:

	popl	%eax
	movl	%eax, nrOfApples
	popl	%eax
	movl	%eax, maxLength
	
	call	nib_init
	
label: 

	pushl	$nrOfApples
	pushl	$10
	pushl	$10
	
	call	nib_put_scr
	addl	$12, %esp
	jmp		label
	
	call	nib_end

