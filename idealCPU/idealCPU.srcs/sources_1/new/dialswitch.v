`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/05 10:57:27
// Design Name: 
// Module Name: dialswitch
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


module dialswitch(
    input   wire        clk,
    input   wire        rst_n,
    input   wire        rd_en,
    input   wire [11:0] addr,
    input   wire [23:0] switch,
    output  reg  [31:0] data_o  
    );

wire work = rd_en & (addr == 12'h070);
 
always @ (*) begin
    if(~rst_n) begin
        data_o = 32'b0;
    end
    else if(work) begin
        data_o = {6'b0,switch};
    end
end

endmodule
