// SPDX-License-Identifier: 0BSD
/*
 * Copyright (C) 2023 Michael T. Kloos <michael@michaelkloos.com>
 */

/*
32-bit x86 ABI
	%ax - caller saved
	%bx - callee-saved
	%cx - caller saved
	%dx - caller saved
	%sp - callee saved
	%bp - callee saved
	%si - callee saved
	%di - callee saved
*/

.section entry_text

.code16

.global my_entry_pt
.global biosprintchar
.global a20_enabled

my_entry_pt:
	xor %EAX, %EAX
	xor %ESP, %ESP
	movw $0x07C0, %AX
	mov %AX, %DS
	mov %AX, %ES
	mov %AX, %FS
	mov %AX, %GS
	mov %AX, %SS
	movw $0xFFF0, %SP
	calll main
	1: jmp 1b

biosprintchar:
	pushl %EBX
	xor  %EAX, %EAX
	xor  %ECX, %ECX
	xor  %EDX, %EDX
	xor  %EBX, %EBX
	movb 0x8(%ESP), %AL
	movb $0x0E, %AH
	int $0x10
	popl %EBX
	retl

a20_enabled:
	pushf
	push %BX
	push %SI
	push %DI
	push %FS
	push %GS
	xor %EAX, %EAX
	mov a20check, %AX
	add $0x7C00, %AX // We are telling the linker that we are at base address 0, even though this is actually at 0x7C00.
	                // Ordinarly we correct this with the segment registers.  But since we are temporarily changing them,
	                // we need to manually correct the memory offset.
	xor %EDX, %EDX
	mov $0x1, %DI
	cli
	mov %DX, %FS
	not %DX
	mov %DX, %GS
	mov %EAX, %EDX
	add $0x10, %EDX
	movw %FS:(%EAX), %BX
	movw %GS:(%EDX), %CX
	cmp %BX,%CX
	jnz 1f // a20 Enabled (Not Equal).
		// Equal, but we need to double check that this is not a coincidence.
		// So, write a different value and see if it still matches.
		mov $0x4321, %SI
		movw %SI, %FS:(%EAX)
		movw %GS:(%EDX), %CX
		cmp %SI,%CX
		jnz 1f // a20 Enabled (Not Equal).  It was a coincidence.
			// a20 is Disabled. (Equal)
			xor %DI, %DI
	1:     // a20 Enabled
	movw %BX, %FS:(%EAX)
	mov %DI, %AX
	pop %GS
	pop %FS
	pop %DI
	pop %SI
	pop %BX
	popf
	retl

a20check: .short 0x1234