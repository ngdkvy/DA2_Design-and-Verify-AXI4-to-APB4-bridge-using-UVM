class apb_driver extends uvm_driver #(apb_transaction);
     `uvm_component_utils(apb_driver)

     virtual apb_if.DRV apb_vif;
     apb_configuration apb_config;

     function new(string name = "apb_driver", uvm_component parent);
          super.new(name, parent);
     endfunction: new

     virtual function void build_phase(uvm_phase phase);
          super.build_phase(phase);
          if (!uvm_config_db#(virtual apb_if.DRV)::get(this,"", "apb_vif", apb_vif))
               `uvm_fatal(get_type_name(), $sformatf("Failed to get apb_vif from uvm_config_db"))
          if (!uvm_config_db#(apb_configuration)::get(this,"", "apb_config", apb_config))
               `uvm_fatal(get_type_name(), $sformatf("Failed to get apb_config from uvm_config_db"))
     endfunction: build_phase
     
     virtual task run_phase (uvm_phase phase);
          init_signal();
          wait(apb_vif.PRESETn == 1'b1);
          forever begin
               drive();
          end
     endtask: run_phase

     virtual function void init_signal();
          apb_vif.drv_cb.PRDATA  <= 0;
          apb_vif.drv_cb.PREADY  <= 0;
          apb_vif.drv_cb.PSLVERR <= 0;
     endfunction

     virtual task drive();
          @(apb_vif.drv_cb iff (apb_vif.drv_cb.PSEL1 || apb_vif.drv_cb.PSEL2 || apb_vif.drv_cb.PSEL3));
          @(apb_vif.drv_cb);
          if (apb_vif.drv_cb.PWRITE == 0)
               apb_vif.drv_cb.PRDATA <= $urandom_range(32'h01, 32'hFFFF_FFFF);
          apb_vif.drv_cb.PREADY <= 1'b1;
          if (apb_config.error == apb_configuration::ERROR) 
               apb_vif.drv_cb.PSLVERR <= 1'b1;
          else 
               apb_vif.drv_cb.PSLVERR <= 1'b0;
          @(apb_vif.drv_cb);
          apb_vif.drv_cb.PREADY  <= 1'b0;
          apb_vif.drv_cb.PSLVERR <= 1'b0;
          apb_vif.drv_cb.PRDATA  <= 32'b0;
     endtask
endclass:apb_driver
