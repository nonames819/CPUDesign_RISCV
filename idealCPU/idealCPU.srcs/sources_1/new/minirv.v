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
	output wire [31:0] io_addr_o ,//
	input  wire [31:0] io_data_i,//
	output wire        io_wen_o,//
	output wire [31:0] io_data_o//
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

//wire connecting registers
//if/id
wire [31:0] pc_from_if;
wire [31:0] inst_from_if;
wire [31:0] pc_to_id;
wire [31:0] inst_to_id;

//id/ex
wire regwen_from_id;
wire [31:0] data1_from_id;
wire [31:0] data2_from_id;
wire [31:0] imm_from_id;
wire [4:0] rd_from_id;
wire asel_from_id;
wire bsel_from_id;
wire [3:0] alusel_from_id;
wire memrw_from_id;
wire [2:0] wbsel_from_id;


wire [31:0] pc_to_ex;
wire regwen_to_ex;
wire [31:0] data1_to_ex;
wire [31:0] data2_to_ex;
wire [31:0] imm_to_ex;
wire [4:0] rd_to_ex;
wire asel_to_ex;
wire bsel_to_ex;
wire [3:0] alusel_to_ex;
wire memrw_to_ex;
wire [2:0] wbsel_to_ex;

//ex/mem;
wire [31:0] outcome_from_ex;

wire [31:0] pc_to_mem;
wire        regwen_to_mem; 
wire        memrw_to_mem;  
wire [2:0]  wbsel_to_mem;  
wire [4:0]  rd_to_mem;     
wire [31:0] data2_to_mem;
wire [31:0] outcome_to_mem;

//mem/wb
wire [31:0] rdata_from_mem;

wire [31:0] pc_to_wb;
wire        regwen_to_wb; 
wire [31:0] rdata_to_wb;
wire [2:0]  wbsel_to_wb;  
wire [4:0]  rd_to_wb;    
wire [31:0] outcome_to_wb; 


assign io_data_o = rf_data2;


//cpuclk u_cpuclk(
//    .clk_in1 (clk   ),
//    .clk_out1(clk_g ),
//    .locked  ()
//);


//IF
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

assign pc_from_if = pc_o;
assign inst_from_if = inst_i;

if_id_reg u_if_id_reg(
    .clk            (clk),
    .rst_n          (rst_n),
    .pc_from_if     (pc_from_if),
    .inst_from_if   (inst_from_if),
    .pc_to_id       (pc_to_id),
    .inst_to_id     (inst_to_id)
);

//ID
controller u_controller(
    .rst_n      (rst_n      ),
    .func7      (inst_to_id[31:25]),
    .func3      (inst_to_id[14:12]),
    .opcode     (inst_to_id[6:0]),
    .breq_i     (comp_breq  ),
    .brlt_i     (comp_brlt  ), 
    .pcsel_o    (pcsel      ),
    .immsel_o   (immsel     ),
    .regwen_o   (regwen_from_id     ),
    .asel_o     (asel_from_id       ),
    .bsel_o     (bsel_from_id       ),
    .alusel_o   (alusel_from_id     ),
    .memrw_o    (memrw_from_id      ),
//    .memrw_o    (io_wen_o    ),
    .wbsel_o    (wbsel_from_id      )     
);


rf u_rf(
    .clk_i      (clk            ),
    .rst_n_i    (rst_n          ),
    .rs1_i      (inst_to_id[19:15]  ),
    .rs2_i      (inst_to_id[24:20]  ),
    .rd_i       (rd_to_wb           ),
    .regwen_i   (regwen_to_wb       ),
    .wdata_i    (wb_o               ),
    .data1_o    (data1_from_id       ),
    .data2_o    (data2_from_id       )
);


immgen u_immgen(
    .rst_n_i    (rst_n          ),
    .immsel_i   (immsel         ),
    .inst_i     (inst_to_id[31:7]   ),
    .imm_o      (imm_from_id     )
);

assign rd_from_id = inst_to_id[11:7];

