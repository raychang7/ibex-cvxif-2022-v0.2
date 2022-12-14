// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain, for
// any use, without warranty, 2003 by Wilson Snyder.
// SPDX-License-Identifier: CC0-1.0

module t;
   initial begin
      // Display formatting
      $display("%c", 32'h1234);  // Bad wide %c
      $write("*-* All Finished *-*\n");
      $finish;
   end
endmodule
