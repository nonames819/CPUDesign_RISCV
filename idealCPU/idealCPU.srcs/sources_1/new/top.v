module top (
    input  wire         clk_i,
    input  wire         rst_i,
    // ���뿪�������ź�
    input  wire [23:0]  switch,
    // LED����ź�
    output wire [23:0]  led,
    // �˸�����ܵ�ʹ���ź�
    output wire [7:0]   led_en,
    // �������ʾ�����ź�
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

// ��CPU�ӳ���IO��·
wire [31:0]     io_addr;
wire            io_rd_e;
wire [31:0]     io_rd_data;
wire            io_wr_e;
wire [31:0]     io_wr_data;

// �����ڴ��IO��·
wire            mem_wr_e;
wire [31:0]     mem_addr;
wire [31:0]     mem_rd_data;
wire [31:0]     mem_wr_data;

// �������������IO��·
wire [11:0]     dev_addr;
wire [31:0]     dev_rd_data;
wire [31:0]     dev_wr_data;
wire            dev_rd_e;
wire            dev_wr_e;

assign io_rd_e = ~io_wr_e;  //��д�ź��෴

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

//IO���ߣ�����cpu���ڴ桢������źŴ���
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
//����RAM
dram U_dram (
    .clk    (clk_i          ),             
    .a      (waddr_tmp[15:2]),    
    .spo    (mem_rd_data    ),       
    .we     (mem_wr_e       ),         
    .d      (mem_wr_data    )        
);

// ���뿪������
dialswitch u_dialswitch (
    .clk    (clk_i      ),
    .rst_n  (rst_n      ),
    .rd_en  (dev_rd_e   ),
    .addr   (dev_addr   ),
    .switch (switch     ),
    .data_o (dev_rd_data) 
);

// LED��ʾ���� 
leddisplay U_leddisplay(
    .clk            (clk_i),
    .rst_n          (rst_n),
    .dv_wr_e        (dev_wr_e),
    .dv_addr        (dev_addr),
    .data_from_cpu   (dev_wr_data),
    .led            (led)
);

// �������ʾ����
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