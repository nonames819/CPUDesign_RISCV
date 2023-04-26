`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/27 08:07:24
// Design Name: 
// Module Name: mini_rv
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mini_rv(
    input  wire        clk   ,
	input  wire        rst_n ,
	output wire [31:0] pc_o  ,
	input  wire [31:0] inst_i,
	output wire [31:0] io_addr_o ,
	input  wire [31:0] io_data_i,
	output wire        io_wen_o,
	output wire [31:0] io_data_o
    );
    
    
//prgrom u_prgrom(
//    .a      (pc_o[15:2]     ),
//    .spo    (prgrom_inst_o  )
//);
//dram u_dram(
//    .clk    (clk_g),
//    .a      (alu_o[15:2]),
//    .spo    (dram_o),
//    .we     (memrw),
//    .d      (rf_data2_o)
//);

wire [31:0] npc_pc4;
wire [31:0] npc_npc;
wire [31:0] rf_data1;
wire [31:0] rf_data2;
wire [31:0] immgen_imm;
wire        comp_breq;
wire        comp_brlt;

wire [31:0] wb_o;

//control signal
wire pcsel;
wire [2:0] immsel;
wire regwen;
wire asel;
wire bsel;
wire [3:0] alusel;
wire [1:0] wbsel;

assign io_data_o = rf_data2;


//cpuclk u_cpuclk(
//    .clk_in1 (clk   ),
//    .clk_out1(clk_g ),
//    .locked  ()
//);

npc u_npc(
    .pc_i       (pc_o       ),
    .alu_o_i    (io_addr_o  ),
    .pcsel_i    (pcsel      ),
    .pc4_o      (npc_pc4    ),
    .npc_o      (npc_npc    )
);

pc u_pc(
    .clk_i      (clk    ),
    .rst_n_i    (rst_n  ),
    .npc_i      (npc_npc),
    .pc_o       (pc_o   )
);


rf u_rf(
    .clk_i      (clk            ),
    .rst_n_i    (rst_n          ),
    .rs1_i      (inst_i[19:15]  ),
    .rs2_i      (inst_i[24:20]  ),
    .rd_i       (inst_i[11:7]   ),
    .regwen_i   (regwen         ),
    .wdata_i    (wb_o           ),
    .data1_o    (rf_data1       ),
    .data2_o    (rf_data2       )
);


immgen u_immgen(
    .rst_n_i    (rst_n          ),
    .immsel_i   (immsel         ),
    .inst_i     (inst_i[31:7]   ),
    .imm_o      (immgen_imm     )
);

comp u_comp(
    .data1_i    (rf_data1       ),
    .data2_i    (rf_data2       ),
    .breq_o     (comp_breq      ),
    .brlt_o     (comp_brlt      )
);

alu u_alu(
    .rst_n_i    (rst_n          ),
    .data1_i    (rf_data1       ),
    .data2_i    (rf_data2       ),
    .imm_i      (immgen_imm     ),
    .pc_i       (pc_o           ),
    .asel_i     (asel           ),
    .bsel_i     (bsel           ),
    .alusel_i   (alusel         ),
    .c_o        (io_addr_o      )
);

wb u_wb(
    .pc4_i      (npc_pc4    ),
    .alu_o_i    (io_addr_o  ),
    .io_data_i(io_data_i  ),
    .wbsel_i    (wbsel      ),
    .wb_o       (wb_o       )
);

controller u_controller(
    .rst_n      (rst_n      ),
    .func7      (inst_i[31:25]),
    .func3      (inst_i[14:12]),
    .opcode     (inst_i[6:0]),
    .breq_i     (comp_breq  ),
    .brlt_i     (comp_brlt  ), 
    .pcsel_o    (pcsel      ),
    .immsel_o   (immsel     ),
    .regwen_o   (regwen     ),
    .asel_o     (asel       ),
    .bsel_o     (bsel       ),
    .alusel_o   (alusel     ),
    .memrw_o    (io_wen_o    ),
    .wbsel_o    (wbsel      )     
);


endmodule
