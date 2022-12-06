# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Generate a baremetal application

# Name of the program $(PROGRAM).c will be added as a source file
PROGRAM = bench
PROGRAM_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
# Any extra source files to include in the build. Use the upper case .S
# extension for assembly files
EXTRA_SRCS :=

include ${PROGRAM_DIR}/../common/common.mk


# random numbers are generated with this python program:
# import numpy as np 
# def gen_rand(seed):
#     np.random.seed(seed)
#     return np.random.random(1000) * 1000

# x = gen_rand(42)
# y = gen_rand(69)