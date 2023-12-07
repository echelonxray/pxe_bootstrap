// SPDX-License-Identifier: 0BSD
/*
 * Copyright (C) 2023 Michael T. Kloos <michael@michaelkloos.com>
 */

#ifndef _HEADER_VAR_ARGS_H
#define _HEADER_VAR_ARGS_H

typedef __builtin_va_list va_list;

#define va_start(p1, p2) __builtin_va_start(p1, p2)
#define va_arg(p1, p2) __builtin_va_arg(p1, p2)
#define va_copy(p1, p2) __builtin_va_copy(p1, p2)
#define va_end(p1) __builtin_va_end(p1)

#endif
