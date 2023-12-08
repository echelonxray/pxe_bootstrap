// SPDX-License-Identifier: 0BSD
/*
 * Copyright (C) 2023 Michael T. Kloos <michael@michaelkloos.com>
 */

#ifndef _HEADER_ENTRY_H
#define _HEADER_ENTRY_H

#include <types.h>

typedef struct {
	uint64_t base_address;
	uint64_t length;
	uint32_t type;
	uint32_t extended_attributes;
} BiosMemoryEntry;

void biosprintchar(char c);
unsigned short a20_enabled();
unsigned int get_biosmemorymap(BiosMemoryEntry* entries, unsigned int* entry_size, unsigned int* count);

#endif
