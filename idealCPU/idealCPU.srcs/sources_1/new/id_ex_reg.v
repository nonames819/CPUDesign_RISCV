`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/07 11:40:59
// Design Name: 
// Module Name: id_ex_reg
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


module id_ex_reg(
    input wire          clk,
    input wire          rst_n,
    input wire [31:0]   pc_from_id,
    input wire          regwen_from_id,
    input wire [31:0]   data1_from_id,
    input wire [31:0]   data2_from_id,
    input wire [31:0]   imm_from_id,
    input wire [4:0]    rd_from_id,
    input wire          asel_from_id,
    input wire          bsel_from_id,
    input wire [3:0]    alusel_from_id,
    input wire          memrw_from_id,
    input wire [2:0]    wbsel_from_id,

    output reg [31:0]  pc_to_ex,
    output reg         regwen_to_ex,
    output reg [31:0]  data1_to_ex,
    output reg [31:0]  data2_to_ex,
    output reg [31:0]  imm_to_ex,
    output reg [4:0]   rd_to_ex,
    output reg         asel_to_ex,
    output reg         bsel_to_ex,
    output reg [3:0]   alusel_to_ex,
    output reg         memrw_to_ex,
    output reg [2:0]   wbsel_to_ex
    );
    
always @ (posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        pc_to_ex <= 32'b0;
        regwen_to_ex <= 1'b0;
        data1_to_ex <= 32'b0;
        data2_to_ex <= 32'b0;
        imm_to_ex <= 32'b0;
        rd_to_ex <= 5'b0;
        asel_to_ex <= 1'b0;
        bsel_to_ex <= 1'b0;
        alusel_to_ex <= 4'b0;
        memrw_to_ex <= 1'b0;
        wbsel_to_ex <= 3'b0;
    end
    else begin
        pc_to_ex <= pc_from_id;
        regwen_to_ex <= regwen_from_id;
        data1_to_ex <= data1_from_id;
        data2_to_ex <= data2_from_id;
        imm_to_ex <= imm_from_id;  
        rd_to_ex <= rd_from_id;    
        asel_to_ex <= asel_from_id; 
        bsel_to_ex <= bsel_from_id;  
        alusel_to_ex <= alusel_from_id;
        memrw_to_ex <= memrw_from_id;
        wbsel_to_ex <= wbsel_from_id;      
    end
end

endmodule
