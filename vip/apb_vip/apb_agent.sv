class apb_agent extends uvm_agent;
     `uvm_component_utils(apb_agent)
     
     virtual apb_if apb_vif;
     apb_monitor    monitor;
     apb_driver     driver;
     apb_sequencer  sequencer;
     apb_configuration apb_config;

     function new(string name="apb_agent", uvm_component parent);
          super.new(name, parent);
     endfunction: new

     virtual function void build_phase(uvm_phase phase);
          super.build_phase(phase);
          if (!uvm_config_db#(virtual apb_if)::get(this,"", "apb_vif", apb_vif))
               `uvm_fatal(get_type_name(), $sformatf("Failed to get apb_vif from uvm_config_db"))
          if (!uvm_config_db#(apb_configuration)::get(this,"", "apb_config", apb_config))
               `uvm_fatal(get_type_name(), $sformatf("Failed to get apb_config from uvm_config_db"))
          driver    = apb_driver::type_id::create("driver", this);
          sequencer = apb_sequencer::type_id::create("sequencer", this);
          uvm_config_db#(virtual apb_if.DRV)::set(this, "driver", "apb_vif", apb_vif);
          uvm_config_db#(apb_configuration)::set(this, "driver", "apb_config", apb_config);
          monitor   = apb_monitor::type_id::create("monitor", this);
          uvm_config_db#(virtual apb_if.MON)::set(this, "monitor", "apb_vif", apb_vif);
          uvm_config_db#(apb_configuration)::set(this, "monitor", "apb_config", apb_config);
     endfunction: build_phase

     virtual function void connect_phase(uvm_phase phase);
          super.connect_phase(phase);
          if (get_is_active() == UVM_ACTIVE)
               driver.seq_item_port.connect(sequencer.seq_item_export);
     endfunction: connect_phase
endclass: apb_agent


