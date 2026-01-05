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
`ifndef GUARD_AXI_PACKAGE__SV
`define GUARD_AXI_PACKAGE__SV
package axi_pkg;
     import uvm_pkg::*;
     `include "axi_define.sv"
     `include "axi_transaction.sv"
     `include "axi_sequencer.sv"
     `include "axi_driver.sv"
     `include "axi_monitor.sv"
     `include "axi_agent.sv"
endpackage: axi_pkg
`endif
