`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/11 09:52:06
// Design Name: 
// Module Name: ex_mem_reg
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


module ex_mem_reg(
    input wire          clk,
    input wire          rst_n,
    input wire [31:0]   pc_from_ex,
    input wire          regwen_from_ex, 
    input wire          memrw_from_ex,  
    input wire [2:0]    wbsel_from_ex,
    input wire [4:0]    rd_from_ex,  
    input wire [31:0]   data2_from_ex,
    input wire [31:0]   outcome_from_ex,
    output reg [31:0]   pc_to_mem,
    output reg          regwen_to_mem,
    output reg          memrw_to_mem,  
    output reg [2:0]    wbsel_to_mem,  
    output reg [4:0]    rd_to_mem,   
    output reg [31:0]   data2_to_mem, 
    output reg [31:0]   outcome_to_mem
    );
    
always @ (posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        pc_to_mem <= 32'b0;
        regwen_to_mem <= 1'b0;
        data2_to_mem <= 32'b0;
        rd_to_mem <= 5'b0;
        memrw_to_mem <= 1'b0;
        wbsel_to_mem <= 3'b0;
        outcome_to_mem <= 32'b0;
    end
    else begin
        pc_to_mem <= pc_from_ex;
        regwen_to_mem <= regwen_from_ex;
        data2_to_mem <= data2_from_ex;
        rd_to_mem <= rd_from_ex;    
        memrw_to_mem <= memrw_from_ex;
        wbsel_to_mem <= wbsel_from_ex; 
        outcome_to_mem <= outcome_from_ex;      
    end
end


endmodule
