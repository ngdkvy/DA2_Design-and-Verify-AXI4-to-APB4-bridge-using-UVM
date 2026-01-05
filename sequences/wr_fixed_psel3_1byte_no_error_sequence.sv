class wr_fixed_psel3_1byte_no_error_sequence extends uvm_sequence #(axi_transaction);
     `uvm_object_utils(wr_fixed_psel3_1byte_no_error_sequence)

     function new (string name="wr_fixed_psel3_1byte_no_error_sequence");
          super.new(name);
     endfunction

     virtual task body();
          bit [31:0] addr_tmp;

          req = axi_transaction::type_id::create("req");
          start_item(req);
          addr_tmp = $urandom_range(32'h2000, 32'h2FFF);
          req.randomize() with {addr         == addr_tmp;
                                xact_type    == axi_transaction::WRITE;
                                burst_type   == axi_transaction::FIXED;
                                size_type    == axi_transaction::BYTE_1;};
          `uvm_info(get_type_name(), $sformatf("Send req to driver: \n %s", req.sprint()), UVM_LOW);
          finish_item(req);
          get_response(rsp);
          #10us;
          `uvm_info(get_type_name(), $sformatf("Recevied rsp to driver: \n %s", rsp.sprint()), UVM_LOW);
     endtask
endclass
