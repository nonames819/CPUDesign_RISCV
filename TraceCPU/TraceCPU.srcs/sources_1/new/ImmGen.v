`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/27 10:14:02
// Design Name: 
// Module Name: immgen
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


module immgen(
    input   wire        rst_n_i,
    input   wire [2:0]  immsel_i,
    input   wire [24:0] inst_i,
    output  wire [31:0] imm_o
    );
    
localparam  I = 3'b000,
            S = 3'b001,
            B = 3'b010,
            U = 3'b011,
            J = 3'b100;
            
reg [31:0] imm;
assign imm_o = imm;

always @ (*) begin
    if(~rst_n_i) begin
        imm = 32'b0;
    end
    else if(immsel_i == I) begin
        imm = {{21{inst_i[24]}},inst_i[23:13]};
    end
    else if(immsel_i == S) begin
        imm = {{21{inst_i[24]}},inst_i[23:18],inst_i[4:0]};
    end
    else if(immsel_i == B) begin
        imm = {{20{inst_i[24]}},inst_i[0],inst_i[23:18],inst_i[4:1],1'b0};
    end
    else if(immsel_i == U) begin
        imm = {inst_i[24:5],12'b0};
    end
    else if(immsel_i == J) begin
        imm = {{12{inst_i[24]}},inst_i[12:5],inst_i[13],inst_i[23:14],1'b0};
    end
    else begin
        imm = 32'b0;
    end
end

endmodule
