#!/usr/bin/env perl
if (!$::Driver) { use FindBin; exec("$FindBin::Bin/bootstrap.pl", @ARGV, $0); die; }
# DESCRIPTION: Verilator: Verilog Test driver/expect definition
#
# Copyright 2003 by Wilson Snyder. This program is free software; you
# can redistribute it and/or modify it under the terms of either the GNU
# Lesser General Public License Version 3 or the Perl Artistic License
# Version 2.0.
# SPDX-License-Identifier: LGPL-3.0-only OR Artistic-2.0
use IO::File;

# Very slow on vltmt, and doesn't test much of value there, so disabled
scenarios(vlt => 1);

sub gen {
    my $filename = shift;
    my $n = shift;

    my $fh = IO::File->new(">$filename");
    $fh->print("// Generated by t_emit_memb_limit.pl\n");
    $fh->print("module t (i, clk, o);\n");
    $fh->print("  input clk;\n");
    $fh->print("  input i;\n");
    $fh->print("  output logic o;\n");
    for (my $i = 0; $i < ($n + 1); ++$i) {
        $fh->print("  logic r$i;\n");
    }
    $fh->print("  always @ (posedge clk) begin\n");
    $fh->print("    r0 <= i;\n");
    for (my $i = 1; $i < $n; ++$i) {
        $fh->print("    r" . ($i+1) . " <= r$i;\n");
    }
    $fh->print("    o <= r$n;\n");
    $fh->print('    $write("*-* All Finished *-*\n");', "\n");
    $fh->print('    $finish;', "\n");
    $fh->print("  end\n");
    $fh->print("endmodule\n");
}

top_filename("$Self->{obj_dir}/t_emit_memb_limit.v");

# Current limit is 50, so want to test at least 50*50 cases
gen($Self->{top_filename}, 6000);

compile(
    verilator_flags2=>["-x-assign fast --x-initial fast",
                       "-Wno-UNOPTTHREADS",
                       # The slow V3Partition asserts are just too slow
                       # in this test. They're disabled just for performance
                       # reasons:
                       "--no-debug-partition"],
    );

execute(
    check_finished => 1,
    );

file_grep("$Self->{obj_dir}/$Self->{VM_PREFIX}___024root.h", qr/struct \{/);

ok(1);
1;
