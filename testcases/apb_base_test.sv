class apb_base_test extends uvm_test;
     `uvm_component_utils(apb_base_test)

     virtual axi_if axi_vif;
     virtual apb_if apb_vif;

     apb_environment     apb_env;
     apb_configuration   apb_config;

     function new(string name = "apb_base_test", uvm_component parent);
          super.new(name, parent);
     endfunction: new

     virtual function void build_phase (uvm_phase phase);
          super.build_phase(phase);
          `uvm_info("build_phase", "Entered...", UVM_HIGH)

          if (!uvm_config_db#(virtual axi_if)::get(this,"", "axi_vif", axi_vif))
               `uvm_fatal(get_type_name(), $sformatf("Failed to get axi_vif from uvm_config_db"))
          if (!uvm_config_db#(virtual apb_if)::get(this,"", "apb_vif", apb_vif))
               `uvm_fatal(get_type_name(), $sformatf("Failed to get apb_vif from uvm_config_db"))
          
          apb_config = apb_configuration::type_id::create("apb_config");
          apb_env    = apb_environment::type_id::create("apb_env", this);

          if (!apb_config.randomize)
               `uvm_fatal(get_type_name(), $sformatf("Fatal to randomize apb_config"))

          uvm_config_db#(virtual axi_if)::set(this, "apb_env", "axi_vif", axi_vif);
          uvm_config_db#(virtual apb_if)::set(this, "apb_env", "apb_vif", apb_vif);
          uvm_config_db#(apb_configuration)::set(this, "apb_env", "apb_config", apb_config);

          `uvm_info("build_phase", "Exiting...", UVM_HIGH)
     endfunction: build_phase

     virtual function void start_of_simulation_phase (uvm_phase phase);
          `uvm_info("start_of_simulation_phase", "Entered...", UVM_HIGH)
          uvm_top.print_topology();
          `uvm_info("start_of_simulation_phase", "Exiting...", UVM_HIGH)
     endfunction
endclass
