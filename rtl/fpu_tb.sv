module fpu_tb();

	parameter fpnew_pkg::fpu_features_t       Features       = fpnew_pkg::RV32F;
  	parameter fpnew_pkg::fpu_implementation_t Implementation = fpnew_pkg::DEFAULT_NOREGS;
  	parameter type                            TagType        = logic;
  	// Parameter to select either floatli or fpnew
  	parameter bit                             TinyFPU        = 0;
  	// Do not change
  	localparam int unsigned WIDTH        = Features.Width;
  	localparam int unsigned NUM_OPERANDS = 3;

	reg clk_i = 0; 
	reg rst_ni;
	reg [NUM_OPERANDS-1:0][WIDTH-1:0] operands_i = 0;
	fpnew_pkg::roundmode_e              rnd_mode_i = fpnew_pkg::RNE;
	fpnew_pkg::operation_e              op_i;
	reg op_mod_i = 0;
	fpnew_pkg::fp_format_e              src_fmt_i = fpnew_pkg::FP32;
	fpnew_pkg::fp_format_e              dst_fmt_i = fpnew_pkg::FP32;
	fpnew_pkg::int_format_e             int_fmt_i = fpnew_pkg::INT32;
	reg vectorial_op_i = 0;
	TagType                             tag_i = 0;
	reg in_valid_i = 1;
	wire in_ready_o;
	reg flush_i = 1;
	wire [WIDTH-1:0]                  result_o;
	fpnew_pkg::status_t                status_o;
	TagType                            tag_o;
	wire out_valid_o;
	reg out_ready_i = 1;
	wire  busy_o;

	fpnew_top #(
  	.Features       ( fpnew_pkg::RV32F          ),
  	.Implementation ( fpnew_pkg::DEFAULT_NOREGS ),
  	.TagType        ( logic                     )
	) 
	i_fpnew_top (
  	.clk_i (clk_i),
  	.rst_ni (rst_ni),
  	.operands_i (operands_i ),
  	.rnd_mode_i (rnd_mode_i),
  	.op_i (op_i),
  	.op_mod_i (op_mod_i),
  	.src_fmt_i (src_fmt_i ),
  	.dst_fmt_i (dst_fmt_i ),
  	.int_fmt_i (int_fmt_i),
  	.vectorial_op_i (vectorial_op_i),
  	.tag_i (tag_i),
  	.in_valid_i (in_valid_i ),
  	.in_ready_o (in_ready_o),
  	.flush_i (flush_i ),
  	.result_o (result_o ),
  	.status_o (status_o),
  	.tag_o (tag_o),
  	.out_valid_o (out_valid_o),
  	.out_ready_i (out_ready_i),
  	.busy_o (busy_o)
	);

	always #5 clk_i = ~clk_i;	

	initial begin
    	rnd_mode_i = fpnew_pkg::RNE;
    	op_mod_i = 0;
    	op_i = fpnew_pkg::ADD;
    	src_fmt_i = fpnew_pkg::FP32;
    	dst_fmt_i = fpnew_pkg::FP32;
    	int_fmt_i = fpnew_pkg::INT32;
    	tag_i = 0;
		operands_i[0] = 'h00000000;
    	operands_i[1] = 32'b01111111011111111111111111111111;		//32'b10000000100100000000000000000000;
    	operands_i[2] = 32'b11111101110011001100110011001100;		//32'b10000110100001100001000000000000;
    	
	@(posedge clk_i);

	operands_i[1] = 32'b10000000100100000000000000000000;
    	operands_i[2] = 32'b10000110100001100001000000000000;


	end
//flush_i = 1;

	/*for (integer i = 0; i < 10; i++) begin
      		@(posedge clk_i);
    	end

    	Deassert reset */
    	/*rst_ni  = 1;
    	flush_i = 0;
    	@(posedge clk_i);
    	@(posedge clk_i);
    	@(posedge clk_i);
    	@(posedge clk_i);
    	in_valid_i = 1;
    	@(posedge clk_i);
    	@(posedge clk_i);
    	in_valid_i = 0;
    	for (integer i = 0; i < 10; i++) begin
    	  @(posedge clk_i);
    	end
    	//$finish;
  	end	*/

	/*initial begin
	forever begin
		#5
		clk_i <= ~ clk_i;
		
	end
	end

	initial begin
		#20
		rst_ni <= 0;
		//#20
		
		#20
		in_valid_i <= 1;
		op_i <= fpnew_pkg::ADD;
		op_mod_i <= 0;
		operands_i[0][31:0] <= 32'b10000000100100000000000000000000;
		operands_i[1][31:0] <= 32'b10000110100001100001000000000000;
		#20
		rst_ni <= 1;
		#200
		out_ready_i <= 1;
	end*/

endmodule

