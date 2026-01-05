class apb_environment extends uvm_env;
     `uvm_component_utils(apb_environment)

     virtual axi_if axi_vif;
     virtual apb_if apb_vif;
     apb_configuration   apb_config;
     apb_scoreboard      apb_sb;
     apb_agent           apb_agt;
     axi_agent           axi_agt;
     
     function new (string name = "apb_environment", uvm_component parent);
          super.new(name, parent);
     endfunction: new

     virtual function void build_phase (uvm_phase phase);
          super.build_phase(phase);
          `uvm_info("build_phase", "Entered...", UVM_HIGH)
          if (!uvm_config_db#(virtual axi_if)::get(this,"", "axi_vif", axi_vif))
               `uvm_fatal(get_type_name(), $sformatf("Failed to get axi_vif from uvm_config_db"))
          if (!uvm_config_db#(virtual apb_if)::get(this,"", "apb_vif", apb_vif))
               `uvm_fatal(get_type_name(), $sformatf("Failed to get apb_vif from uvm_config_db"))
          if (!uvm_config_db#(apb_configuration)::get(this,"", "apb_config", apb_config))
               `uvm_fatal(get_type_name(), $sformatf("Failed to get apb_config from uvm_config_db"))
          apb_sb    = apb_scoreboard::type_id::create("apb_sb", this);
          apb_agt   = apb_agent::type_id::create("apb_agt", this);
          axi_agt   = axi_agent::type_id::create("axi_agt", this);
          uvm_config_db#(virtual axi_if)::set(this, "axi_agt", "axi_vif", axi_vif);
          uvm_config_db#(virtual apb_if)::set(this, "apb_agt", "apb_vif", apb_vif);
          uvm_config_db#(apb_configuration)::set(this, "apb_agt", "apb_config", apb_config);
          uvm_config_db#(apb_configuration)::set(this, "apb_sb", "apb_config", apb_config);
          if (apb_config == null)
               `uvm_fatal(get_type_name(), $sformatf("Received null apb config"))
          `uvm_info("build_phase", "Exiting...", UVM_HIGH)
     endfunction: build_phase

     virtual function void connect_phase (uvm_phase phase);
          super.connect_phase(phase);
          `uvm_info("connect_phase", "Entered...",UVM_HIGH)
          apb_agt.monitor.apb_item_act.connect(apb_sb.apb_item_exp);
          axi_agt.monitor.axi_item_act.connect(apb_sb.axi_item_exp);
          `uvm_info("connect_phase", "Exiting...", UVM_HIGH)
     endfunction: connect_phase
endclass: apb_environment


