.set WORM_CHAR, 111
.set APPLE_CHAR, 36
.set WORM_MAX_LEN, 50
.set SCREEN_SIZE, 50
.set MAX_APPLES, 100

.section .bss
	body:	.space  WORM_MAX_LEN, 8	#Reserve space for worm body

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
	call	nib_init
		
	#Move function arguments into memory
	#movl	4(%esp), %eax
	#movl	%eax, currentLength
	#movl	8(%esp), %eax
	#movl	%eax, nrOfApples
	
	movl $SCREEN_SIZE, %ecx
	
	xorl %eax, %eax
	
	l5:
			movl %ecx, %ebx
			pushl	$111
			pushl	$18
			pushl	%ecx
			
			call	nib_put_scr	
			addl	$12, %esp
			
			movl %ebx, %ecx
	loop l5


end:
	pushl	$11100000
	call 	usleep
	call	nib_end

