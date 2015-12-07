.section .text
.globl _start
_start:
	pushl $10
	pushl $10
	call start_game
    pushl $0
    call  exit
