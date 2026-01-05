class axi_driver extends uvm_driver #(axi_transaction);
     `uvm_component_utils(axi_driver)

     virtual axi_if.DRV axi_vif;

     function new(string name = "axi_driver", uvm_component parent);
          super.new(name, parent);
     endfunction: new

     virtual function void build_phase (uvm_phase phase);
          super.build_phase(phase);
          if (!uvm_config_db#(virtual axi_if.DRV)::get(this,"", "axi_vif", axi_vif))
               `uvm_fatal(get_type_name(), $sformatf("Failed to get axi_vif from uvm_config_db"))
          init_signal();
     endfunction: build_phase

     virtual task run_phase (uvm_phase phase);
          init_signal();
          wait(axi_vif.ARESETn === 1'b1);
          forever begin
               seq_item_port.get(req);
               drive(req);
               $cast(rsp, req.clone());
               rsp.set_id_info(req);
               seq_item_port.put(rsp);
          end
     endtask: run_phase

     virtual task drive (inout axi_transaction req);
          @(axi_vif.drv_cb); #1ps;
          if (req.xact_type == axi_transaction::WRITE)
               drive_write(req);
          if (req.xact_type == axi_transaction::READ) 
               drive_read(req);
          if (req.xact_type == axi_transaction::DUAL) begin
               fork
                    drive_write(req);
                    drive_read(req);
               join
          end
     endtask

     virtual function void init_signal();
          axi_vif.drv_cb.AWADDR  <= 0;
          axi_vif.drv_cb.AWLEN   <= 0;
          axi_vif.drv_cb.AWSIZE  <= 0;
          axi_vif.drv_cb.AWBURST <= 0;
          axi_vif.drv_cb.AWVALID <= 0;
          axi_vif.drv_cb.ARADDR  <= 0;
          axi_vif.drv_cb.ARLEN   <= 0;
          axi_vif.drv_cb.ARSIZE  <= 0;
          axi_vif.drv_cb.ARBURST <= 0;
          axi_vif.drv_cb.ARVALID <= 0;
          axi_vif.drv_cb.WDATA   <= 0;
          axi_vif.drv_cb.WSTRB   <= 0;
          axi_vif.drv_cb.WVALID  <= 0;
          axi_vif.drv_cb.WLAST   <= 0;
          axi_vif.drv_cb.BREADY  <= 0;
          axi_vif.drv_cb.RREADY  <= 0;
     endfunction

     virtual task drive_write (inout axi_transaction req);
          bit [7:0] write_len;
          axi_vif.drv_cb.AWADDR  <= req.addr         ;
          axi_vif.drv_cb.AWLEN   <= req.len          ;
          axi_vif.drv_cb.AWSIZE  <= req.size_type    ;
          axi_vif.drv_cb.AWBURST <= req.burst_type   ;
          axi_vif.drv_cb.AWVALID <= 1'b1;
          write_len = req.len + 1;
          @(axi_vif.drv_cb);
          axi_vif.drv_cb.AWADDR  <= 32'b0;
          axi_vif.drv_cb.AWLEN   <= 8'b0;
          axi_vif.drv_cb.AWSIZE  <= 3'b0;
          axi_vif.drv_cb.AWBURST <= 2'b0;
          axi_vif.drv_cb.AWVALID <= 1'b0;
          @(axi_vif.drv_cb);
          for (int i = 0; i < write_len; i++) begin
               axi_vif.drv_cb.WDATA  <= req.data[i];
               axi_vif.drv_cb.WSTRB  <= req.strb[i];
               axi_vif.drv_cb.WVALID <= 1'b1;
               axi_vif.drv_cb.WLAST  <= (i == write_len - 1);
               @(axi_vif.drv_cb iff axi_vif.drv_cb.WREADY);
               axi_vif.drv_cb.WVALID <= 1'b0;
               axi_vif.drv_cb.WLAST  <= 1'b0;
               if (i < write_len - 1)
                    @(axi_vif.drv_cb);
          end     
          axi_vif.drv_cb.WDATA  <= 32'b0;
          axi_vif.drv_cb.WSTRB  <= 4'b0;
          axi_vif.drv_cb.WVALID <= 1'b0;
          axi_vif.drv_cb.WLAST  <= 1'b0;
          @(axi_vif.drv_cb);
          axi_vif.drv_cb.BREADY <= 1'b1;
          @(axi_vif.drv_cb iff axi_vif.drv_cb.BVALID);
          @(axi_vif.drv_cb);
          axi_vif.drv_cb.BREADY <= 1'b0;
     endtask

     virtual task drive_read (inout axi_transaction req);
          bit [7:0] read_len;
          axi_vif.drv_cb.ARADDR  <= req.addr         ;
          axi_vif.drv_cb.ARLEN   <= req.len          ;
          axi_vif.drv_cb.ARSIZE  <= req.size_type    ;
          axi_vif.drv_cb.ARBURST <= req.burst_type   ;
          axi_vif.drv_cb.ARVALID <= 1'b1;
          read_len = req.len + 1;
          @(axi_vif.drv_cb iff axi_vif.drv_cb.ARREADY);
          axi_vif.drv_cb.ARADDR  <= 32'b0;
          axi_vif.drv_cb.ARLEN   <= 8'b0;
          axi_vif.drv_cb.ARSIZE  <= 4'b0;
          axi_vif.drv_cb.ARBURST <= 2'b0;
          axi_vif.drv_cb.ARVALID <= 1'b0;
          for (int i = 0; i < read_len; i++) begin
               @(axi_vif.drv_cb iff axi_vif.drv_cb.RVALID);
               repeat (2) @(posedge axi_vif.ACLK);
               axi_vif.drv_cb.RREADY <= 1'b1;
               @(negedge axi_vif.ACLK);
               axi_vif.drv_cb.RREADY <= 1'b0;
               repeat (2) @(axi_vif.drv_cb); 
               if (i == read_len && axi_vif.drv_cb.RLAST != 1'b1)
                    `uvm_error(get_type_name(), "RLAST not asserted on last read beat");
          end
     endtask
endclass: axi_driver
