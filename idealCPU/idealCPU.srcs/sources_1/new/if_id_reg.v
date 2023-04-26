`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/07 09:50:04
// Design Name: 
// Module Name: if_id_reg
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


module if_id_reg(
    input wire          clk,
    input wire          rst_n,
    input wire [31:0]   pc_from_if,
    input wire [31:0]   inst_from_if,
    output reg [31:0]   pc_to_id,
    output reg [31:0]   inst_to_id
    );

always @ (posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        pc_to_id <= 32'b0;
        inst_to_id <= 32'b0;
    end
    else begin
        pc_to_id <= pc_from_if;
        inst_to_id <= inst_from_if;        
    end
end

endmodule
