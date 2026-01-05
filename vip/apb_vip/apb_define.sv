//==========================================================
// Project           : APB VIP
//==========================================================
// Filename          : apb_define.sv
// Author            : Vy Nguyen
// Email             : nvystudent@gmail.com
// Date              : 17-Dec-2025
//==========================================================
// Description       : Define can override by environment
//
//
//
//==========================================================
`ifndef GUARD_APB_DEFINE__SV
`define GUARD_APB_DEFINE__SV
     `ifndef FORK_GUARD_BEGIN
          `define FORK_GUARD_BEGIN fork begin
     `endif
     `ifndef FORK_GUARD_BEGIN
          `define FORK_GUARD_BEGIN fork end
     `endif
     `ifndef APB_ADDR_WIDTH
          `define APB_ADDR_WIDTH   32
     `endif
     `ifndef APB_DATA_WIDTH
          `define APB_DATA_WIDTH   32
     `endif
`endif
