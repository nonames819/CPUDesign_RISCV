-makelib ies_lib/xil_defaultlib -sv \
  "D:/tools/Vivado/Vivado/2018.3/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
-endlib
-makelib ies_lib/xpm \
  "D:/tools/Vivado/Vivado/2018.3/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../idealCPU.srcs/sources_1/ip/cpuclk_2/cpuclk_clk_wiz.v" \
  "../../../../idealCPU.srcs/sources_1/ip/cpuclk_2/cpuclk.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

