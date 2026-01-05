//==========================================================
// Project           : AXI_to_APB_bridge
//==========================================================
// Filename          : test_pkg.sv
// Author            : Vy Nguyen
// Email             : nvystudent@gmail.com
// Date              : 17-Dec-2025
//==========================================================
// Description       : Define can override by environment
//
//
//
//==========================================================
`ifndef GUARD_APB_TEST_PKG__SV
`define GUARD_APB_TEST_PKG__SV

package test_pkg;
     import uvm_pkg::*;
     import axi_pkg::*;
     import apb_pkg::*;
     import seq_pkg::*;
     import env_pkg::*;

     `include "apb_base_test.sv"

     `include "wr_fixed_psel1_1byte_no_error_test.sv"
     `include "wr_fixed_psel1_2byte_no_error_test.sv"
     `include "wr_fixed_psel1_4byte_no_error_test.sv"
     `include "wr_fixed_psel2_1byte_no_error_test.sv"
     `include "wr_fixed_psel2_2byte_no_error_test.sv"
     `include "wr_fixed_psel2_4byte_no_error_test.sv"
     `include "wr_fixed_psel3_1byte_no_error_test.sv"
     `include "wr_fixed_psel3_2byte_no_error_test.sv"
     `include "wr_fixed_psel3_4byte_no_error_test.sv"
     `include "wr_fixed_psel1_4byte_error_test.sv"
     `include "wr_fixed_psel2_4byte_error_test.sv"
     `include "wr_fixed_psel3_4byte_error_test.sv"
     `include "multiple_wr_fixed_test.sv"

     `include "wr_incr_psel1_1byte_no_error_test.sv"
     `include "wr_incr_psel1_2byte_no_error_test.sv"
     `include "wr_incr_psel1_4byte_no_error_test.sv"
     `include "wr_incr_psel2_1byte_no_error_test.sv"
     `include "wr_incr_psel2_2byte_no_error_test.sv"
     `include "wr_incr_psel2_4byte_no_error_test.sv"
     `include "wr_incr_psel3_1byte_no_error_test.sv"
     `include "wr_incr_psel3_2byte_no_error_test.sv"
     `include "wr_incr_psel3_4byte_no_error_test.sv"
     `include "wr_incr_psel1_4byte_error_test.sv"
     `include "wr_incr_psel2_4byte_error_test.sv"
     `include "wr_incr_psel3_4byte_error_test.sv"
     `include "wr_incr_psel12_4byte_no_error_test.sv"
     `include "wr_incr_psel23_4byte_no_error_test.sv"
     `include "wr_incr_psel12_4byte_error_test.sv"
     `include "wr_incr_psel23_4byte_error_test.sv"
     `include "multiple_wr_incr_test.sv"

     `include "wr_wrap_psel1_1byte_no_error_test.sv"
     `include "wr_wrap_psel1_2byte_no_error_test.sv"
     `include "wr_wrap_psel1_4byte_no_error_test.sv"
     `include "wr_wrap_psel2_1byte_no_error_test.sv"
     `include "wr_wrap_psel2_2byte_no_error_test.sv"
     `include "wr_wrap_psel2_4byte_no_error_test.sv"
     `include "wr_wrap_psel3_1byte_no_error_test.sv"
     `include "wr_wrap_psel3_2byte_no_error_test.sv"
     `include "wr_wrap_psel3_4byte_no_error_test.sv"
     `include "wr_wrap_psel1_4byte_error_test.sv"
     `include "wr_wrap_psel2_4byte_error_test.sv"
     `include "wr_wrap_psel3_4byte_error_test.sv"
     `include "wr_wrap_psel12_4byte_no_error_test.sv"
     `include "wr_wrap_psel23_4byte_no_error_test.sv"
     `include "wr_wrap_psel12_4byte_error_test.sv"
     `include "wr_wrap_psel23_4byte_error_test.sv"
     `include "multiple_wr_wrap_test.sv"

     `include "rd_fixed_psel1_1byte_no_error_test.sv"
     `include "rd_fixed_psel1_2byte_no_error_test.sv"
     `include "rd_fixed_psel1_4byte_no_error_test.sv"
     `include "rd_fixed_psel2_1byte_no_error_test.sv"
     `include "rd_fixed_psel2_2byte_no_error_test.sv"
     `include "rd_fixed_psel2_4byte_no_error_test.sv"
     `include "rd_fixed_psel3_1byte_no_error_test.sv"
     `include "rd_fixed_psel3_2byte_no_error_test.sv"
     `include "rd_fixed_psel3_4byte_no_error_test.sv"
     `include "rd_fixed_psel1_4byte_error_test.sv"
     `include "rd_fixed_psel2_4byte_error_test.sv"
     `include "rd_fixed_psel3_4byte_error_test.sv"
     `include "multiple_rd_fixed_test.sv"

     `include "rd_incr_psel1_1byte_no_error_test.sv"
     `include "rd_incr_psel1_2byte_no_error_test.sv"
     `include "rd_incr_psel1_4byte_no_error_test.sv"
     `include "rd_incr_psel2_1byte_no_error_test.sv"
     `include "rd_incr_psel2_2byte_no_error_test.sv"
     `include "rd_incr_psel2_4byte_no_error_test.sv"
     `include "rd_incr_psel3_1byte_no_error_test.sv"
     `include "rd_incr_psel3_2byte_no_error_test.sv"
     `include "rd_incr_psel3_4byte_no_error_test.sv"
     `include "rd_incr_psel1_4byte_error_test.sv"
     `include "rd_incr_psel2_4byte_error_test.sv"
     `include "rd_incr_psel3_4byte_error_test.sv"
     `include "rd_incr_psel12_4byte_no_error_test.sv"
     `include "rd_incr_psel23_4byte_no_error_test.sv"
     `include "rd_incr_psel12_4byte_error_test.sv"
     `include "rd_incr_psel23_4byte_error_test.sv"
     `include "multiple_rd_incr_test.sv"

     `include "rd_wrap_psel1_1byte_no_error_test.sv"
     `include "rd_wrap_psel1_2byte_no_error_test.sv"
     `include "rd_wrap_psel1_4byte_no_error_test.sv"
     `include "rd_wrap_psel2_1byte_no_error_test.sv"
     `include "rd_wrap_psel2_2byte_no_error_test.sv"
     `include "rd_wrap_psel2_4byte_no_error_test.sv"
     `include "rd_wrap_psel3_1byte_no_error_test.sv"
     `include "rd_wrap_psel3_2byte_no_error_test.sv"
     `include "rd_wrap_psel3_4byte_no_error_test.sv"
     `include "rd_wrap_psel1_4byte_error_test.sv"
     `include "rd_wrap_psel2_4byte_error_test.sv"
     `include "rd_wrap_psel3_4byte_error_test.sv"
     `include "rd_wrap_psel12_4byte_no_error_test.sv"
     `include "rd_wrap_psel23_4byte_no_error_test.sv"
     `include "rd_wrap_psel12_4byte_error_test.sv"
     `include "rd_wrap_psel23_4byte_error_test.sv"
     `include "multiple_rd_wrap_test.sv"

     `include "wr_rd_random_test.sv"
endpackage: test_pkg
`endif
