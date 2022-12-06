module tinyfpu_cvxif import ibex_pkg::*;(
	input   logic                         clk_i,
  	input   logic                         rst_ni,
	input 	logic                         x_issue_valid_i,
  	output  logic                         x_issue_ready_o,
  	input 	x_issue_req_t                 x_issue_req_i,
  	output  x_issue_resp_t                x_issue_resp_o,
  	output  logic                         x_result_valid_o,
  	input 	logic                         x_result_ready_i,
  	output  x_result_t                    x_result_o
	);

	parameter fpnew_pkg::fpu_features_t       Features       = fpnew_pkg::RV32F;
  	parameter fpnew_pkg::fpu_implementation_t Implementation = fpnew_pkg::DEFAULT_NOREGS;
  	parameter type                            TagType        = logic;
  	// Parameter to select either floatli or fpnew
  	parameter bit                             TinyFPU        = 0;
  	// Do not change
  	localparam int unsigned WIDTH        = Features.Width;
  	localparam int unsigned NUM_OPERANDS = 3;

	//reg clk_i = 0; 
	//reg rst_ni;
	reg [NUM_OPERANDS-1:0][WIDTH-1:0] operands_i;
	fpnew_pkg::roundmode_e              rnd_mode_i = fpnew_pkg::RNE;
	fpnew_pkg::operation_e              op_i = fpnew_pkg::ADD;
	reg op_mod_i = 0;
	fpnew_pkg::fp_format_e              src_fmt_i = fpnew_pkg::FP32;
	fpnew_pkg::fp_format_e              dst_fmt_i = fpnew_pkg::FP32;
	fpnew_pkg::int_format_e             int_fmt_i = fpnew_pkg::INT32;
	reg vectorial_op_i = 0;
	TagType                             tag_i = 0;
	//reg in_valid_i = 1;
	wire in_ready_o;
	reg flush_i = 0;
	wire [WIDTH-1:0]                  result_o;
	fpnew_pkg::status_t                status_o;
	TagType                            tag_o;
	wire out_valid_o;
	reg out_ready_i = 1;
	wire  busy_o;

	//CVXIF Interface
	/*logic                     x_issue_valid;
	logic                     x_issue_ready;
	x_issue_req_t             x_issue_req;
	x_issue_resp_t            x_issue_resp;
	logic                     x_commit_valid;
	x_commit_t                x_commit;
	logic                     x_result_valid;
	logic                     x_result_ready;
	x_result_t                x_result;*/
	logic [31:0] instr;
	logic [1:0][31:0] sources;

	assign instr = x_issue_req_i.instr;
	assign sources = x_issue_req_i.rs;
	assign operands_i[1] = sources[0];						//instr[19:15];
	assign operands_i[2] = sources[1];						//instr[24:20];
	assign x_issue_resp_o.accept = 1;
	assign x_issue_resp_o.writeback = 1;
	assign x_result_o.rd = instr[11:7];
	assign x_result_o.we = 1;
	assign x_result_o.id = x_issue_req_i.id;
	

	fpnew_top #(
  	.Features       ( fpnew_pkg::RV32F          ),
  	.Implementation ( fpnew_pkg::DEFAULT_NOREGS ),
  	.TagType        ( logic                     )
	) 
	i_fpnew_top (
  	.clk_i (clk_i),
  	.rst_ni (rst_ni),
  	.operands_i (operands_i),
  	.rnd_mode_i (rnd_mode_i),
  	.op_i (op_i),
  	.op_mod_i (op_mod_i),
  	.src_fmt_i (src_fmt_i ),
  	.dst_fmt_i (dst_fmt_i ),
  	.int_fmt_i (int_fmt_i),
  	.vectorial_op_i (vectorial_op_i),
  	.tag_i (tag_i),
  	.in_valid_i (x_issue_valid_i),	//
  	.in_ready_o (x_issue_ready_o),	//
  	.flush_i (flush_i ),
  	.result_o (x_result_o.data),			//
  	.status_o (status_o),
  	.tag_o (tag_o),
  	.out_valid_o (x_result_valid_o),	//
  	.out_ready_i (x_result_ready_i),	//
  	.busy_o (busy_o)
	);

endmodule
