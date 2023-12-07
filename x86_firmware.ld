/* SPDX-License-Identifier: 0BSD */
/*
 * Copyright (C) 2023 Michael T. Kloos <michael@michaelkloos.com>
 */

/*
This is not actually needed (At least not on actual hardware.), but 
it explicitly sets the entry point in the .elf file to be the same 
as the true entry point to the program. The global symbol my_entry_pt
is located in src/kernel/kstart_entry.s.  More on this below.
*/
ENTRY(my_entry_pt)

MEMORY
{
	/*
	The actual RAM (DDR) is mapped starting at memory:   0x0000_0000_8000_0000.
	There are 16GB onboard the SiFive Unmatched.  16GB = 0x0000_0004_0000_0000.
	*/
	ram   (rwx) : ORIGIN = 0x0000, LENGTH = 0x78400
}

SECTIONS
{
	/*
	Inform the linker to start at the beginning of RAM
	*/
	. = ORIGIN(ram);
	
	/*
	Inform the linker that .text section will be linked first
	*/
	.text : {
		*.o (entry_text);
		
		/*
		Link the rest of the kernel's .text sections.
		*/
		*.o (.text);
		*.o (.text.*);
	} > ram
	
	/*
	Create a TLS data block image
	*/
	/*
	section_THREAD_INIT_tdata : {
		THI_START = .;
		THI_tdata_START = .;
		*.o (.tdata);
		THI_tdata_END = .;
	} > ram
	section_THREAD_INIT_tbss (NOLOAD) : {
		THI_tbss_START = .;
		*.o (.tbss);
		THI_tbss_END = .;
		THI_END = .;
	} > ram
	*/
	
	.rodata : {
		*.o (.rodata);
		*.o (.rodata.*);
		*.o (.srodata);
		*.o (.srodata.*);
	} > ram
	
	/*
	Next, make room for the global variables in RAM.
	*/
	.sdata : {
		*.o (.sdata);
	} > ram
	.data : {
		*.o (.data);
	} > ram
	.sbss : {
		*.o (.sbss);
	}
	.bss : {
		*.o (.bss);
	}
	
	.shstrtab : {
		* (.shstrtab);
	}
	
	/*
	Discard everything that hasn't be explicitly linked.  I don't
	want the linker to guess where to put stuff.  If it doesn't know, 
	don't include it.  If this causes a linking error, good!  I want
	to know that I need to fix something, rather than a silent failure 
	that could cause hard to debug issues later.  For instance, 
	without explicitly setting the .sbss and .bss sections above, 
	the linker attempted to put my global variables after the 
	machine code in the flash when I was working on a FE310-G002 SOC
	with a different linker setup.  This would have meant that every
	access to those variables would result in a read or a write to the
	memory-mapped	external SPI flash IC on real hardware.  I also do
	not believe that initialized global variables are possible since
	there is nothing to initialize them.  So I don't want to, for
	instance, include the .data section.  If I get a linking error
	regarding that section, I will know to look for a bug in my code
	where I may have mistakenly used an initialized global variable.
	*/
	/DISCARD/ : {
		* (.*);
	}
}
