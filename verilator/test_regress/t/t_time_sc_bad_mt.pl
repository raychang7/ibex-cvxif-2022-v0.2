#!/usr/bin/env perl
if (!$::Driver) { use FindBin; exec("$FindBin::Bin/bootstrap.pl", @ARGV, $0); die; }
# DESCRIPTION: Verilator: Verilog Test driver/expect definition
#
# Copyright 2003 by Wilson Snyder. This program is free software; you
# can redistribute it and/or modify it under the terms of either the GNU
# Lesser General Public License Version 3 or the Perl Artistic License
# Version 2.0.
# SPDX-License-Identifier: LGPL-3.0-only OR Artistic-2.0

scenarios(vltmt => 1);

top_filename("t/t_time_sc.v");

$Self->{sc_time_resolution} = 'SC_NS';

compile(
    verilator_flags2 => ['-sc', '-timescale 1ps/1ps',  # Mismatch w/sc_time_resolution
                         '+define+TEST_EXPECT=2us'],
    threads => 2,
    );

execute(
    fails => 1,
    expect_filename => $Self->{golden_filename},
    );

ok(1);

1;
