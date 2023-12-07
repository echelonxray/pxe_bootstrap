// SPDX-License-Identifier: 0BSD
/*
 * Copyright (C) 2023 Michael T. Kloos <michael@michaelkloos.com>
 */

#include "main.h"
#include <entry.h>
#include <printm.h>

void main() {
	printm("Hello, World!\n");
	printm("ABC-0 %u\n", (unsigned int)a20_enabled());
	printm("ABC-1 %u\n", (unsigned int)0);
	printm("ABC-2 %u\n", (unsigned int)1);
	return;
}
