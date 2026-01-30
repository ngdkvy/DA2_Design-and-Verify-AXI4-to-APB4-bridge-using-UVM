class wr_rd_random_address_sequence extends uvm_sequence #(axi_transaction);
     `uvm_object_utils(wr_rd_random_address_sequence)

     function new (string name="wr_rd_random_address_sequence");
          super.new(name);
     endfunction

     virtual task body();
		bit [12:0] addr_tmp;
		
		addr_tmp = 32'h00;
		for (int i = 0; i < 3; i++)
		begin	
          	req = axi_transaction::type_id::create("req");
          	start_item(req);
          	req.randomize() with {addr		== {19'h00, addr_tmp};
							  xact_type    == axi_transaction::DUAL;};
          	`uvm_info(get_type_name(), $sformatf("Send req to driver: \n %s", req.sprint()), UVM_LOW);
          	finish_item(req);
          	get_response(rsp);
			addr_tmp = ~addr_tmp;
          	`uvm_info(get_type_name(), $sformatf("Recevied rsp to driver: \n %s", rsp.sprint()), UVM_LOW);
         	end 
          #10us;
     endtask
endclass
