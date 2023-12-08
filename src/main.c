// SPDX-License-Identifier: 0BSD
/*
 * Copyright (C) 2023 Michael T. Kloos <michael@michaelkloos.com>
 */

#include "main.h"
#include <entry.h>
#include <types.h>
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
	unsigned short retval;
	retval = get_biosmemorymap(NULL, NULL, &count);
	if (retval) {
		printm("get_biosmemorymap(): Error\n");
		return;
	}
	printm("Memory Entry Count: %u\n", count);
	return;
}
