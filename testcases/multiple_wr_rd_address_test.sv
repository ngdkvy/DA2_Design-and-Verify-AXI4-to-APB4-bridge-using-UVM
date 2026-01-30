class multiple_wr_rd_address_test extends apb_base_test;
     `uvm_component_utils(multiple_wr_rd_address_test)

     apb_configuration apb_config;
     wr_rd_random_address_sequence wr_rd_random_addr_seq;

     function new(string name = "multiple_wr_rd_address_test", uvm_component parent);
          super.new(name, parent);
     endfunction

     virtual function void build_phase (uvm_phase phase);
          super.build_phase(phase);

          apb_config = apb_configuration::type_id::create("apb_config");

          apb_config.randomize() with {error == apb_configuration::NO_ERROR;};
          uvm_config_db#(apb_configuration)::set(this, "apb_env", "apb_config", apb_config);
     endfunction: build_phase

     virtual task run_phase(uvm_phase phase);
          phase.raise_objection(this);

          wr_rd_random_addr_seq = wr_rd_random_address_sequence::type_id::create("wr_rd_random_addr_seq");
        	wr_rd_random_addr_seq.start(apb_env.axi_agt.sequencer);

          phase.drop_objection(this);
     endtask
endclass
