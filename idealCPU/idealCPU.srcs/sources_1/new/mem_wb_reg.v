`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/11 10:18:16
// Design Name: 
// Module Name: mem_wb_reg
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


module mem_wb_reg(
    input wire          clk,
    input wire          rst_n,
    input wire [31:0]   pc_from_mem,
    input wire          regwen_from_mem, 
    input wire [2:0]    wbsel_from_mem,
    input wire [4:0]    rd_from_mem,  
    input wire [31:0]   outcome_from_mem,
    input wire [31:0]   rdata_from_mem,
    output reg [31:0]   pc_to_wb,
    output reg          regwen_to_wb, 
    output reg [2:0]    wbsel_to_wb,  
    output reg [4:0]    rd_to_wb,   
    output reg [31:0]   rdata_to_wb,
    output reg [31:0]   outcome_to_wb
    );
    
    
always @ (posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        pc_to_wb <= 32'b0;
        regwen_to_wb <= 1'b0;
        rd_to_wb <= 5'b0;
        wbsel_to_wb <= 3'b0;
        outcome_to_wb <= 32'b0;
        rdata_to_wb <= 32'b0;
    end
    else begin
        pc_to_wb <= pc_from_mem;
        regwen_to_wb <= regwen_from_mem;
        rd_to_wb <= rd_from_mem;    
        wbsel_to_wb <= wbsel_from_mem; 
        outcome_to_wb <= outcome_from_mem; 
        rdata_to_wb <= rdata_from_mem;     
    end
end


endmodule
