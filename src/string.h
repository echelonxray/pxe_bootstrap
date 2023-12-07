// SPDX-License-Identifier: 0BSD
/*
 * Copyright (C) 2023 Michael T. Kloos <michael@michaelkloos.com>
 */

#ifndef _HEADER_STRING_H
#define _HEADER_STRING_H

#include <types.h>

void* memmove(void* dest, const void* src, size_t n);
void* memcpy(void* restrict dest, const void* restrict src, size_t n);
void* memset(void* s, int c, size_t n);

size_t strlen(const char* str);
size_t strnlen(const char* str, size_t maxlen);

char* stpcpy(char* restrict dst, const char* restrict src);
char* strcpy(char* restrict dst, const char* restrict src);
char* strcat(char* restrict dst, const char* restrict src);

char* stpncpy(char* restrict dst, const char* restrict src, size_t sz);
char* strncpy(char* restrict dst, const char* restrict src, size_t sz);

signed int strcmp(const char* s1, const char* s2);
signed int strncmp(const char* s1, const char* s2, size_t n);

#endif
