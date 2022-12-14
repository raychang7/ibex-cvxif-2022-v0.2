#!/usr/bin/env perl
if (!$::Driver) { use FindBin; exec("$FindBin::Bin/bootstrap.pl", @ARGV, $0); die; }
# DESCRIPTION: Verilator: Verilog Test driver/expect definition
#
# Copyright 2008 by Wilson Snyder. This program is free software; you
# can redistribute it and/or modify it under the terms of either the GNU
# Lesser General Public License Version 3 or the Perl Artistic License
# Version 2.0.
# SPDX-License-Identifier: LGPL-3.0-only OR Artistic-2.0

scenarios(vlt => 1);

lint(
    verilator_flags2 => [qw(--lint-only --future0 thefuture --future1 thefuturei --thefuture -thefuture +thefuture --thefuturei 1 -Wfuture-FUTURE1 -Wfuture-FUTURE2)],
    );

ok(1);
1;
