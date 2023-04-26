`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/11 10:34:18
// Design Name: 
// Module Name: cpuclk_sim
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


module cpuclk_sim();
// input
    reg fpga_clk = 0;
    reg fpga_rst = 0;
    // output
    wire clk_lock;
    wire pll_clk;
    wire cpu_clk;
    wire cpu_rst;
    wire [7: 0] led_en;
    wire led_ca;
    wire led_cb;
    wire led_cc;
    wire led_cd;
    wire led_ce;
    wire led_cf;
    wire led_cg;
    wire led_dp;
    reg [31:0] switch = 32'b0;
    wire [31:0] led = 32'b0;
    
    always #5 fpga_clk = ~fpga_clk;

    cpuclk UCLK (
        .clk_in1    (fpga_clk),
        .locked     (clk_lock),
        .clk_out1   (pll_clk)
    );

    assign cpu_clk = pll_clk & clk_lock;
    assign cpu_rst = ~fpga_rst;
    
    initial begin
        fpga_rst = 1;
        #20;
        fpga_rst = 0;
        switch = 24'h000fff;
        #10000;
        $finish;
    end
    
    top u_top(
        .clk_i  (cpu_clk), 
        .rst_i  (cpu_rst), 
        .switch (switch ),
        .led    (led    ),   
        .led_en (led_en ),
        .led_ca (led_ca ),
        .led_cb (led_cb ),
        .led_cc (led_cc ),
        .led_cd (led_cd ),
        .led_ce (led_ce ),
        .led_cf (led_cf ),
        .led_cg (led_cg ),
        .led_dp (led_dp ) 
    );

endmodule
