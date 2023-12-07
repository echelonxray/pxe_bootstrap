.section entry_text

.code16

.global my_entry_pt
.global biosprintchar

my_entry_pt:
	xor %EAX, %EAX
	xor %ESP, %ESP
	movw $0x07C0, %AX
	mov %AX, %DS
	mov %AX, %ES
	mov %AX, %FS
	mov %AX, %GS
	#movw $0x7000, %AX
	mov %AX, %SS
	movw $0xFFF0, %SP
	calll c_func
	1: jmp 1b

biosprintchar:
	xor  %EAX, %EAX
	xor  %ECX, %ECX
	xor  %EDX, %EDX
	pushl %EBX
	xor  %EBX, %EBX
	movb 0x8(%ESP), %AL
	movb $0x0E, %AH
	int $0x10
	popl %EBX
	retl
