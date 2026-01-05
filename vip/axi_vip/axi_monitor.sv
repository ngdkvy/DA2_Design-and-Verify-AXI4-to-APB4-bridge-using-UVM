class axi_monitor extends uvm_monitor;
     `uvm_component_utils(axi_monitor)

     virtual axi_if.MON axi_vif;
     uvm_analysis_port#(axi_transaction) axi_item_act;
     axi_transaction axi_trans_wr;
     axi_transaction axi_trans_rd;

     function new(string name = "axi_monitor", uvm_component parent);
          super.new(name, parent);
          axi_item_act = new("axi_item_act", this);
          axi_trans_wr = new();
          axi_trans_rd = new();
     endfunction: new

     virtual function void build_phase(uvm_phase phase);
          super.build_phase(phase);
          if (!uvm_config_db#(virtual axi_if.MON)::get(this,"", "axi_vif", axi_vif))
               `uvm_fatal(get_type_name(), $sformatf("Failed to get axi_vif from uvm_config_db"))
     endfunction: build_phase

     virtual task run_phase (uvm_phase phase);
          fork
               capture_write();
               capture_read();
          join
     endtask: run_phase

     task capture_write();
          int write_len;
          forever begin
               wait ((axi_vif.mon_cb.AWREADY && axi_vif.mon_cb.AWVALID) == 1);
               `uvm_info(get_type_name(), $sformatf("Start capture AXI write transaction"), UVM_LOW)
               axi_trans_wr.addr   = axi_vif.mon_cb.AWADDR;
               axi_trans_wr.len    = axi_vif.mon_cb.AWLEN;
               write_len    = axi_vif.mon_cb.AWLEN + 1;
               $cast(axi_trans_wr.size_type, axi_vif.mon_cb.AWSIZE);
               $cast(axi_trans_wr.burst_type, axi_vif.mon_cb.AWBURST);
               axi_trans_wr.data = new[write_len]; 
               axi_trans_wr.strb = new[write_len];
               for (int i = 0; i < write_len; i++) begin
                    @(axi_vif.mon_cb);
                    wait ((axi_vif.mon_cb.WREADY && axi_vif.mon_cb.WVALID) == 1);
                    axi_trans_wr.data[i]   = axi_vif.mon_cb.WDATA;
                    axi_trans_wr.strb[i]   = axi_vif.mon_cb.WSTRB;
                    `uvm_info(get_type_name(), $sformatf("Capture Wdata: %0h", axi_trans_wr.data[i]), UVM_LOW)
                    if (i == write_len - 1 && axi_vif.mon_cb.WLAST != 1'b1) begin
                         `uvm_error(get_type_name(), "WLAST not asserted on last write beat")
                    end
               end
               `uvm_info(get_type_name(), $sformatf("Capture Write channel!"), UVM_LOW)
               wait ((axi_vif.mon_cb.BVALID && axi_vif.mon_cb.BREADY) == 1);
               axi_trans_wr.error = new[1];
               $cast(axi_trans_wr.error[0], axi_vif.mon_cb.BRESP);
               `uvm_info(get_type_name(), $sformatf("Capture Response channel!"), UVM_LOW)
               axi_item_act.write(axi_trans_wr);
          end
     endtask

     task capture_read();
          int read_len;
          forever begin
               wait ((axi_vif.mon_cb.ARREADY && axi_vif.mon_cb.ARVALID) == 1); 
               `uvm_info(get_type_name(), $sformatf("Start capture AXI read transaction"), UVM_LOW)
               axi_trans_rd.addr   = axi_vif.mon_cb.ARADDR;
               axi_trans_rd.len    = axi_vif.mon_cb.ARLEN;
               read_len = axi_vif.mon_cb.ARLEN + 1;
               $cast(axi_trans_rd.xact_type, axi_transaction::READ);
               $cast(axi_trans_rd.size_type, axi_vif.mon_cb.ARSIZE);
               $cast(axi_trans_rd.burst_type, axi_vif.mon_cb.ARBURST);
               axi_trans_rd.data  = new[read_len];
               axi_trans_rd.error = new[read_len];
               for (int i = 0; i < read_len; i++) begin
                    @(axi_vif.mon_cb);
                    wait ((axi_vif.mon_cb.RREADY && axi_vif.mon_cb.RVALID) == 1);
                    axi_trans_rd.data[i]   = axi_vif.mon_cb.RDATA;
                    $cast(axi_trans_rd.error[i], axi_vif.mon_cb.RRESP);
                    if ((i == read_len) && (axi_vif.mon_cb.RLAST != 1'b1))
                         `uvm_error(get_type_name(), "RLAST not asserted on last read beat")
                    wait ((axi_vif.mon_cb.RREADY && axi_vif.mon_cb.RVALID) == 0);
               end
               axi_item_act.write(axi_trans_rd);
          end
     endtask
endclass: axi_monitor
