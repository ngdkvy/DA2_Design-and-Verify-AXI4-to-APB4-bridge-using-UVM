module testbench;
     import uvm_pkg::*;
     import axi_pkg::*;
     import apb_pkg::*;
     import test_pkg::*;

     bit ACLK;
     bit ARESETn;
     bit PCLK;
     bit PRESETn;
     axi_if axi_vif(ACLK, ARESETn);
     apb_if apb_vif(PCLK, PRESETn);

     parameter start_slave_0 = 32'h00      ,
               end_slave_0   = 32'hFFF     ,
               start_slave_1 = 32'h1000    ,
               end_slave_1   = 32'h1FFF    ,
               start_slave_2 = 32'h2000    ,
               end_slave_2   = 32'h2FFF    ;

     AXI_to_APB_bridge #(.start_slave_0 ( start_slave_0 ),
                         .end_slave_0   ( end_slave_0   ),
                         .start_slave_1 ( start_slave_1 ),
                         .end_slave_1   ( end_slave_1   ),
                         .start_slave_2 ( start_slave_2 ),
                         .end_slave_2   ( end_slave_2   )
                         )
                         dut (
                              .ACLK     ( axi_vif.ACLK      ),
                              .ARESETn  ( axi_vif.ARESETn   ),
                              .PCLK     ( apb_vif.PCLK      ),
                              .PRESETn  ( apb_vif.PRESETn   ),
                              .AWADDR   ( axi_vif.AWADDR    ),
                              .AWLEN    ( axi_vif.AWLEN     ),
                              .AWSIZE   ( axi_vif.AWSIZE    ),
                              .AWBURST  ( axi_vif.AWBURST   ),
                              .AWVALID  ( axi_vif.AWVALID   ),
                              .AWREADY  ( axi_vif.AWREADY   ),
                              .ARADDR   ( axi_vif.ARADDR    ),
                              .ARLEN    ( axi_vif.ARLEN     ),
                              .ARSIZE   ( axi_vif.ARSIZE    ),
                              .ARBURST  ( axi_vif.ARBURST   ),
                              .ARVALID  ( axi_vif.ARVALID   ),
                              .ARREADY  ( axi_vif.ARREADY   ),
                              .WDATA    ( axi_vif.WDATA     ),
                              .WSTRB    ( axi_vif.WSTRB     ),
                              .WLAST    ( axi_vif.WLAST     ),
                              .WVALID   ( axi_vif.WVALID    ),
                              .WREADY   ( axi_vif.WREADY    ),
                              .BVALID   ( axi_vif.BVALID    ),
                              .BREADY   ( axi_vif.BREADY    ),
                              .BRESP    ( axi_vif.BRESP     ),
                              .RDATA    ( axi_vif.RDATA     ),
                              .RLAST    ( axi_vif.RLAST     ),
                              .RVALID   ( axi_vif.RVALID    ),
                              .RREADY   ( axi_vif.RREADY    ),
                              .RRESP    ( axi_vif.RRESP     ),
                              .PADDR    ( apb_vif.PADDR     ),
                              .PWRITE   ( apb_vif.PWRITE    ),
                              .PSTRB    ( apb_vif.PSTRB     ),
                              .PSEL1    ( apb_vif.PSEL1     ),
                              .PSEL2    ( apb_vif.PSEL2     ),
                              .PSEL3    ( apb_vif.PSEL3     ),
                              .PENABLE  ( apb_vif.PENABLE   ),
                              .PWDATA   ( apb_vif.PWDATA    ),
                              .PRDATA   ( apb_vif.PRDATA    ),
                              .PREADY   ( apb_vif.PREADY    ),
                              .PSLVERR  ( apb_vif.PSLVERR   )
                    );
     initial begin
          ARESETn = 0;
          #20ns ARESETn = 1;
     end
     initial begin
          PRESETn = 0;
          #20ns PRESETn = 1;
     end
     initial begin
          ACLK = 0;
          forever begin
               #5ns ACLK = ~ACLK;
          end
     end
     initial begin
          PCLK = 0;
          #5ns;
          forever begin
               #10ns PCLK = ~PCLK;
          end
     end
     initial begin
          uvm_config_db#(virtual axi_if)::set(null, "uvm_test_top", "axi_vif", axi_vif);
          uvm_config_db#(virtual apb_if)::set(null, "uvm_test_top", "apb_vif", apb_vif);
          run_test();
     end
endmodule
