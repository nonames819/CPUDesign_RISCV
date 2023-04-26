`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/29 09:10:01
// Design Name: 
// Module Name: wb
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


module wb(
    input wire [31:0]   pc4_i,
    input wire [31:0]   alu_o_i,
    input wire [31:0]   io_data_i,
    input wire [1:0]    wbsel_i,
    output wire [31:0]  wb_o   
    );

assign wb_o = (wbsel_i == 2'b00) ? pc4_i :
              (wbsel_i == 2'b01) ? alu_o_i :
              (wbsel_i == 2'b10) ? io_data_i:
                                 32'b0;

endmodule
