//==========================================================
// Project           : AXI VIP
//==========================================================
// Filename          : axi_define.sv
// Author            : Vy Nguyen
// Email             : nvystudent@gmail.com
// Date              : 17-Dec-2025
//==========================================================
// Description       : Define can override by environment
//
//
//
//==========================================================
`ifndef GUARD_AXI_DEFINE__SV
`define GUARD_AXI_DEFINE__SV
     `ifndef FORK_GUARD_BEGIN
          `define FORK_GUARD_BEGIN fork begin
     `endif
     `ifndef FORK_GUARD_BEGIN
          `define FORK_GUARD_BEGIN fork end
     `endif
     `ifndef AXI_ADDR_WIDTH
          `define AXI_ADDR_WIDTH   32
     `endif
     `ifndef AXI_DATA_WIDTH
          `define AXI_DATA_WIDTH   32
     `endif
`endif
