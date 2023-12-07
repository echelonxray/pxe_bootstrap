// SPDX-License-Identifier: 0BSD
/*
 * Copyright (C) 2023 Michael T. Kloos <michael@michaelkloos.com>
 */

#include "math.h"

#ifdef NEED_LLMATH

#define ULL_MSB  (((unsigned long long)1) <<  63)

signed long long __muldi3(signed long long a, signed long long b) {
	unsigned long long ua;
	unsigned long long ub;
	unsigned long long j;
	unsigned int i;
	signed long long r;

	ua = a;
	ub = b;

	j = 0;
	for (i = 0; i < sizeof(signed long long) * 8; i++) {
		if (!ua || !ub) {
			break;
		}
		if (ua & 0x1) {
			j += ub;
		}
		ua >>= 1;
		ub <<= 1;
	}

	r = j;

	return r;
}

signed long long __divdi3(signed long long a, signed long long b) {
	unsigned long long ua;
	unsigned long long ub;
	unsigned long long j;
	unsigned int i;
	signed long long r;

	if (b == 0) {
		return (signed long long)(-1);
	}

	ua = a;
	ub = b;
	if (a < 0) {
		ua = -a;
	}
	if (b < 0) {
		ub = -b;
	}

	j = 0;
	i = 0;
	while (ua >= ub) {
		if (ub & ULL_MSB) {
			ua -= ub;
			j |= 1ull << i;
			break;
		}
		ub <<= 1;
		i++;
	}
	while (i > 0) {
		i--;
		ub >>= 1;
		if (ua >= ub) {
			ua -= ub;
			j |= 1ull << i;
		}
	}

	r = j;
	if ((a < 0) != ((b < 0))) {
		r = -r;
	}

	return r;
}
unsigned long long __udivdi3(unsigned long long a, unsigned long long b) {
	unsigned long long j;
	unsigned long long i;

	if (b == 0) {
		return (signed long long)(-1);
	}

	j = 0;
	i = 0;
	while (a >= b) {
		if (b & ULL_MSB) {
			a -= b;
			j |= 1ull << i;
			break;
		}
		b <<= 1;
		i++;
	}
	while (i > 0) {
		i--;
		b >>= 1;
		if (a >= b) {
			a -= b;
			j |= 1ull << i;
		}
	}

	return j;
}

signed long long __moddi3(signed long long a, signed long long b) {
	unsigned long long ua;
	unsigned long long ub;
	unsigned int i;
	signed long long r;

	if (b == 0) {
		return a;
	}

	ua = a;
	ub = b;
	if (a < 0) {
		ua = -a;
	}
	if (b < 0) {
		ub = -b;
	}

	i = 0;
	while (ua >= ub) {
		if (ub & ULL_MSB) {
			ua -= ub;
			break;
		}
		ub <<= 1;
		i++;
	}
	while (i > 0) {
		i--;
		ub >>= 1;
		if (ua >= ub) {
			ua -= ub;
		}
	}

	r = ua;
	if (a < 0) {
		r = -r;
	}

	return r;
}
unsigned long long __umoddi3(unsigned long long a, unsigned long long b) {
	unsigned long long i;

	if (b == 0) {
		return a;
	}

	i = 0;
	while (a >= b) {
		if (b & ULL_MSB) {
			a -= b;
			break;
		}
		b <<= 1;
		i++;
	}
	while (i > 0) {
		i--;
		b >>= 1;
		if (a >= b) {
			a -= b;
		}
	}

	return a;
}

#endif
