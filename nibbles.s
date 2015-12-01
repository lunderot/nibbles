.set WORM_CHAR, 111
.set APPLE_CHAR, 36
.set WORM_MAX_LEN, 50
.set SCREEN_SIZE, 50
.set MAX_APPLES, 100

.section .bss
	body:	.fill  WORM_MAX_LEN, 8	#Reserve space for worm body
	apples:	.fill  MAX_APPLES, 8	#Reserve space for apples

.section .data
	nrOfApples:		.long	0

	currentLength:	.long	0 #set to len
	direction:		.long	0
	hit:			.long	0
	done:			.long	0
	input:			.long	0xffffffff
	
	NBRS:
					.long	2
					.long	3
					.long	6

.section .text
.globl start_game
start_game:
	call	nib_init
		
	#Move function arguments into memory
	movl	4(%esp), %eax
	movl	%eax, currentLength
	movl	8(%esp), %eax
	movl	%eax, nrOfApples
	
	movl $2, %ecx
	initApples:
			
			pushl	%ecx
			
			xorl	%eax, %eax
			movl	$NBRS, %edi
			addl	(%edi, %ecx, 4), %eax
			movl	%eax, %ebx
		
			#movl	$apples, %ebx 		#ebx = apples address
			#addl	(%ecx, 8), %ebx   	#ebx = 8 * i + ebx
										#ebx is now the address of an apple
										
			#pushl	%ecx
			#call	rand				#eax is now a random value
			#popl	%ecx
			
			#movl	$SCREEN_SIZE, %edx
			#divl	%edx				#edx = eax MOD edx
			
			movl   0(%ebx), %eax		#Nått fel när vi räknar ut ebx
			#pushl	4(%ebx)
			
			popl	%ecx	
	loop initApples
	
	
	
	

	
	
	
	
	
	
	
	
	
	
	
	
	
	movl $SCREEN_SIZE, %ecx
	drawBorders:
			pushl	%ecx
			pushl	$'-'
			pushl	$SCREEN_SIZE
			pushl	%ecx
			
			call	nib_put_scr	
			addl	$12, %esp
			popl 	%ecx

			pushl	%ecx
			pushl	$'-'
			pushl	$0
			pushl	%ecx
			
			call	nib_put_scr	
			addl	$12, %esp
			popl 	%ecx
			
			pushl	%ecx
			pushl	$'|'
			pushl	%ecx
			pushl	$SCREEN_SIZE
			
			call	nib_put_scr	
			addl	$12, %esp
			popl 	%ecx
			
			pushl	%ecx
			pushl	$'|'
			pushl	%ecx
			pushl	$0
			
			call	nib_put_scr	
			addl	$12, %esp
			popl 	%ecx
			
	loop drawBorders
	
	
	

end:
	pushl	$11100000
	call 	usleep
	call	nib_end

