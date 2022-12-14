# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

# Provide a convenient way to create a Verilog source of Ibex.
# This is used by riscv-formal. See README.md for more details.

IBEX_ENABLE_WB ?= 0

# Name of the output file
IBEX_OUT := ibex.v
# Build folder name
OUTDIR   := build

# Source directory relative to this Makefile
SRC_DIR  := ../../rtl

# Synthesis source directory relative to this Makefile
SYN_DIR  := ../../syn

# Vendored IP directory relative to this Makefile
LOWRISC_IP := ../../vendor/lowrisc_ip

# Include directories relative to this Makefile
INC_DIRS :=                    \
  $(LOWRISC_IP)/ip/prim/rtl    \
  $(LOWRISC_IP)/dv/sv/dv_utils

# SystemVerilog sources of Ibex
SRCS_SV ?=                              \
  $(SRC_DIR)/ibex_alu.sv                \
  $(SRC_DIR)/ibex_compressed_decoder.sv \
  $(SRC_DIR)/ibex_controller.sv         \
  $(SRC_DIR)/ibex_counter.sv            \
  $(SRC_DIR)/ibex_csr.sv                \
  $(SRC_DIR)/ibex_cs_registers.sv       \
  $(SRC_DIR)/ibex_decoder.sv            \
  $(SRC_DIR)/ibex_ex_block.sv           \
  $(SRC_DIR)/ibex_fetch_fifo.sv         \
  $(SRC_DIR)/ibex_id_stage.sv           \
  $(SRC_DIR)/ibex_if_stage.sv           \
  $(SRC_DIR)/ibex_load_store_unit.sv    \
  $(SRC_DIR)/ibex_multdiv_fast.sv       \
  $(SRC_DIR)/ibex_multdiv_slow.sv       \
  $(SRC_DIR)/ibex_prefetch_buffer.sv    \
  $(SRC_DIR)/ibex_pmp.sv                \
  $(SRC_DIR)/ibex_register_file_ff.sv   \
  $(SRC_DIR)/ibex_wb_stage.sv           \
  $(SRC_DIR)/ibex_xif_issue_commit_buffer.sv \
  $(SRC_DIR)/ibex_core.sv               \
  $(SRC_DIR)/ibex_top.sv

PKGS ?=                                        \
  $(SRC_DIR)/ibex_pkg.sv                       \
  $(LOWRISC_IP)/ip/prim/rtl/prim_ram_1p_pkg.sv

PRIM_CLOCK ?= $(SYN_DIR)/rtl/prim_clock_gating.v

GEN_V := $(patsubst %.sv,%.v,$(patsubst $(SRC_DIR)%,$(OUTDIR)%,$(SRCS_SV)))

all: $(IBEX_OUT)

verilog: $(GEN_V)

$(OUTDIR):
	mkdir -p $(OUTDIR)

# Convert each SystemVerilog source into a Verilog file
$(GEN_V): $(OUTDIR)%.v: $(SRC_DIR)%.sv $(PKGS) | $(OUTDIR)
	sv2v --define=RISCV_FORMAL $(addprefix -I,$(INC_DIRS)) $(PKGS) \
		$< > $@

# Combine multiple Verilog sources into one Ibex Verilog file
# Disable "M" extension
$(IBEX_OUT): $(GEN_V) $(PRIM_CLOCK)
	yosys -p "read_verilog $(PRIM_CLOCK) $(GEN_V)"                     \
	      -p "chparam -set RV32M 0 ibex_top"                           \
	      -p "chparam -set WritebackStage $(IBEX_ENABLE_WB) ibex_top"  \
	      -p "synth -top ibex_top"                                     \
	      -p "write_verilog $(IBEX_OUT)"

.PHONY: clean
clean:
	-rm -rf $(IBEX_OUT) $(OUTDIR)
