module tb_tinyfpu_cvxif import ibex_pkg::*;();

	reg clk_i = 0; 
	reg rst_ni;
	reg x_issue_valid_i = 1;
	wire x_issue_ready_o;
	x_issue_req_t x_issue_req_i;
	x_issue_resp_t x_issue_resp_o;
	wire x_result_valid_o;
	reg x_result_ready_i = 1;
	x_result_t x_result_o;

	always #5 clk_i = ~clk_i;	

	tinyfpu_cvxif dut(
		.clk_i (clk_i),
		.rst_ni (rst_ni),
		.x_issue_valid_i (x_issue_valid_i),
		.x_issue_ready_o (x_issue_ready_o),
		.x_issue_req_i (x_issue_req_i),
		.x_issue_resp_o (x_issue_resp_o),
		.x_result_valid_o (x_result_valid_o),
		.x_result_ready_i (x_result_ready_i),
		.x_result_o (x_result_o)
	);

	initial begin
		x_issue_req_i.instr <= 32'b00000000001000001000000111010011;
		x_issue_req_i.id <= 1;
		x_issue_req_i.rs[0] <= 32'b01111111011111111111111111111111;
		x_issue_req_i.rs[1] <= 32'b11111101110011001100110011001100;


	end

endmodule