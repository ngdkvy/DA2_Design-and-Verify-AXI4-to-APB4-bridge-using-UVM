class apb_monitor extends uvm_monitor;
     `uvm_component_utils(apb_monitor)

     virtual apb_if.MON apb_vif;
     apb_configuration apb_config;
     uvm_analysis_port#(apb_transaction) apb_item_act;

     function new (string name = "apb_monitor", uvm_component parent);
          super.new(name, parent);
          apb_item_act = new("apb_item_act", this);
     endfunction:new

     virtual function void build_phase (uvm_phase phase);
         super.build_phase(phase);
          if (!uvm_config_db#(virtual apb_if.MON)::get(this,"", "apb_vif", apb_vif))
               `uvm_fatal(get_type_name(), $sformatf("Failed to get apb_vif from uvm_config_db"))
          if (!uvm_config_db#(apb_configuration)::get(this,"", "apb_config", apb_config))
               `uvm_fatal(get_type_name(), $sformatf("Failed to get apb_config from uvm_config_db"))
     endfunction: build_phase
     
     virtual task run_phase (uvm_phase phase);
          forever begin
               apb_transaction trans;
               trans = new();
               wait (apb_vif.mon_cb.PSEL1 || apb_vif.mon_cb.PSEL2 || apb_vif.mon_cb.PSEL3);
               @(apb_vif.mon_cb);
               trans      = apb_transaction::type_id::create("trans");
               trans.addr = apb_vif.mon_cb.PADDR;
               $cast(trans.xact_type, apb_vif.mon_cb.PWRITE);
               if (apb_vif.mon_cb.PSEL1)
                    $cast(trans.psel, apb_transaction::PSEL1);
               else if (apb_vif.mon_cb.PSEL2)
                    $cast(trans.psel, apb_transaction::PSEL2);
               else if (apb_vif.mon_cb.PSEL3)
                    $cast(trans.psel, apb_transaction::PSEL3);
               trans.strb = apb_vif.mon_cb.PSTRB;
               @(apb_vif.mon_cb);
               while (apb_vif.mon_cb.PREADY != 1'b1) 
                    @(apb_vif.mon_cb);
               if (trans.xact_type == apb_transaction::READ) 
                    trans.data = apb_vif.mon_cb.PRDATA;
               else 
                    trans.data = apb_vif.mon_cb.PWDATA;
               trans.error = apb_vif.mon_cb.PSLVERR ? apb_transaction::ERROR : apb_transaction::NO_ERROR;
               apb_item_act.write(trans);
               @(apb_vif.mon_cb);
        end
   endtask
endclass: apb_monitor 
