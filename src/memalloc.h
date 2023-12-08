// SPDX-License-Identifier: 0BSD
/*
 * Copyright (C) 2023 Michael T. Kloos <michael@michaelkloos.com>
 */

#ifndef _HEADER_MEMALLOC_H
#define _HEADER_MEMALLOC_H

#include <types.h>

void* malloc(size_t size);
void free(void* ptr);

//void __allocinit(void* block_start, void* block_end);

#endif
