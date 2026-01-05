class multiple_rd_wrap_sequence extends uvm_sequence #(axi_transaction);
     `uvm_object_utils(multiple_rd_wrap_sequence)

     function new (string name="multiple_rd_wrap_sequence");
          super.new(name);
     endfunction

     virtual task body();
          bit [31:0] addr_tmp;

          req = axi_transaction::type_id::create("req");
          start_item(req);
          addr_tmp = $urandom_range(32'h00, 32'hFFF);
          req.randomize() with {addr         == addr_tmp;
                                xact_type    == axi_transaction::READ;
                                burst_type   == axi_transaction::WRAP;};
          `uvm_info(get_type_name(), $sformatf("Send req to driver: \n %s", req.sprint()), UVM_LOW);
          finish_item(req);
          get_response(rsp);
          `uvm_info(get_type_name(), $sformatf("Recevied rsp to driver: \n %s", rsp.sprint()), UVM_LOW);
          
          req = axi_transaction::type_id::create("req");
          start_item(req);
          addr_tmp = $urandom_range(32'h00, 32'hFFF);
          req.randomize() with {addr         == addr_tmp;
                                xact_type    == axi_transaction::READ;
                                burst_type   == axi_transaction::WRAP;};
          `uvm_info(get_type_name(), $sformatf("Send req to driver: \n %s", req.sprint()), UVM_LOW);
          finish_item(req);
          get_response(rsp);
          #10us;
          `uvm_info(get_type_name(), $sformatf("Recevied rsp to driver: \n %s", rsp.sprint()), UVM_LOW);
     endtask
endclass
