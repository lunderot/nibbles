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
	
	.local	x
	.comm	x,800,64

.section .text
.globl start_game
start_game:
	call	nib_init
		
	#Move function arguments into memory
	movl	4(%esp), %eax
	movl	%eax, currentLength
	movl	8(%esp), %eax
	movl	%eax, nrOfApples
	
	
	movl nrOfApples, %ecx
	initApples:
			
			pushl	%ecx
			
			xorl	%eax, %eax
			
			movl	$apples, %ebx 				#ebx = apples address
			#movl	(%edi, %ecx, 8), %eax   	#ebx = 8 * i + ebx
			movl	%ecx, %eax
			movl	$8, %ecx
			mull	%ecx
			addl	%eax, %ebx
			#ebx is now the address of an apple
										
			call	rand				#eax is now a random value
			movl	$SCREEN_SIZE, %ecx
			xorl	%edx, %edx
			divl	%ecx				#edx = eax MOD ecx
			
			movl    %edx, (%ebx)
			
			
			call	rand
			movl	$SCREEN_SIZE, %ecx
			xorl	%edx, %edx
			divl	%ecx				#edx = eax MOD ecx
			
			movl    %edx, 4(%ebx)
			
			popl	%ecx
				
	loop initApples
	
	movl nrOfApples, %ecx
	drawApples:
			
			pushl	%ecx
			
			xorl	%eax, %eax
			
			movl	$apples, %ebx 				#ebx = apples address
			#movl	(%edi, %ecx, 8), %eax   	#ebx = 8 * i + ebx
			movl	%ecx, %eax
			movl	$8, %ecx
			mull	%ecx
			addl	%eax, %ebx
			#ebx is now the address of an apple
			
			pushl	$APPLE_CHAR						
			movl    (%ebx), %eax
			pushl	%eax
			movl    4(%ebx), %eax
			pushl	%eax
	
			call	nib_put_scr	
			addl	$12, %esp
			
			popl	%ecx
				
	loop drawApples
	
	
	
	
	

	
	
	
	
	
	
	
	
	
	
	
	
	
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

