`ifndef APB_COVERAGE_SV
`define APB_COVERAGE_SV
`uvm_analysis_imp_decl(_axi)
`uvm_analysis_imp_decl(_apb)

class apb_coverage extends uvm_component;
     `uvm_component_utils(apb_coverage)

     uvm_analysis_imp_axi #(axi_transaction, apb_coverage) axi_imp;
     uvm_analysis_imp_apb #(apb_transaction, apb_coverage) apb_imp;

     axi_transaction axi_item;
     apb_transaction apb_item;

     covergroup axi_cover;
          option.per_instance = 1;
          option.name = "axi_coverage";

          axi_transfer: coverpoint axi_item.xact_type {
               bins axi_write = {axi_transaction::WRITE};
               bins axi_read  = {axi_transaction::READ};
          }
          axi_size: coverpoint axi_item.size_type {
               bins BYTE = {axi_transaction::BYTE_1};
               bins HALF = {axi_transaction::BYTE_2};
               bins WORD = {axi_transaction::BYTE_4};
          }
          axi_burst: coverpoint axi_item.burst_type {
               bins FIXED = {axi_transaction::FIXED};
               bins INCR  = {axi_transaction::INCR};
               bins WRAP  = {axi_transaction::WRAP};
          }
          axi_len: coverpoint axi_item.len {
               bins len = {[0:18]};
          }
          xact_burst: cross axi_transfer, axi_burst;
          burst_size: cross axi_burst, axi_size;
          burst_len:  cross axi_burst, axi_len;
     endgroup
     covergroup apb_cover;
          option.per_instance = 1;
          option.name = "apb_coverage";

          apb_transfer: coverpoint apb_item.xact_type {
               bins apb_write = {apb_transaction::WRITE};
               bins apb_read  = {apb_transaction::READ};
          }
          apb_psel: coverpoint apb_item.psel {
               bins psel1 = {apb_transaction::PSEL1};
               bins psel2 = {apb_transaction::PSEL2};
               bins psel3 = {apb_transaction::PSEL3};
          }
          apb_error: coverpoint apb_item.error {
               bins no_error = {apb_transaction::NO_ERROR};
               bins error    = {apb_transaction::ERROR};
          }
          xact_psel: cross apb_transfer, apb_psel;
          xact_error: cross apb_transfer, apb_error;
     endgroup
     function new(string name="apb_coverage", uvm_component parent = null);
          super.new(name, parent);
          axi_cover = new();
          apb_cover = new();
          axi_imp   = new("axi_imp", this);
          apb_imp   = new("apb_imp", this);
     endfunction
     function void build_phase(uvm_phase phase);
          super.build_phase(phase);
     endfunction
     virtual function void write_axi(axi_transaction trans);
          axi_item = trans;
          axi_cover.sample();
     endfunction
     virtual function void write_apb(apb_transaction trans);
          apb_item = trans;
          apb_cover.sample();
    endfunction
endclass
`endif
