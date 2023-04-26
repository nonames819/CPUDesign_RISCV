`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/27 09:43:19
// Design Name: 
// Module Name: rf
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


module rf(
    input   wire        clk_i,
    input   wire        rst_n_i,
    input   wire [4:0]  rs1_i,
    input   wire [4:0]  rs2_i,
    input   wire [4:0]  rd_i,
    input   wire        regwen_i,
    input   wire [31:0] wdata_i,
    output  wire [31:0] data1_o,
    output  wire [31:0] data2_o
    );

reg[31:0] regfile[31:0];

assign data1_o = (rs1_i == 5'b0) ? 32'd0 : regfile[rs1_i];
assign data2_o = (rs2_i == 5'b0) ? 32'd0 : regfile[rs2_i];

always @ (posedge clk_i or negedge rst_n_i) begin
    if(~rst_n_i) begin
        regfile[0] <= 32'b0;
        regfile[1] <= 32'b0; 
        regfile[2] <= 32'b0;
        regfile[3] <= 32'b0; 
        regfile[4] <= 32'b0;
        regfile[5] <= 32'b0; 
        regfile[6] <= 32'b0;
        regfile[7] <= 32'b0; 
        regfile[8] <= 32'b0;
        regfile[9] <= 32'b0; 
        regfile[10] <= 32'b0;
        regfile[11] <= 32'b0; 
        regfile[12] <= 32'b0;
        regfile[13] <= 32'b0; 
        regfile[14] <= 32'b0;
        regfile[15] <= 32'b0; 
        regfile[16] <= 32'b0;
        regfile[17] <= 32'b0; 
        regfile[18] <= 32'b0;
        regfile[19] <= 32'b0; 
        regfile[20] <= 32'b0;
        regfile[21] <= 32'b0; 
        regfile[22] <= 32'b0;
        regfile[23] <= 32'b0; 
        regfile[24] <= 32'b0;
        regfile[25] <= 32'b0; 
        regfile[26] <= 32'b0;
        regfile[27] <= 32'b0; 
        regfile[28] <= 32'b0;
        regfile[29] <= 32'b0; 
        regfile[30] <= 32'b0;
        regfile[31] <= 32'b0; 
    end
    else if((regwen_i == 1) && (rd_i != 5'b0)) begin
        regfile[rd_i] <= wdata_i;
    end
end

 
endmodule
