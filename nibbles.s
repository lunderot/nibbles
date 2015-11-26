.section .bss
var:	.long	0

.section .data


.set CONSTANT, 20


wormChar:	.long	111
appleChar:	.long	36
nrOfApples: .long	0
maxLength:	.long	0

currentLength:	.long	0 #set to len
direction:		.long	0
hit:			.long	0
done:			.long	0
input:			.long	0xffffffff


.section .text
.globl start_game
start_game:

	popl	%eax
	movl	%eax, var
	
	
	
	
	
	popl	%eax
	
	
	call	nib_init
	
label: 

	movl	$var, %eax
	pushl	(%eax)
	pushl	$10
	pushl	$10
	
	call	nib_put_scr
	addl	$12, %esp
	jmp		label
	
	call	nib_end

