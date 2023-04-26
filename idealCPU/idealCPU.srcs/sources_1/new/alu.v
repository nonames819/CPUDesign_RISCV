`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/27 08:03:29
// Design Name: 
// Module Name: ALU
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


module alu(
    input  wire         rst_n_i,
    input  wire[31:0]   data1_i,
    input  wire[31:0]   data2_i,
    input  wire[31:0]   imm_i,
    input  wire[31:0]   pc_i,
    input  wire         asel_i,
    input  wire         bsel_i,
    input  wire [3:0]   alusel_i,
    output wire [31:0]  c_o
    );
localparam  ADD = 4'b0000,
            SUB = 4'b00001,
            AND = 4'b0010,
            OR  = 4'b0011,
            XOR = 4'b0100,
            SLL = 4'b0101,
            SRL = 4'b0110,
            SRA = 4'b0111,
            LUI = 4'b1000;

reg [31:0] num1 = 32'b0;
reg [31:0] num2 = 32'b0;
reg [31:0] c    = 32'b0;
reg [4:0]  move = 5'b0;

assign c_o = c;


always @ (*) begin
    if(asel_i == 0) begin
        num1 = data1_i; 
    end
    else begin
        num1 = pc_i;
    end
    if(bsel_i == 0) begin
        num2 = data2_i; 
    end
    else begin
        num2 = imm_i;
    end
    if(~rst_n_i) begin
        c = 32'b0;
    end
    else if(alusel_i == ADD) begin
        c = num1 + num2;
    end
    else if(alusel_i == SUB) begin
        c = num1 - num2;
    end
    else if(alusel_i == AND) begin
        c = num1 & num2;
    end
    else if(alusel_i == OR) begin
        c = num1 | num2;
    end
    else if(alusel_i == XOR) begin
        c = num1 ^ num2;
    end
    else if(alusel_i == SLL) begin
        c = num1 << num2[4:0];
    end
    else if(alusel_i == SRL) begin
        c = num1 >> num2[4:0];
    end
    else if(alusel_i == SRA) begin
        c = $signed(num1) >>> $unsigned(num2[4:0]);
    end
    else if(alusel_i == LUI) begin
        c = num2;
    end
    else begin
        c = 32'b0;
    end
end


endmodule
