// SPDX-License-Identifier: 0BSD
/*
 * Copyright (C) 2023 Michael T. Kloos <michael@michaelkloos.com>
 */

#ifndef _HEADER_MATH_H
#define _HEADER_MATH_H

#if   __SIZE_WIDTH__ == 32
	#define   NEED_LLMATH
#elif __SIZE_WIDTH__ == 64
	#undef    NEED_LLMATH
#else
	#error "Unsupported Size"
#endif

#ifdef NEED_LLMATH
signed long long __muldi3(signed long long a, signed long long b);
signed long long __divdi3(signed long long a, signed long long b);
unsigned long long __udivdi3(unsigned long long a, unsigned long long b);
signed long long __moddi3(signed long long a, signed long long b);
unsigned long long __umoddi3(unsigned long long a, unsigned long long b);
#endif

#ifdef NEED_LLMATH
	#define  mul_ll(arg1, arg2) ( __muldi3(arg1, arg2))
	#define  div_ll(arg1, arg2) ( __divdi3(arg1, arg2))
	#define udiv_ll(arg1, arg2) (__udivdi3(arg1, arg2))
	#define  mod_ll(arg1, arg2) ( __moddi3(arg1, arg2))
	#define umod_ll(arg1, arg2) (__umoddi3(arg1, arg2))
#else
	#define  mul_ll(arg1, arg2) (arg1 * arg2)
	#define  div_ll(arg1, arg2) (arg1 / arg2)
	#define udiv_ll(arg1, arg2) (arg1 / arg2)
	#define  mod_ll(arg1, arg2) (arg1 % arg2)
	#define umod_ll(arg1, arg2) (arg1 % arg2)
#endif

#endif
