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
`ifndef GUARD_APB_PACKAGE__SV
`define GUARD_APB_PACKAGE__SV
package apb_pkg;
     import uvm_pkg::*;
     `include "apb_define.sv"
     `include "apb_configuration.sv"
     `include "apb_transaction.sv"
     `include "apb_sequencer.sv"
     `include "apb_driver.sv"
     `include "apb_monitor.sv"
     `include "apb_agent.sv"
endpackage: apb_pkg

`endif
