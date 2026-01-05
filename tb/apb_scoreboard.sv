`uvm_analysis_imp_decl(_axi)
`uvm_analysis_imp_decl(_apb)

class apb_scoreboard extends uvm_scoreboard;
     `uvm_component_utils (apb_scoreboard)

     uvm_analysis_imp_axi #(axi_transaction, apb_scoreboard) axi_item_exp;
     uvm_analysis_imp_apb #(apb_transaction, apb_scoreboard) apb_item_exp;
     apb_configuration apb_config;
     apb_transaction apb_write_queue[$];
     apb_transaction apb_read_queue[$];
     int count_beat = -1;
     int error = 0;
     int incr_byte;
     
     `include "apb_coverage.sv"

     function new (string name = "apb_scoreboard", uvm_component parent);
          super.new(name, parent);
          APB_IP = new();
     endfunction: new

     virtual function void build_phase (uvm_phase phase);
          super.build_phase (phase);
          axi_item_exp = new("axi_item_exp", this);
          apb_item_exp = new("apb_item_exp", this);
          if (!uvm_config_db#(apb_configuration)::get(this,"", "apb_config", apb_config))
               `uvm_fatal(get_type_name(), $sformatf("Failed to get apb_config from uvm_config_db"))
          `uvm_info(get_type_name(), $sformatf("Build_phase done!"), UVM_LOW)
     endfunction: build_phase

     virtual task run_phase (uvm_phase phase);
     endtask: run_phase

     virtual function void write_axi (axi_transaction axi_trans);
          //`uvm_info(get_type_name(), $sformatf("AXI capture: %0h", axi_trans.sprint()), UVM_LOW)
          if (axi_trans.xact_type == axi_transaction::WRITE) begin
               check_error(0, axi_trans);
               compare_write(axi_trans);
          end
          if (axi_trans.xact_type == axi_transaction::READ) begin
               check_error(count_beat, axi_trans);
               compare_read(axi_trans);
          end
          APB_IP.sample(axi_trans);
     endfunction: write_axi
     
     virtual function void check_error (int count, axi_transaction axi_trans);
          if (apb_config.error == apb_configuration::ERROR)
               if (axi_trans.error[count] == axi_transaction::SLVERR)
                    `uvm_info(get_type_name(), $sformatf("Response data is correct "), UVM_LOW)
               else begin
                    `uvm_error(get_type_name(), "Response data isn't correct")
                    error +=1;
               end
          else
               if (axi_trans.error[count] == axi_transaction::OKAY)     
                    `uvm_info(get_type_name(), $sformatf("Response data is correct "), UVM_LOW)
               else begin
                    `uvm_error(get_type_name(), "Response data isn't correct")
                    error +=1;
               end
     endfunction: check_error

     virtual function void write_apb (apb_transaction apb_trans);
          //`uvm_info(get_type_name(), $sformatf("APB capture: %0h", apb_trans.sprint()), UVM_LOW)
          count_beat++;
          if (apb_trans.xact_type == apb_transaction::WRITE) begin
               apb_write_queue.push_back(apb_trans);
               `uvm_info(get_type_name(), "Added to APB write queue", UVM_HIGH)
          end
          else begin
               apb_read_queue.push_back(apb_trans);
               `uvm_info(get_type_name(), "Added to APB read queue", UVM_HIGH)
          end  
     endfunction: write_apb

     virtual function void compare_write(axi_transaction axi_trans);
          apb_transaction apb_trans;
          bit [31:0] exp_addr;
          int count_write = 0;
         
          for (int i = 0; i < axi_trans.len + 1; i++)
          begin
               apb_trans = apb_write_queue.pop_front();
               exp_addr = expected_address(axi_trans, count_write);
               notion(apb_trans, axi_trans, exp_addr, count_write);
               count_write++;
          end
          if (count_beat > axi_trans.len + 1)
               count_beat = count_beat - axi_trans.len - 1;
          if (error !=0) begin
               `uvm_info(get_type_name(), "-----------------------", UVM_HIGH)
               `uvm_info(get_type_name(), "--    TEST FAILED    --", UVM_HIGH)
               `uvm_info(get_type_name(), "-----------------------", UVM_HIGH)
          end
          else begin
               `uvm_info(get_type_name(), "-----------------------", UVM_HIGH)
               `uvm_info(get_type_name(), "--    TEST PASSED    --", UVM_HIGH)
               `uvm_info(get_type_name(), "-----------------------", UVM_HIGH)
          end
     endfunction

     virtual function void compare_read(axi_transaction axi_trans);
          apb_transaction apb_trans;
          bit [31:0] exp_addr;
          int count_read = 0;
          for (int i = 0; i < axi_trans.len + 1; i++)
          begin
               apb_trans = apb_read_queue.pop_front();
               exp_addr = expected_address(axi_trans, count_read);
               case (axi_trans.size_type)
                    axi_transaction::BYTE_1: apb_trans.data = {24'h00, apb_trans.data[7:0]};
                    axi_transaction::BYTE_2: apb_trans.data = {16'h00, apb_trans.data[15:0]};
                    axi_transaction::BYTE_4: apb_trans.data = apb_trans.data[31:0];
               endcase
               notion(apb_trans, axi_trans, exp_addr, count_read);
               count_read++;
          end
          if (count_beat > axi_trans.len + 1)
               count_beat = count_beat - axi_trans.len - 1;
          if (error !=0) begin
               `uvm_info(get_type_name(), "-----------------------", UVM_HIGH)
               `uvm_info(get_type_name(), "--    TEST FAILED    --", UVM_HIGH)
               `uvm_info(get_type_name(), "-----------------------", UVM_HIGH)
          end
          else begin
               `uvm_info(get_type_name(), "-----------------------", UVM_HIGH)
               `uvm_info(get_type_name(), "--    TEST PASSED    --", UVM_HIGH)
               `uvm_info(get_type_name(), "-----------------------", UVM_HIGH)
          end
     endfunction
     
     virtual function void notion(apb_transaction apb_trans, axi_transaction axi_trans, bit [31:0] exp_addr, int count);
          bit [31:0] exp_data;
          if (apb_trans.addr != exp_addr) begin
               `uvm_error(get_type_name(), $sformatf("Address is not matching. Exp: %0h. Act: %0h", exp_addr, apb_trans.addr));
               error+=1;
          end
          else
               `uvm_info(get_type_name(), "Address is matching", UVM_HIGH)
          if ((apb_trans.addr >= 32'h00) && (apb_trans.addr <= 32'hFFF))
               if (apb_trans.psel != apb_transaction::PSEL1)
               begin
                    `uvm_error(get_type_name(), $sformatf("PSEL is not matching"))
                    error+=1;
               end
               else
                    `uvm_info(get_type_name(), $sformatf("PSEL is matching"), UVM_HIGH)
          else if ((apb_trans.addr >= 32'h1000) && (apb_trans.addr <= 32'h1FFF))
               if (apb_trans.psel != apb_transaction::PSEL2)
                    `uvm_error(get_type_name(), $sformatf("PSEL is not matching. PSEL: %0b", apb_trans.psel))
               else
                     `uvm_info(get_type_name(), $sformatf("PSEL is matching"), UVM_HIGH)
          else if ((apb_trans.addr >= 32'h2000) && (apb_trans.addr <= 32'h2FFF))
               if (apb_trans.psel != apb_transaction::PSEL3)
               begin
                    `uvm_error(get_type_name(), $sformatf("PSEL is not matching"))
                    error+=1;
               end
               else
                    `uvm_info(get_type_name(), $sformatf("PSEL is matching"), UVM_HIGH)
          else begin
               `uvm_error(get_type_name(), $sformatf("PSEL is not matching"))
               error += 1;
          end
          case (incr_byte)
               1: exp_data = axi_trans.data[count][7:0];
               2: exp_data = axi_trans.data[count][15:0];
               4: exp_data = axi_trans.data[count][31:0];
          endcase
          if (apb_trans.strb != axi_trans.strb[count]) begin
               `uvm_error(get_type_name(), $sformatf("Strobe is not matching. Exp: %0h. Act: %0h", axi_trans.strb[count], apb_trans.strb));
               error+=1;
          end
          else 
               `uvm_info(get_type_name(), "Strobe is matching", UVM_HIGH)
          if (apb_trans.data != exp_data) begin
               `uvm_error(get_type_name(), $sformatf("Data is not matching. Exp: %0h. Act: %0h", exp_data, apb_trans.data));
               error+=1;
          end
          else
               `uvm_info(get_type_name(), "Data is matching", UVM_HIGH)
     endfunction  

     virtual function bit [31:0] expected_address (axi_transaction trans, int count);
          bit [31:0] apb_addr    ;
          bit [31:0] wrap_size   ;
          bit [31:0] wrap_base   ;
          bit [31:0] addr_incr   ;
          bit [31:0] wrap_offset ;
          case (trans.size_type)
               axi_transaction::BYTE_1: incr_byte = 1;
               axi_transaction::BYTE_2: incr_byte = 2;
               axi_transaction::BYTE_4: incr_byte = 4;
               default: incr_byte = 1;
          endcase
          wrap_size   = (trans.len + 32'h01)*incr_byte - 1  ;
          wrap_base   = trans.addr & (~wrap_size)           ;
          addr_incr   = trans.addr + (count * incr_byte)    ;
          wrap_offset = addr_incr & wrap_size               ;
          case (trans.burst_type)
               axi_transaction::FIXED: apb_addr = trans.addr               ;
               axi_transaction::INCR:  apb_addr = addr_incr                ;
               axi_transaction::WRAP:  apb_addr = wrap_base | wrap_offset  ;
               default:                apb_addr = trans.addr               ;
          endcase
          return apb_addr;
     endfunction
endclass: apb_scoreboard

