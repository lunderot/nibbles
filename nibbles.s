.section .text
.globl start_game
start_game:
	pop		%eax
	pop		%eax
	
	call	nib_init
	
	pushl	$0
	pushl	$0
	pushl	$104
	call	nib_put_scr
	
	call	nib_end

