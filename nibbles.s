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

.section .text
.globl start_game
start_game:
	call	nib_init
		
	#Move function arguments into memory
	movl	4(%esp), %eax
	movl	%eax, currentLength
	movl	8(%esp), %eax
	movl	%eax, nrOfApples
	
############################# Init apples ##############################
	movl nrOfApples, %ecx
	initApples:
			
		pushl	%ecx
			
		xorl	%eax, %eax
			
		movl	$apples, %ebx 				#ebx = apples address
		
		movl	%ecx, %eax
		movl	$8, %ecx
		mull	%ecx
		addl	%eax, %ebx					#ebx = 8 * i + ebx
											#ebx is now the address of an apple
										
		call	rand						#eax is now a random value
		movl	$SCREEN_SIZE, %ecx
		xorl	%edx, %edx
		divl	%ecx						#edx = eax MOD ecx
			
		movl    %edx, -4(%ebx)
			
			
		call	rand
		movl	$SCREEN_SIZE, %ecx
		xorl	%edx, %edx
		divl	%ecx						#edx = eax MOD ecx
			
		movl    %edx, -8(%ebx)
			
		popl	%ecx
				
	loop initApples
	
############################## Init body ###############################
	xorl	%ecx, %ecx						#Loop from 0 to currentLength
	initBody:
	pushl	%ecx
		
		xorl	%eax, %eax
			
		movl	$body, %ebx 				#ebx = body address
		movl	%ecx, %eax
		movl	$8, %ecx
		mull	%ecx
		addl	%eax, %ebx					#ebx is now the address of a body part
		
		xorl	%edx, %edx
		movl	$SCREEN_SIZE, %eax
		movl	$2, %ecx
		divl	%ecx						#eax is now screenSize/2
		
		
		
		movl    %eax, (%ebx)				#x = screenSize/2
		popl	%ecx						#y = screenSize/2 + i
		addl	%ecx, %eax
		movl    %edx, 4(%ebx)
		

	incl	%ecx
	cmpl	currentLength, %ecx
	jne		initBody
		
############################# Draw apples ##############################
	movl nrOfApples, %ecx
	drawApples:
			
		pushl	%ecx
			
		xorl	%eax, %eax
			
		
		movl	$apples, %ebx 				#ebx = apples address
		movl	%ecx, %eax
		movl	$8, %ecx
		mull	%ecx
		addl	%eax, %ebx					#ebx = 8 * i + ebx
											#ebx is now the address of an apple
		
		pushl	$APPLE_CHAR						
		movl    -4(%ebx), %eax				#y
		pushl	%eax
		movl    -8(%ebx), %eax				#x
		pushl	%eax

		call	nib_put_scr	
		addl	$12, %esp
		
		popl	%ecx
				
	loop drawApples
	
############################## Draw body ###############################
	xorl	%ecx, %ecx						#Loop from 0 to currentLength
	drawBody:
	pushl	%ecx
			
		xorl	%eax, %eax
			
		
		movl	$body, %ebx 				#ebx = apples address
		movl	%ecx, %eax
		movl	$8, %ecx
		mull	%ecx
		addl	%eax, %ebx					#ebx = 8 * i + ebx
											#ebx is now the address of an apple
		
		pushl	$WORM_CHAR
		movl    4(%ebx), %eax				#y
		pushl	%eax
		movl    (%ebx), %eax				#x
		pushl	%eax

		call	nib_put_scr	
		addl	$12, %esp
	
	popl	%ecx
	incl	%ecx
	cmpl	currentLength, %ecx
	jne		drawBody
	
############################# Draw borders #############################
	movl $SCREEN_SIZE, %ecx
	drawBorders:
			movl	%ecx, %ebx
			pushl	%ecx
			
			pushl	$'-'
			pushl	$SCREEN_SIZE
			pushl	%ebx
			call	nib_put_scr	
			addl	$12, %esp

			pushl	$'-'
			pushl	$0
			pushl	%ebx
			call	nib_put_scr	
			addl	$12, %esp
			
			pushl	$'|'
			pushl	%ebx
			pushl	$SCREEN_SIZE
			call	nib_put_scr	
			addl	$12, %esp
			
			pushl	$'|'
			pushl	%ebx
			pushl	$0
			call	nib_put_scr	
			addl	$12, %esp
						
			popl 	%ecx
			
	loop drawBorders


############################### End game ###############################	
end:
	pushl	$11100000
	call 	usleep
	call	nib_end

