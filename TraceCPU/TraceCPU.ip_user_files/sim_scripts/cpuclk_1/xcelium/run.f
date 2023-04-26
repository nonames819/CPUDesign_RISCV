-makelib xcelium_lib/xil_defaultlib -sv \
  "D:/tools/Vivado/Vivado/2018.3/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "D:/tools/Vivado/Vivado/2018.3/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../../TraceCPU.srcs/sources_1/ip/cpuclk_1/cpuclk_clk_wiz.v" \
  "../../../../TraceCPU.srcs/sources_1/ip/cpuclk_1/cpuclk.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

