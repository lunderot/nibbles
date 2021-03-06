.set WORM_CHAR, 111
.set APPLE_CHAR, 36
.set WORM_MAX_LEN, 50
.set SCREEN_SIZE, 50
.set MAX_APPLES, 100

.set KEY_UP, 259
.set KEY_RIGHT, 261
.set KEY_DOWN, 258
.set KEY_LEFT, 260

.section .bss
	body:	.fill  WORM_MAX_LEN, 8	#Reserve space for worm body
	apples:	.fill  MAX_APPLES, 8 	#Reserve space for apples

.section .data

	nrOfApples:		.long	0
	currentLength:	.long	0 #set to len
	hit:			.long	0
	input:			.long	KEY_UP

.section .text
.globl start_game
start_game:

########################################################################
################################ Init ##################################
########################################################################

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
	xorl	%ecx, %ecx
	initBody:		
	pushl	%ecx
			
		xorl	%eax, %eax
			
		movl	$body, %ebx 				#ebx = body address
		movl	%ecx, %eax
		movl	$8, %ecx
		mull	%ecx
		addl	%eax, %ebx					#ebx = 8 * i + ebx
											#ebx is now the address of a body part
			
		xorl	%edx, %edx
		movl	$SCREEN_SIZE, %eax
		movl	$2, %ecx
		divl	%ecx						#eax is now screenSize/2
		
		movl    %eax, (%ebx)				#x = screenSize/2
	popl	%ecx							#y = screenSize/2 + i
		addl	%ecx, %eax
		movl    %eax, 4(%ebx)
	
	incl	%ecx
	cmpl currentLength, %ecx	
	jne initBody
	
########################################################################
############################## Main loop ###############################
########################################################################

	mainLoop:

######################## Collision with borders ########################
	movl	$body, %ebx
	cmpl	$0, (%ebx)
	je		end
	cmpl	$SCREEN_SIZE, (%ebx)
	je		end
	cmpl	$0, 4(%ebx)
	je		end
	cmpl	$SCREEN_SIZE, 4(%ebx)
	je		end
	
######################### Collision with body ##########################
	#Looping through and testing collision with body
	movl	currentLength, %ecx
	collisionBody:	
	pushl	%ecx
	cmpl	$1, %ecx
	je		collisionBodyDone
			
		xorl	%eax, %eax
			
		movl	$body, %ebx 				#ebx = apples address
		movl	%ecx, %eax
		movl	$8, %ecx
		mull	%ecx
		addl	%eax, %ebx					#ebx = 8 * i + ebx
											#ebx is now the address of an apple
		movl	$body, %eax					#eax is the address of the head
		
		
		movl	(%eax), %ecx				#Check apple position X with head X
		cmpl	%ecx, -8(%ebx)
		jne		notEqual2
		
		movl	4(%eax), %ecx				#Check apple position Y with head Y
		cmpl	%ecx, -4(%ebx)
		jne		notEqual2
				
											#If X and Y is equal, move apple
		jmp		end
		
		
	notEqual2:		
	popl	%ecx
	
	loop	collisionBody
	
collisionBodyDone:

######################### Collision with apples ########################
	movl	$0, hit
	movl	nrOfApples, %ecx
	collisionApples:	
	pushl	%ecx
			
		xorl	%eax, %eax
			
		movl	$apples, %ebx 				#ebx = apples address
		movl	%ecx, %eax
		movl	$8, %ecx
		mull	%ecx
		addl	%eax, %ebx					#ebx = 8 * i + ebx
											#ebx is now the address of an apple
		movl	$body, %eax					#eax is the address of the head
		
		
		movl	(%eax), %ecx				#Check apple position X with head X
		cmpl	%ecx, -8(%ebx)
		jne		notEqual
		
		movl	4(%eax), %ecx				#Check apple position Y with head Y
		cmpl	%ecx, -4(%ebx)
		jne		notEqual
				
											#If X and Y is equal, move apple
		movl	$1, hit
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
		
		jmp		growBody
	
	notEqual:		
	popl	%ecx		
	loop	collisionApples
	jmp 	updateBody
	
	growBody:								#Apple was eaten, grow the worm
	cmpl	$1, hit
	jne		updateBody
	
	movl	$body, %ebx 				
	movl	currentLength, %eax
	movl	$8, %ecx
	mull	%ecx
	addl	%eax, %ebx						
											#ebx is now the address of the new body part
	
	movl	-4(%ebx), %eax				#eax = y-value from previous body part
	movl	-8(%ebx), %ecx				#ecx = x-value from previous body part
			
	movl	%ecx, (%ebx)				#set new x-value to ecx
	movl	%eax, 4(%ebx)				#set new y-value to eax
	
