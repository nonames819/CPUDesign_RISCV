`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/05 11:08:47
// Design Name: 
// Module Name: leddisplay
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


module leddisplay(
    input wire          clk,
    input wire          rst_n,
    input wire          dv_wr_e,   
    input wire [11:0]   dv_addr,   
    input wire [31:0]   data_from_cpu,
    output reg [23:0]   led
    );
    
wire work = dv_wr_e & (dv_addr == 12'h060);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        led <= 24'b0;
    end
    else if(work) begin
        led <= data_from_cpu[23:0];
    end
    else begin
        led <= led;
    end
end


endmodule
