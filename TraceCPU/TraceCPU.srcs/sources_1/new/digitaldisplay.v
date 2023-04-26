`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/05 11:14:23
// Design Name: 
// Module Name: digitaldisplay
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


module digitaldisplay(
    input   wire        clk,
    input   wire        rst_n,
    input   wire        dv_wr_e,
    input   wire [11:0] dv_addr,
    input   wire [31:0] dv_data,

    output  reg  [ 7:0]  led_en,
    output  reg          led_ca,
    output  reg          led_cb,
    output  reg          led_cc,
    output  reg          led_cd,
    output  reg          led_ce,
    output  reg          led_cf,
    output  reg          led_cg,
    output  wire         led_dp
    );

localparam  ZERO    = 7'b1000000, 
            ONE     = 7'b1111001, 
            TWO     = 7'b0100100, 
            THREE   = 7'b0110000, 
            FOUR    = 7'b0011001,
            FIVE    = 7'b0010010, 
            SIX     = 7'b0000010, 
            SEVEN   = 7'b1111000, 
            EIGHT   = 7'b0000000, 
            NINE    = 7'b0011000,
            A       = 7'b0001000, 
            B       = 7'b0000011, 
            C       = 7'b0100111, 
            D       = 7'b0100001, 
            E       = 7'b0000110, 
            F       = 7'b0001110,
            NONE    = 7'b1111111;
localparam  crcle   = 10000;

reg [15:0] cnt;  //计时器

reg [2:0]  led_num;
reg [31:0] dig_reg; //存放数码管显示数据

wire before_end = (cnt == crcle - 2); //计时器结束一个周期前更换输出位置
wire cnt_end    = (cnt == crcle - 1); //计时器经历一个周期
wire cnt_inc    = (cnt < crcle - 1);  //计时器增长


//工作信号
wire work = dv_wr_e & (dv_addr == 12'h000);

assign led_dp = 1'b1;

always @(posedge clk or negedge rst_n) begin
    if(~rst_n)          dig_reg <= 32'b0;
    else if  (work)    dig_reg <= dv_data;
    else               dig_reg <= dig_reg; //保持显示
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n)           cnt <= 16'h0000;
    else if  (cnt_inc)  cnt <= cnt+16'h0001;
    else                cnt <= 16'h0000; //计数器复位
end


always@(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        led_en  <= 8'b11111111;
        led_num <= 4'd7;
        {led_cg, led_cf, led_ce, led_cd, led_cc, led_cb, led_ca} <= NONE;
        end     // end if(~rst_n)
    else begin
        if (before_end) begin
            if (led_num == 4'd7)begin
                led_en <= 8'b01111111;//从最高位开始
            end
            else begin
                led_en <= {led_en[0], led_en[7:1]}; //选择下一位输出
            end
            //选出这一位上的4位2进制数据
            case({dig_reg[4*led_num + 3], dig_reg[4*led_num + 2], dig_reg[4*led_num + 1], dig_reg[4*led_num] })
                4'h0:   {led_cg, led_cf, led_ce, led_cd, led_cc, led_cb, led_ca} <= ZERO ;
                4'h1:   {led_cg, led_cf, led_ce, led_cd, led_cc, led_cb, led_ca} <= ONE ;
                4'h2:   {led_cg, led_cf, led_ce, led_cd, led_cc, led_cb, led_ca} <= TWO;
                4'h3:   {led_cg, led_cf, led_ce, led_cd, led_cc, led_cb, led_ca} <= THREE;
                4'h4:   {led_cg, led_cf, led_ce, led_cd, led_cc, led_cb, led_ca} <= FOUR;
                4'h5:   {led_cg, led_cf, led_ce, led_cd, led_cc, led_cb, led_ca} <= FIVE;
                4'h6:   {led_cg, led_cf, led_ce, led_cd, led_cc, led_cb, led_ca} <= SIX;
                4'h7:   {led_cg, led_cf, led_ce, led_cd, led_cc, led_cb, led_ca} <= SEVEN;
                4'h8:   {led_cg, led_cf, led_ce, led_cd, led_cc, led_cb, led_ca} <= EIGHT;
                4'h9:   {led_cg, led_cf, led_ce, led_cd, led_cc, led_cb, led_ca} <= NINE;
                4'hA:   {led_cg, led_cf, led_ce, led_cd, led_cc, led_cb, led_ca} <= A;
                4'hB:   {led_cg, led_cf, led_ce, led_cd, led_cc, led_cb, led_ca} <= B;
                4'hC:   {led_cg, led_cf, led_ce, led_cd, led_cc, led_cb, led_ca} <= C;
                4'hD:   {led_cg, led_cf, led_ce, led_cd, led_cc, led_cb, led_ca} <= D;
                4'hE:   {led_cg, led_cf, led_ce, led_cd, led_cc, led_cb, led_ca} <= E;
                4'hF:   {led_cg, led_cf, led_ce, led_cd, led_cc, led_cb, led_ca} <= F;
                default:    {led_cg, led_cf, led_ce, led_cd, led_cc, led_cb, led_ca} <= NONE;
                endcase
            end     //end if (before_end)
        else if (cnt_end) begin
            if (led_num == 4'b0)    led_num <= 4'd7;
            else                    led_num <= led_num - 4'd1;
            end     //end if (cnt_end)
        end
end


endmodule
