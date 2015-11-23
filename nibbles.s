.section .text
.globl start_game
start_game:
	pop		%eax
	pop		%eax
	
	call	nib_init
	
label:
	pushl	$104
	pushl	$10
	pushl	$10
	
	call	nib_put_scr
	jmp		label
	
	call	nib_end

