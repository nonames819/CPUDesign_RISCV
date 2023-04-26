`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/29 08:31:57
// Design Name: 
// Module Name: comp
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


module comp(
    input wire [31:0]   data1_i,
    input wire [31:0]   data2_i,
    output wire         breq_o,
    output wire         brlt_o
    );
wire [31:0] m;
assign m      = data1_i-data2_i;
assign breq_o = (m == 32'b0) ? 1 : 0; //1相等0不等
assign brlt_o = m[31];                //1小于0大于等于

endmodule
