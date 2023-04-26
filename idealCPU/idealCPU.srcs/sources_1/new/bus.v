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
    input   wire            to_cpu_en,      //IO��ʹ��
    input   wire            from_cpu_en,    //IOдʹ��
    
    output  wire [31:0]     mem_addr,       // �����ڴ�ĵ�ַ
    input   wire [31:0]     mem_rd_data,    // ���ڴ�����
    output  wire [31:0]     mem_wr_data,    // д�ڴ�����
    output  wire            mem_wr_e,       // д�ڴ�ʹ��    
    
    output  wire [11:0]     dv_addr,        // ��λ��ַ
    output  wire [31:0]     dv_wr_data,
    input   wire [31:0]     dv_rd_data,
    output  wire            dv_wr_e,
    output  wire            dv_rd_e         // ����������ʹ���ź�
    );
    
//�ж�Ŀ���豸���ڴ滹������    
wire isMem = ~(addr_from_cpu[31:12] == 20'hFFFFF);    

//�����ڴ�����ź�
assign mem_addr     = isMem ? addr_from_cpu : 32'hFFFFFFFF;
assign mem_wr_data  = (isMem & from_cpu_en) ? data_from_cpu : 32'b0;
assign mem_wr_e     = isMem & from_cpu_en;

//������������ź�
assign dv_addr     = ~isMem ? addr_from_cpu[11:0] : 12'hFFF;
assign dv_wr_data  = (~isMem & from_cpu_en) ? data_from_cpu : 32'b0;
assign dv_rd_e     = ~isMem & to_cpu_en;
assign dv_wr_e     = ~isMem & from_cpu_en;

assign data_to_cpu = (to_cpu_en) ? (isMem ? mem_rd_data : dv_rd_data) : 32'b0;
    
    
endmodule
