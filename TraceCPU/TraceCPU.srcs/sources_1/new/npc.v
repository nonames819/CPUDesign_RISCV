`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/29 08:52:22
// Design Name: 
// Module Name: npc
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


module npc(
    input wire [31:0]   pc_i,
    input wire [31:0]   alu_o_i,
    input wire          pcsel_i,
    output wire [31:0]  pc4_o,
    output wire [31:0]  npc_o
    );

assign pc4_o = pc_i + 32'd4;
assign npc_o = (pcsel_i == 0) ? pc4_o : 
               (pcsel_i == 1) ? alu_o_i : 
                                 32'b0;

endmodule
