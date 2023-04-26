`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/01 09:16:14
// Design Name: 
// Module Name: bus
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


module bus(
    input   wire [31:0]     addr_from_cpu,
    input   wire [31:0]     data_from_cpu,
    output  wire [31:0]     data_to_cpu,
    input   wire            to_cpu_en,      //IO读使能
    input   wire            from_cpu_en,    //IO写使能
    
    output  wire [31:0]     mem_addr,       // 访问内存的地址
    input   wire [31:0]     mem_rd_data,    // 读内存数据
    output  wire [31:0]     mem_wr_data,    // 写内存数据
    output  wire            mem_wr_e,       // 写内存使能    
    
    output  wire [11:0]     dv_addr,        // 低位地址
    output  wire [31:0]     dv_wr_data,
    input   wire [31:0]     dv_rd_data,
    output  wire            dv_wr_e,
    output  wire            dv_rd_e         // 从外设读入的使能信号
    );
    
//判断目标设备是内存还是外设    
wire isMem = ~(addr_from_cpu[31:12] == 20'hFFFFF);    

//设置内存相关信号
assign mem_addr     = isMem ? addr_from_cpu : 32'hFFFFFFFF;
assign mem_wr_data  = (isMem & from_cpu_en) ? data_from_cpu : 32'b0;
assign mem_wr_e     = isMem & from_cpu_en;

//设置外设相关信号
assign dv_addr     = ~isMem ? addr_from_cpu[11:0] : 12'hFFF;
assign dv_wr_data  = (~isMem & from_cpu_en) ? data_from_cpu : 32'b0;
assign dv_rd_e     = ~isMem & to_cpu_en;
assign dv_wr_e     = ~isMem & from_cpu_en;

assign data_to_cpu = (to_cpu_en) ? (isMem ? mem_rd_data : dv_rd_data) : 32'b0;
    
    
endmodule