id_ex_reg u_id_ex_reg(
    .clk            (clk           ),           
    .rst_n          (rst_n         ),
    .pc_from_id     (pc_to_id      ),    
    .regwen_from_id (regwen_from_id),
    .data1_from_id  (data1_from_id ),
    .data2_from_id  (data2_from_id ), 
    .imm_from_id    (imm_from_id   ),   
    .rd_from_id     (rd_from_id    ),
    .asel_from_id   (asel_from_id  ),
    .bsel_from_id   (bsel_from_id  ),
    .alusel_from_id (alusel_from_id),
    .memrw_from_id  (memrw_from_id ),
    .wbsel_from_id  (wbsel_from_id ),
                
    .pc_to_ex       (pc_to_ex     ),
    .regwen_to_ex   (regwen_to_ex ),
    .data1_to_ex    (data1_to_ex  ),
    .data2_to_ex    (data2_to_ex  ),
    .imm_to_ex      (imm_to_ex    ),
    .rd_to_ex       (rd_to_ex     ),
    .asel_to_ex     (asel_to_ex   ),
    .bsel_to_ex     (bsel_to_ex   ),
    .alusel_to_ex   (alusel_to_ex ),
    .memrw_to_ex    (memrw_to_ex  ),
    .wbsel_to_ex    (wbsel_to_ex  )
    
);

//EX
comp u_comp(
    .data1_i    (data1_to_ex       ),
    .data2_i    (data2_to_ex       ),
    .breq_o     (comp_breq      ),
    .brlt_o     (comp_brlt      )
);

alu u_alu(
    .rst_n_i    (rst_n          ),
    .data1_i    (data1_to_ex       ),
    .data2_i    (data2_to_ex       ),
    .imm_i      (imm_to_ex     ),
    .pc_i       (pc_to_ex           ),
    .asel_i     (asel_to_ex       ),
    .bsel_i     (bsel_to_ex       ),
    .alusel_i   (alusel_to_ex         ),
    .c_o        (outcome_from_ex      )
);

ex_mem_reg u_ex_mem_reg(
    .clk            (clk            ),            
    .rst_n          (rst_n          ),
    .pc_from_ex     (pc_to_ex       ),
    .regwen_from_ex (regwen_to_ex   ),
    .memrw_from_ex  (memrw_to_ex    ),
    .wbsel_from_ex  (wbsel_to_ex    ),
    .rd_from_ex     (rd_to_ex       ),
    .data2_from_ex  (data2_to_ex    ),
    .outcome_from_ex(outcome_from_ex),
    
    .pc_to_mem      (pc_to_mem      ),
    .regwen_to_mem  (regwen_to_mem  ),
    .memrw_to_mem   (memrw_to_mem   ),
    .wbsel_to_mem   (wbsel_to_mem   ),
    .rd_to_mem      (rd_to_mem      ),
    .data2_to_mem   (data2_to_mem   ),
    .outcome_to_mem (outcome_to_mem )
);
//MEM
assign io_addr_o = outcome_to_mem;
assign io_wen_o = memrw_to_mem;
assign io_data_o = data2_to_mem;

assign rdata_from_mem = io_data_i;

mem_wb_reg u_mem_wb_reg(
    .clk             (clk               ),
    .rst_n           (rst_n             ),
    .pc_from_mem     (pc_to_mem         ),
    .regwen_from_mem (regwen_to_mem     ),
    .wbsel_from_mem  (wbsel_to_mem      ),
    .rd_from_mem     (rd_to_mem         ),
    .outcome_from_mem(outcome_to_mem    ),
    .rdata_from_mem  (rdata_from_mem    ), 
    .pc_to_wb        (pc_to_wb          ), 
    .regwen_to_wb    (regwen_to_wb      ), 
    .wbsel_to_wb     (wbsel_to_wb       ), 
    .rd_to_wb        (rd_to_wb          ), 
    .rdata_to_wb     (rdata_to_wb       ), 
    .outcome_to_wb   (outcome_to_wb     )
);

//WB
wb u_wb(
    .pc4_i      (npc_pc4    ),
    .alu_o_i    (outcome_to_wb),
    .io_data_i  (rdata_to_wb  ),
    .wbsel_i    (wbsel_to_wb  ),
    .wb_o       (wb_o       )
);



endmodule
