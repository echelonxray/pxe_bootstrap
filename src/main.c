// SPDX-License-Identifier: 0BSD
/*
 * Copyright (C) 2023 Michael T. Kloos <michael@michaelkloos.com>
 */

#include "main.h"
#include <entry.h>
#include <types.h>
#include <string.h>
#include <memalloc.h>
#include <printm.h>

void main() {
	printm("Hello, World!\n");
	
	char* answer;
	if (a20_enabled()) {
		answer = "Yes";
	} else {
		answer = "No";
	}
	printm("Is a20 Enabled? %s\n", answer);
	
	unsigned int count = 1234;
	unsigned int entry_size = 0;
	unsigned short retval;
	retval = get_biosmemorymap(NULL, &entry_size, &count);
	if (retval) {
		printm("get_biosmemorymap(): Error\n");
		return;
	}
	printm("Memory Entry Count: %u\n", count);
	printm("Memory Entry Size:  %u\n", entry_size);
	BiosMemoryEntry* mementries;
	mementries = malloc(sizeof(*mementries) * count);
	if (mementries == NULL) {
		printm("malloc(): Error\n");
		return;
	}
	memset(mementries, 0, sizeof(*mementries) * count);
	retval = get_biosmemorymap(mementries, &entry_size, &count);
	
	printm("\n");
	printm("Memory Entry Count: %u\n", count);
	printm("Memory Entry Size:  %u\n", entry_size);
	printm("Memory Entries\n");
	for (unsigned int i = 0; i < count; i++) {
		printm("\tEntry: 0x%08X | 0x%08X | 0x%08X | 0x%08X\n", (unsigned int)mementries[i].base_address, 
		                                                       (unsigned int)mementries[i].length, 
		                                                       (unsigned int)mementries[i].type, 
		                                                       (unsigned int)mementries[i].extended_attributes);
	}
	
	free(mementries);
	
	return;
}
