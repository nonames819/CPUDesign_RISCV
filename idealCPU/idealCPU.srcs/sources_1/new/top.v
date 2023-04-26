module top (
    input  wire         clk_i,
    input  wire         rst_i,
    // 拨码开关输入信号
    input  wire [23:0]  switch,
    // LED输出信号
    output wire [23:0]  led,
    // 八个数码管的使能信号
    output wire [7:0]   led_en,
    // 数码管显示控制信号
    output wire         led_ca,
    output wire         led_cb,
    output wire         led_cc,
    output wire         led_cd,
    output wire         led_ce,
    output wire         led_cf,
    output wire         led_cg,
    output wire         led_dp
);

wire rst_n = rst_i;
wire clk_out;
wire clk_lock;
wire [31:0] cpu_pc;
wire [31:0] prgrom_inst;

// 从CPU接出的IO线路
wire [31:0]     io_addr;
wire            io_rd_e;
wire [31:0]     io_rd_data;
wire            io_wr_e;
wire [31:0]     io_wr_data;

// 连接内存的IO线路
wire            mem_wr_e;
wire [31:0]     mem_addr;
wire [31:0]     mem_rd_data;
wire [31:0]     mem_wr_data;

// 连接其他外设的IO线路
wire [11:0]     dev_addr;
wire [31:0]     dev_rd_data;
wire [31:0]     dev_wr_data;
wire            dev_rd_e;
wire            dev_wr_e;

assign io_rd_e = ~io_wr_e;  //读写信号相反

prgrom u_imem(
    .a      (cpu_pc[15:2]     ),
    .spo    (prgrom_inst      )
);

mini_rv u_mini_rv(
    .clk                   (clk_i              ),
	.rst_n                 (rst_n              ),
	.pc_o                  (cpu_pc             ),
	.inst_i                (prgrom_inst        ),
	.io_addr_o             (io_addr            ),
	.io_data_i             (io_rd_data         ),
	.io_wen_o              (io_wr_e            ),
	.io_data_o             (io_wr_data         )
);

//IO总线，控制cpu与内存、外设的信号传递
bus u_bus(
    .addr_from_cpu   (io_addr       ),
    .data_from_cpu   (io_wr_data    ),
    .data_to_cpu     (io_rd_data    ),
    .to_cpu_en       (io_rd_e       ),      
    .from_cpu_en     (io_wr_e       ),    
    
    .mem_addr        (mem_addr      ),       
    .mem_rd_data     (mem_rd_data   ),
    .mem_wr_data     (mem_wr_data   ),
    .mem_wr_e        (mem_wr_e      ),

    .dv_addr         (dev_addr      ),
    .dv_wr_data      (dev_wr_data   ),
    .dv_rd_data      (dev_rd_data   ),
    .dv_wr_e         (dev_wr_e      ),
    .dv_rd_e         (dev_rd_e      )  
);

wire [31:0] waddr_tmp = mem_addr;// - 16'h4000;
//数据RAM
dram U_dram (
    .clk    (clk_i          ),             
    .a      (waddr_tmp[15:2]),    
    .spo    (mem_rd_data    ),       
    .we     (mem_wr_e       ),         
    .d      (mem_wr_data    )        
);

// 拨码开关输入
dialswitch u_dialswitch (
    .clk    (clk_i      ),
    .rst_n  (rst_n      ),
    .rd_en  (dev_rd_e   ),
    .addr   (dev_addr   ),
    .switch (switch     ),
    .data_o (dev_rd_data) 
);

// LED显示控制 
leddisplay U_leddisplay(
    .clk            (clk_i),
    .rst_n          (rst_n),
    .dv_wr_e        (dev_wr_e),
    .dv_addr        (dev_addr),
    .data_from_cpu   (dev_wr_data),
    .led            (led)
);

// 数码管显示控制
digitaldisplay u_digitaldisplay(
    .clk            (clk_i),
    .rst_n          (rst_n),
    .dv_wr_e        (dev_wr_e),
    .dv_addr        (dev_addr),
    .dv_data        (dev_wr_data),
    .led_en         (led_en),
    .led_ca         (led_ca),
    .led_cb         (led_cb),
    .led_cc         (led_cc),
    .led_cd         (led_cd),
    .led_ce         (led_ce),
    .led_cf         (led_cf),
    .led_cg         (led_cg),
    .led_dp         (led_dp)
);

endmodule