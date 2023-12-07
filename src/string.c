// SPDX-License-Identifier: 0BSD
/*
 * Copyright (C) 2023 Michael T. Kloos <michael@michaelkloos.com>
 */

#include "string.h"
#include <types.h>

void* memmove(void* dest, const void* src, size_t n) {
	unsigned char* dest_data = dest;
	const unsigned char* src_data = src;
	while (n > 0) {
		n--;
		dest_data[n] = src_data[n];
	}
	return dest;
}
void* memcpy(void* restrict dest, const void* restrict src, size_t n) {
	unsigned char* dest_data = dest;
	const unsigned char* src_data = src;
	while (n > 0) {
		n--;
		dest_data[n] = src_data[n];
	}
	return dest;
}
void* memset(void* s, int c, size_t n) {
	unsigned char* ptr = s;
	for (size_t i = 0; i < n; i++) {
		ptr[i] = (unsigned char)c;
	}
	return s;
}

size_t strlen(const char* str) {
	size_t i = 0;
	while (str[i] != '\0') {
		i++;
	}
	return i;
}
size_t strnlen(const char* str, size_t maxlen) {
	size_t i = 0;
	while (i < maxlen) {
		if (str[i] == '\0') {
			break;
		}
		i++;
	}
	return i;
}

char* stpcpy(char* restrict dst, const char* restrict src) {
	size_t i = 0;
	while (1) {
		dst[i] = src[i];
		if (src[i] == '\0') {
			break;
		}
		i++;
	}
	return dst + i;
}
char* strcpy(char* restrict dst, const char* restrict src) {
	size_t i = 0;
	do {
		dst[i] = src[i];
	} while (src[i++] != '\0');
	return dst;
}
char* strcat(char* restrict dst, const char* restrict src) {
	strcpy(dst + strlen(dst), src);
	return dst;
}

char* stpncpy(char* restrict dst, const char* restrict src, size_t sz) {
	size_t i = 0;
	while (i < sz) {
		dst[i] = src[i];
		if (src[i] == '\0') {
			break;
		}
		i++;
	}
	return dst + i;
}
char* strncpy(char* restrict dst, const char* restrict src, size_t sz) {
	size_t i = 0;
	while (i < sz) {
		dst[i] = src[i];
		if (src[i] == '\0') {
			break;
		}
		i++;
	}
	return dst;
}

// These functions DO NOT CONFORM to their standard implementations
// regarding if strings less than or greater than each other.
// These only check if a string is equal or not.  This is usually
// all that is needed, but if that additional functionality is ever
// required, these will need to be replaced.
signed int strcmp(const char* s1, const char* s2) {
	while (*s1 == *s2) {
		if (*s1 == '\0') {
			return 0;
		}
		s1++;
		s2++;
	}
	return 1;
}
signed int strncmp(const char* s1, const char* s2, size_t n) {
	for (size_t i = 0; i < n; i++) {
		if (s1[i] != s2[i]) {
			return 1;
		}
		if (s1[i] == '\0') {
			break;
		}
	}
	return 0;
}
