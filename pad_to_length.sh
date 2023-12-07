#!/bin/bash

# SPDX-License-Identifier: 0BSD
#
# Copyright (C) 2023 Michael T. Kloos <michael@michaelkloos.com>
#

set -e

FSIZE=$(stat --printf="%s" $1)
DIV=$(($FSIZE / 512))
MOD=$(($FSIZE % 512))
if [ $MOD -ne 0 ]; then
	FSIZE=$((($DIV + 1) * 512))
fi

cp $1 $2
truncate -s $FSIZE $2

exit 0
