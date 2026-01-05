class wr_incr_psel1_4byte_error_test extends apb_base_test;
     `uvm_component_utils(wr_incr_psel1_4byte_error_test)

     apb_configuration apb_config;
     wr_incr_psel1_4byte_no_error_sequence wr_incr_psel1_4byte_no_error_seq;

     function new(string name = "wr_incr_psel1_4byte_error_test", uvm_component parent);
          super.new(name, parent);
     endfunction

     virtual function void build_phase (uvm_phase phase);
          super.build_phase(phase);

          apb_config = apb_configuration::type_id::create("apb_config");

          apb_config.randomize() with {error == apb_configuration::ERROR;};
          uvm_config_db#(apb_configuration)::set(this, "apb_env", "apb_config", apb_config);
     endfunction: build_phase

     virtual task run_phase(uvm_phase phase);
          phase.raise_objection(this);

          wr_incr_psel1_4byte_no_error_seq = wr_incr_psel1_4byte_no_error_sequence::type_id::create("wr_incr_psel1_4byte_no_error_seq");
          wr_incr_psel1_4byte_no_error_seq.start(apb_env.axi_agt.sequencer);

          phase.drop_objection(this);
     endtask
endclass
