class multiple_wr_rd_sequence extends uvm_sequence #(axi_transaction);
     `uvm_object_utils(multiple_wr_rd_sequence)

     function new (string name="multiple_wr_rd_sequence");
          super.new(name);
     endfunction

     virtual task body();
          bit [31:0] addr_tmp;
		
		for (int i = 0; i < 5; i++)
		begin
          	req = axi_transaction::type_id::create("req");
          	start_item(req);
          	addr_tmp = $urandom_range(32'h00, 32'hFFF);
          	req.randomize() with {addr         == addr_tmp;
                                	  xact_type    == axi_transaction::DUAL;
                               	  burst_type   == axi_transaction::INCR;};
          	`uvm_info(get_type_name(), $sformatf("Send req to driver: \n %s", req.sprint()), UVM_LOW);
          	finish_item(req);
          	get_response(rsp);
          	`uvm_info(get_type_name(), $sformatf("Recevied rsp to driver: \n %s", rsp.sprint()), UVM_LOW);
          end
          #10us;
     endtask
endclass
