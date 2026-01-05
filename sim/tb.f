+incdir+${APB_IP_VERIF_PATH}/sequences
+incdir+${APB_IP_VERIF_PATH}/testcases
+incdir+${APB_IP_VERIF_PATH}/tb

// Compilation VIP design (agent) list
-f ${AXI_VIP_ROOT}/axi_vip.f
-f ${APB_VIP_ROOT}/apb_vip.f

// Compilation Environment
${APB_IP_VERIF_PATH}/tb/env_pkg.sv
${APB_IP_VERIF_PATH}/sequences/seq_pkg.sv
${APB_IP_VERIF_PATH}/testcases/test_pkg.sv
${APB_IP_VERIF_PATH}/tb/testbench.sv