############################# Update body ##############################
	updateBody:
	#Looping through and moving the rest of the body
	movl	currentLength, %ecx
	moveBody:		
	pushl	%ecx
			
		xorl	%eax, %eax
		xorl	%edx, %edx
			
		movl	$body, %ebx 				#ebx = body address
		movl	%ecx, %eax
		movl	$8, %ecx
		mull	%ecx
		addl	%eax, %ebx					#ebx = 8 * i + ebx
												#ebx is now the address of a body part
		
		movl	-4(%ebx), %eax				#eax = y-value from previous body part
		movl	-8(%ebx), %ecx				#ecx = x-value from previous body part
			
		movl	%ecx, (%ebx)				#set new x-value to ecx
		movl	%eax, 4(%ebx)				#set new y-value to eax
	
	popl	%ecx
	cmpl	$1, %ecx	
	je  	moveBodyDone
	loop moveBody
	
	moveBodyDone:
	
	movl	$body, %ebx						

	cmpl	$KEY_UP, input
	je 		moveUp
	
	cmpl	$KEY_RIGHT, input
	je 		moveRight
	
	cmpl	$KEY_DOWN, input
	je 		moveDown
	
	cmpl	$KEY_LEFT, input
	je 		moveLeft
											#Move head
	moveUp:
		decl	4(%ebx)
		jmp endMove
	moveRight:
		incl	(%ebx)
		jmp endMove	
	moveDown:
		incl	4(%ebx)
		jmp endMove	
	moveLeft:
		decl	(%ebx)
		jmp endMove
		
	
	endMove:
	
	cmpl	$1, hit
	jne		noHit
	incl	currentLength
	
	noHit:
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
	xorl	%ecx, %ecx
	drawBody:		
	pushl	%ecx
			
		xorl	%eax, %eax
			
		movl	$body, %ebx 				#ebx = body address
		movl	%ecx, %eax
		movl	$8, %ecx
		mull	%ecx
		addl	%eax, %ebx					#ebx = 8 * i + ebx
											#ebx is now the address of a body part
		
		pushl	$WORM_CHAR
		pushl   4(%ebx)						#y
		pushl   (%ebx)						#x
		call	nib_put_scr	
		addl	$12, %esp
	
	popl	%ecx
	incl	%ecx
	cmpl currentLength, %ecx	
	jne drawBody
	
############################# Draw borders #############################
	movl $SCREEN_SIZE, %ecx
	drawBorders:
	pushl	%ecx
	
		movl	%ecx, %ebx
			
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
	
############################## Get input ###############################

	movl	$10, %ecx
	xorl	%eax, %eax

	inputLoop:								#Check for input during sleep
	pushl %ecx	
		
		pushl	$10000
		call 	usleep
		addl	$4, %esp
	
		call	nib_poll_kbd
		
		cmpl	$KEY_UP, %eax
		je		registerInput
		
		cmpl	$KEY_RIGHT, %eax
		je		registerInput
		
		cmpl	$KEY_DOWN, %eax
		je		registerInput
		
		cmpl	$KEY_LEFT, %eax
		je		registerInput
		
	popl	%ecx
	loop inputLoop

	jmp	skipInput
	
	registerInput:							#If input is registered, set input variable
		movl	%eax, input
	
	skipInput:
	
	movl	$10, %ebx
	subl	%ecx, %ebx
	
	movl	$10000, %eax
	mull	%ebx
	
	pushl	%eax
	call 	usleep
	addl	$4, %esp
	call	clear
jmp mainLoop

############################### End game ###############################	
end:
	call	nib_end

