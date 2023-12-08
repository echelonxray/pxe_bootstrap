// SPDX-License-Identifier: 0BSD
/*
 * Copyright (C) 2023 Michael T. Kloos <michael@michaelkloos.com>
 */

/*
32-bit x86 ABI (Same for 16-bit)
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
.global get_biosmemorymap

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
	jnz 1f // Not Equal (a20 Enabled)
		// Equal
		// But we need to double check that this is not a coincidence.
		// So, write a different value and see if it still matches.
		mov $0x4321, %SI
		movw %SI, %FS:(%EAX)
		movw %GS:(%EDX), %CX
		cmp %SI,%CX
		jnz 1f // Not Equal (a20 Enabled) - It was a coincidence.
			// Equal
			// a20 is Disabled.
			xor %DI, %DI
	1:
	movw %BX, %FS:(%EAX)
	mov %DI, %AX
	pop %GS
	pop %FS
	pop %DI
	pop %SI
	pop %BX
	popf
	retl

get_biosmemorymap:
	movl 0x4(%ESP), %EAX
	push %EBX
	push %EBP
	push %SI
	push %DI
	push %EAX
	xor %EBP, %EBP
	xor %SI, %SI
	sub $0x18, %SP
	mov %SP, %DI
	sub $0x1, %SP
	
	xor %EBX, %EBX
	movl $0x534D4150, %EDX
	3:
	movl $0xE820, %EAX
	movl $0x18, %ECX
	int $0x15
	cmp $0x534D4150, %EAX
	jnz 1f // Goto: Error
	cmp $0x0, %EBX
	jz 4f // Goto: End of list
	movb %CL, (%ESP)
	// Get Pointer
	movl 0x19(%ESP), %EAX
	cmp $0x0, %EAX
	jz 5f // Pointer is NULL, skip the data copy.
	// Copy Entry
	// 1st: 8 Bytes
	movl 0x01(%ESP), %ECX
	movl %ECX, 0x00(%EAX)
	movl 0x05(%ESP), %ECX
	movl %ECX, 0x04(%EAX)
	// 2nd: 8 Bytes
	movl 0x09(%ESP), %ECX
	movl %ECX, 0x08(%EAX)
	movl 0x0D(%ESP), %ECX
	movl %ECX, 0x0C(%EAX)
	// 3rd: 8 Bytes
	movl 0x11(%ESP), %ECX
	movl %ECX, 0x10(%EAX)
	movl 0x15(%ESP), %ECX
	movl %ECX, 0x14(%EAX)
	// Increment Pointer
	add $0x18, %EAX
	movl %EAX, 0x19(%ESP)
	5:
	inc %BP
	jmp 3b
	
	4: // End of list
	// Store Count (%BP)
	movl 0x35(%ESP), %EAX
	cmp $0x0, %EAX
	jz 6f // Pointer is NULL, skip the store count.
	movl %EBP, (%EAX)
	6:
	cmp $0x0, %BP
	jz 2f
	// Store Entry Size (%CL)
	movl 0x31(%ESP), %EAX
	cmp $0x0, %EAX
	jz 2f // Pointer is NULL, skip the entry size.
	movzbl %CL, %ECX
	movl %ECX, (%EAX)
	jmp 2f
	
	1: // Error
	mov $0x1, %SI
	
	2: // Clean Up
	add $0x1D, %SP
	//xor %EAX, %EAX
	//mov %SI, %AX
	pop %DI
	pop %SI
	pop %EBP
	pop %EBX
	retl

a20check: .short 0x1234
