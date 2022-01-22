// Company           :   tud                      
// Author            :   vepr19            
// E-Mail            :   <email>                    
//                    			
// Filename          :   dobby_core.v                
// Project Name      :   prz    
// Subproject Name   :   main    
// Description       :   Dobby core with all units instantiation.           
//
// Create Date       :   Sun Oct 18 14:09:58 2020 
// Last Change       :   $Date: 2021-03-11 17:39:50 +0100 (Thu, 11 Mar 2021) $
// by                :   $Author: vepr19 $                  			
//------------------------------------------------------------
`timescale 1ns/10ps
module dobby_core (
	     //from pads
	     clk,
	     a_reset_l,
	     i_intr,
	     i_bus_ready,
	     i_load_data,
	     //to pads
	     o_bus_en,
	     o_bus_wen,
	     o_bus_addr,
	     o_bus_size,
	     o_intr_ack,
	     o_store_data
	);


	input		clk;
	input		a_reset_l;
	input 	[1:0]	i_intr;
	input  	i_bus_ready;
	input 	[31:0]	i_load_data;
	//to pads
	output   [1:0]   o_intr_ack;
	output 	[31:0]	o_store_data;
	output           o_bus_en;
	output           o_bus_wen;
	output 	 [1:0]	o_bus_size;
	output  [15:0]	o_bus_addr;



	wire [31:0] s_bus_inst_data;
	wire s_bus_pull_data_fetch;
	wire [31:0] s_const_four;
	wire [31:0] s_const_zero;
	assign s_const_zero=32'd0;
	assign s_const_four= 32'd4;

	parameter A ="NONE";
	parameter B ="NONE";
	parameter C ="NONE";
	parameter D ="NONE";	

	


	//Init controller op
	wire s_ld_from_ext;
	wire [15:0] s_addr_counter;

	//Mem controller op
	wire s_stop_fetch;
	wire s_pram_wen;
	wire [15:0]s_pram_addr;
	wire [31:0]s_pram_w_data;
	wire [1:0]s_pram_access_size;
	wire [31:0]s_inst_data;
	wire [31:0]s_ld_data;
	wire s_bus_en;
	wire [1:0]s_bus_acc_size;
	wire s_bus_wr_en;
	wire [15:0]s_bus_addr; 
	wire [31:0]s_ls_bus_wr_data;

	//to hold the instruction when load store
	reg [31:0] hold_inst;
	reg valid;
	wire [31:0] s_fetch_instr;

	reg [31:0] hold_inst_ext;
	reg valid_ext;
	reg [1:0] s_sel;

	//bus ctrl op
	wire [31:0]s_ext_read_data;
	wire s_bus_ack;
	wire [15:0]s_pram_init_addr;	

	//pram op
	wire [31:0]s_pram_o_data;
	wire s_pram_ld_done;
	wire s_pram_st_done;


	//interrupt ctrl op
	wire s_int_en;

	//fetcher op
	wire [31:0]s_inst_addr; 


	//decoder op
	wire [ 4 : 0 ] s_rd_sel_a , s_rd_sel_b;  //to regfile
	wire [ 4 : 0 ] s_dest_addr;              //to regfile
	wire [ 6 : 0 ] s_func_seven;
	wire [ 2 : 0 ] s_func_three;		
	wire [ 6 : 0 ] s_opcode;
	wire [ 31 : 0 ] s_imm_itype;
	wire [ 31 : 0 ] s_imm_stype;
	wire [ 31 : 0 ] s_imm_utype;
	wire [ 31 : 0 ] s_imm_btype;
	wire [ 31 : 0 ] s_imm_jtype;
	wire [ 31 : 0 ] s_shamt;

	//ctrl op
	wire  [ 4 : 0 ] s_alu_opcode;
	wire  [31:0]s_imm_data;
	wire [1:0]s_res_mux_sel;
	wire  s_rf_wen; 
	wire [1:0]s_alu_opb_mux_sel;
	wire s_alu_opa_mux_sel;
	wire s_jump;
	wire s_jmp_valid;
	wire [2:0] s_branch_op;

	wire s_mem_alu_mux_sel;   //for output select for regfile (ALU/DMEM)
	wire s_mem_wr_en;
	wire s_mem_ctrl_ls;
	//csr related
	wire	s_csr_en;
	wire	[2:0]s_csr_opcode;
	wire	s_csr_data_sel;
	wire [1:0]s_sys_inst;
	wire s_halt_pc_wfi;
	wire [11:0] s_csr_addr;



	//regfile output
	wire [31:0]s_ra_data;
	wire [31:0]s_rb_data;


	//csr op
	wire [31:0]s_csr_output;
	wire s_mie_bit;


	//mux op to ALU
	wire [31:0]s_op_a_input;
	wire [31:0]s_op_b_input;


	//ALU and ALU MULDIV op
	wire [31:0] s_alu_res;
	wire [31:0] s_alu_res_muldiv;
	wire s_flag_zero;
	wire s_flag_of;
	wire s_flag_divbyzero;
	
	//Branch unit op
	wire [31:0]s_pc_next;

	//ALU res sel mux op
	wire [31:0] s_alu_final_sel_res;

		
	//last mux op
	wire [31:0]s_rf_wr_data;

	wire reg_wr_en;


	wire [31:0]s_pc_off;

	wire s_mul_div_busy;


	wire 		s_pc_incr;
	wire 		s_f_bus_en;
	wire[1:0] 	s_state;
	wire 		s_wen_regs;
	wire 		s_sw_fetch_internal;
	wire 		s_ls_bus_en;


	wire [1:0] i_intr_h = s_wen_regs ? 2'b00:i_intr;


	init_controller init_controller_i (
		.i_clk (clk ),
		.interrupt(i_intr_h[0]),
		.i_a_reset_l (a_reset_l ),
		.ld_from_ext (s_ld_from_ext ),
		.addr_counter (s_addr_counter ),
		.i_bus_ready(i_bus_ready)
	);



	mem_controller mem_controller_i (

		.pc_addr (s_pc_next),
		.pc_addr_reg(s_inst_addr),
		.ld_st_addr (s_alu_final_sel_res ),
		.st_data ( s_rb_data ),
		.mem_wr_en (s_mem_wr_en ),
		.reg_wr_en (s_rf_wen ),
		.mem_ctrl_ls (s_mem_ctrl_ls ),
		.pram_r_data (s_pram_o_data ),
		.func_three (s_func_three ),
		.stop_fetch (s_stop_fetch ),//to be done
		.pram_wen (s_pram_wen ),
		.pram_addr (s_pram_addr ),
		.pram_w_data (s_pram_w_data ),
		.pram_access_size (s_pram_access_size ),
		.inst_data(s_inst_data), //for hold mux
		.ld_data (s_ld_data ),
		.ext_read_data(s_ext_read_data),
		.ld_on_rst(s_ld_from_ext),
		.addr_counter(s_addr_counter),
		.bus_ack(s_bus_ack), //from bus_if
		.bus_en(s_bus_en),
		.r_pram_addr(s_pram_init_addr),
		.bus_access_size(s_bus_acc_size),
		.bus_wr_en(s_bus_wr_en),
		.bus_addr(s_bus_addr),
		.bus_wr_data(s_ls_bus_wr_data),
		.pram_ld_done(s_pram_ld_done),
		.pram_st_done(s_pram_st_done),
		.f_bus_en(s_f_bus_en),
		.wen_regs(s_wen_regs),
		.ls_bus_en(s_ls_bus_en)		
        );



	// hold mux decision block

	always@(posedge clk,negedge a_reset_l) begin
		if(!a_reset_l) begin
			hold_inst <= 32'd0; 
			valid <=1'b0;
		end
		else begin
			if((s_stop_fetch || s_halt_pc_wfi || s_mul_div_busy)  && !valid) begin
				hold_inst <= s_ld_from_ext? 32'd0:  s_inst_data ;
				valid <= 1'b1;
			end
			else if(!s_stop_fetch  && (!s_halt_pc_wfi ) && !s_mul_div_busy )
			valid <=1'b0;
			
		end
	end


	// hold mux decision block for bus side fetch
	always@(posedge clk,negedge a_reset_l) begin
		if(!a_reset_l) begin
			hold_inst_ext <= 32'd0; 
			valid_ext  <=  1'b0;
			s_sel <= 2'b00;
		end
		else begin
			if(s_sw_fetch_internal)begin
				s_sel  <=  2'b00;
				valid_ext  <=  1'b0;
			end
			else if(s_state == 2'b10 && !valid_ext) begin	
				hold_inst_ext <=  s_bus_inst_data ;
				s_sel  <=  2'b11;
				valid_ext  <=  1'b1;
			end
			else if(s_pc_incr)begin
				s_sel  <=  2'b10;
				valid_ext  <=  1'b0;
			end
			
			
		end
	end

	wire[1:0] hold_sel = {1'b0,valid} | {s_sel} ;

	wire s_mem_ctrl_ls_final=s_mem_ctrl_ls && !s_wen_regs && s_ls_bus_en;

	mux4_1 #(.N(32))hold_inst_mux(
			    .sel(hold_sel), 		
			    .in_one(s_inst_data),    	//from regfile
			    .in_two(hold_inst), 
			    .in_three(s_bus_inst_data),
			    .in_four(hold_inst_ext), 	//from PC output
			    .outp(s_fetch_instr)
			     );


	wire s_bus_en_final=s_bus_en && !s_halt_pc_wfi;
	bus_ctrl #(.DATA_WIDTH(32),
	.ADDR_WIDTH (16))bus_if_i(.clk_i(clk),
				.reset_n(a_reset_l),
				.bus_wen(s_bus_wr_en),
				.bus_en(s_bus_en_final ),
				.bus_address(s_bus_addr),
				.bus_access_size(s_bus_acc_size),
				.bus_st_data(s_ls_bus_wr_data),
				.i_bus_ld_data(i_load_data), //from pad
				.ld_on_rst(s_ld_from_ext),
				.bus_ld_data(s_ext_read_data),
				.bus_ack(s_bus_ack),
				.r_pram_addr(s_pram_init_addr),
				.o_bus_we(o_bus_wen),
				.o_bus_en(o_bus_en),
				.o_bus_addr(o_bus_addr),
				.o_bus_size(o_bus_size),	
				.o_bus_st_data(o_store_data),
				//bus interface going outside
				.i_bus_ready(i_bus_ready),
				.mem_cntrl_ls(s_mem_ctrl_ls_final ),
				.bus_inst_data(s_bus_inst_data),
				.bus_fetch_ack(s_bus_pull_data_fetch)
				);

	 wire s_pram_mem_ctrl_ls=s_mem_ctrl_ls && !(s_ls_bus_en || s_ld_from_ext||valid ||s_wen_regs);


	pram #(.INITFILE0(A),
			   .INITFILE1(B),
		           .INITFILE2(C),
			   .INITFILE3(D))
		pram_i  (
		.clk(clk),
		.rst_n(a_reset_l),
		.mem_ctrl_ls(s_pram_mem_ctrl_ls),
  		.wen(s_pram_wen),
  		.mem_addr(s_pram_addr),
  		.w_in(s_pram_w_data),
		.access_size(s_pram_access_size),  

  		.pram_data_o(s_pram_o_data),
		
		.load_done(s_pram_ld_done),
		.store_done(s_pram_st_done)
	       );


	wire s_stop_fetch_final =s_halt_pc_wfi || s_stop_fetch|| s_mul_div_busy;
	interrupt_ctrl interrupt_ctrl_i(
				.clk(clk),
				.rst_n(a_reset_l),
				.i_intr_h(i_intr_h),
				.mie_bit(s_mie_bit),
				.int_en(s_int_en),
				.o_int_ack(o_intr_ack),
				.stop_fetch(s_stop_fetch_final),
				.jump(s_jmp_valid)
			);
	

	fetch_state_machine fetch_sm_i	 (  .f_bus_en(s_f_bus_en),
					    .bus_ready(s_bus_pull_data_fetch),
					    .reset_n(a_reset_l),
					    .clk(clk),
					    .stopfetch(s_stop_fetch_final),
					    .pc_incr(s_pc_incr),
					    .current_state(s_state),
					    .wen_regs(s_wen_regs),
					    .sw_fetch_internal(s_sw_fetch_internal)
					    );

	fetcher fetcher_i (
			.clk(clk),
			.rst(a_reset_l),
			.pc_next(s_pc_next),
			.halt_core(s_stop_fetch_final ), //stop_fetch || halt_pc_wfi s_stop_fetch||s_halt_pc_wfi
			.inst_addr_o(s_inst_addr),	//for fetch mem ctroller
			.pc_incr(s_pc_incr),
			.f_bus_en(s_f_bus_en)
                    );





	decoder decoder_i (
		//input
		.inst(s_fetch_instr),
		//output to control and regfile
		.rd_sel_a (s_rd_sel_a), .rd_sel_b (s_rd_sel_b),
		.dest_addr(s_dest_addr),
		.func_three(s_func_three),
		.func_seven(s_func_seven),
		.opcode(s_opcode),
		.imm_itype(s_imm_itype),
		.imm_stype(s_imm_stype),
		.imm_utype(s_imm_utype),
		.imm_btype(s_imm_btype),
		.imm_jtype(s_imm_jtype),
		.shamt(s_shamt)
	);


	control control_i(
			.opcode(s_opcode),
			.func_three(s_func_three),
			.func_seven(s_func_seven),
			.imm_itype(s_imm_itype),
			.imm_stype(s_imm_stype),
			.imm_utype(s_imm_utype),
			.imm_btype(s_imm_btype),
			.imm_jtype(s_imm_jtype),
			.shamt(s_shamt),

		
			//outputs
			.alu_opcode(s_alu_opcode), 		  //for alu
			.imm_o(s_imm_data),       		  //for mux_opb
			.res_sel(s_res_mux_sel),   		  //for result selection (4:1)mux
			.reg_wr_en(s_rf_wen),      		  //for reg file
			.alu_opb_sel(s_alu_opb_mux_sel),          //for ip mux opb
			.alu_opa_sel(s_alu_opa_mux_sel),          //for ip mux opa
			.jump(s_jump),  
			.jmp_valid(s_jmp_valid),
			.branch_opcode(s_branch_op),                 
			.mem_to_reg(s_mem_alu_mux_sel),     	  //to select output from ALU/DMEM
			.mem_wen(s_mem_wr_en),             	  //to enable DMEM for write.
			.mem_ctrl_ls(s_mem_ctrl_ls),
			.csr_en(s_csr_en ),
			.csr_opcode(s_csr_opcode),
			.csr_data_sel(s_csr_data_sel),
			.sys_inst(s_sys_inst),
			.halt_pc(s_halt_pc_wfi),
			.int_en(s_int_en),
			.csr_addr(s_csr_addr),
			.ld_on_rst(s_ld_from_ext)
		);



	assign reg_wr_en = !s_wen_regs &&( (s_rf_wen && s_mem_ctrl_ls && !s_stop_fetch  )|| (s_rf_wen && !s_mul_div_busy && !s_mem_ctrl_ls));

	  regfile regfile_i (
			.clk(clk),
			.wen(reg_wr_en ), //from control
			.ra_addr(s_rd_sel_a),
			.rb_addr(s_rd_sel_b),
			.rdest_addr(s_dest_addr),
			.wdata(s_rf_wr_data),
			.ra_data(s_ra_data),
			.rb_data(s_rb_data),
			.rst_n(a_reset_l)
			);


	wire s_csr_en_final =(s_csr_en && !valid) || (s_csr_en && !s_wen_regs);

	csr #(.XLEN(32)) csr_i(

		.clk(clk),
		.rst(a_reset_l),
		.pc_off(s_pc_off), //for mepc		
		.interrupt_i(i_intr_h),	
		.csr_opcode(s_csr_opcode),
		.csr_en(s_csr_en_final), 
		.csr_data_sel(s_csr_data_sel),
		.csr_addr(s_csr_addr),
		.instruction(s_fetch_instr[19:15]), 
		.rsource_data(s_ra_data),
		.sys_inst(s_sys_inst),
		.csr_data_out(s_csr_output),
		.mie_bit(s_mie_bit),
		.stop_fetch(s_stop_fetch_final),
		.jump(s_jmp_valid) 
	    );



	//mux instantiate for data selection operand A for ALU


	mux2_1 #(.N(32))opa_mux(
			    .sel(s_alu_opa_mux_sel), //from ctrl
			    .in_one(s_ra_data),    //from regfile
			    .in_two(s_inst_addr), //from PC output
			    .outp(s_op_a_input)
			     );


	//mux instantiate for data selection operand B for ALU

	mux4_1 #(.N(32)) opb_mux(
			 	    .sel(s_alu_opb_mux_sel),
				    .in_one(s_rb_data),   	//from regfile
				    .in_two(s_imm_data),  	//from ctrl
				    .in_three(s_const_four),    //PC+ 4-JALR
				    .in_four(s_const_zero),     // for nop and addi with 0
				    .outp(s_op_b_input)
			     );

	//alu execution unit


	alu alu_i (
		.rega(s_op_a_input),   //from mux2
		.regb(s_op_b_input),   //from mux4
		.alu_opcode(s_alu_opcode), //from ctrl
		.alu_res(s_alu_res),       //  alu_res to mux
		.flag_zero(s_flag_zero),   // flag_zero output 
		.flag_of(s_flag_of)       // flag_of output 
	     );


	//muldiv instantiate

	booth_md alu_muldiv_i (
				.rega(s_op_a_input),  //from mux2
				.regb(s_op_b_input),  //from mux4
				.alu_opcode(s_alu_opcode), //from ctrl
				.alu_res_muldiv(s_alu_res_muldiv), //result to be given to mux
				.flag_divbyzero(s_flag_divbyzero),
				.clk(clk),
				.reset(a_reset_l),
				.busy(s_mul_div_busy),
				.wen_regs(s_wen_regs)
			   );


	branch_unit branch_unit_i (
			.pc_addr(s_inst_addr),
			.branch_opcode(s_branch_op),
			.sys_inst(s_sys_inst),
			.csr_en(s_csr_en),
			.jump(s_jump),
			.jmp_valid(s_jmp_valid),
			.rb_data(s_rb_data),
			.imm_o(s_imm_data),
			.ra_data(s_ra_data),
			.csr_data_in(s_csr_output),
			.pc_next(s_pc_next),
			.mie_bit(s_mie_bit),
			.pc_off(s_pc_off),
			.int_en(i_intr_h)
		
			); 




	
	mux4_1 #(.N(32)) alu_res_mux(
			 	    .sel(s_res_mux_sel), //from ctrl
				    .in_one(s_alu_res),//s_alu_res),   
				    .in_two(s_alu_res_muldiv),//  //s_alu_res_muldiv
				    .in_three(s_imm_data),     //from ctrl
				    .in_four(s_csr_output),     // csr select 
				    .outp(s_alu_final_sel_res)  //to dmem and 2:1 mux for regfile  write
			     );






	// final_2:1_MUX for regfile write

	mux2_1 #(.N(32))rf_wr_mux(
			    .sel(s_mem_alu_mux_sel), 	     //from ctrl
			    .in_one(s_alu_final_sel_res),    //from 4:1 MUX
			    .in_two(s_ld_data), 
			    .outp(s_rf_wr_data)   
			     );



endmodule