`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/27 08:04:32
// Design Name: 
// Module Name: pc
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


module pc(
    input   wire        clk_i,
    input   wire        rst_n_i,
    input   wire [31:0] npc_i,
    output  wire [31:0] pc_o
    );

parameter pc_initial = 32'hffff_fffc;
reg [31:0] pc = pc_initial;   
reg start = 1'b0; 

assign pc_o = pc;

always @ (posedge clk_i or negedge rst_n_i) begin
    if(~rst_n_i) begin
        pc <= pc_initial;
    end
    else begin
        pc <= npc_i;
    end
end

endmodule
