interface axi_if (input bit ACLK, input bit ARESETn);
     logic [`AXI_ADDR_WIDTH-1:0]   AWADDR  = 0  ;
     logic [7:0]                   AWLEN   = 0  ;
     logic [2:0]                   AWSIZE  = 0  ;
     logic [1:0]                   AWBURST = 0  ;
     logic                         AWVALID = 0  ;
     logic                         AWREADY      ;
     logic [`AXI_ADDR_WIDTH-1:0]   ARADDR  = 0  ;
     logic [7:0]                   ARLEN   = 0  ;
     logic [2:0]                   ARSIZE  = 0  ;
     logic [1:0]                   ARBURST = 0  ;
     logic                         ARVALID = 0  ;
     logic                         ARREADY      ;
     logic [`AXI_DATA_WIDTH-1:0]   WDATA   = 0  ;
     logic [3:0]                   WSTRB   = 0  ;
     logic                         WLAST   = 0  ;
     logic                         WVALID  = 0  ;
     logic                         WREADY       ;
     logic                         BVALID       ;
     logic                         BREADY  = 0  ;
     logic [1:0]                   BRESP        ;
     logic [`AXI_DATA_WIDTH-1:0]   RDATA        ;
     logic                         RLAST        ;
     logic                         RVALID       ;
     logic                         RREADY  = 0  ;
     logic [1:0]                   RRESP        ;
     clocking drv_cb @(posedge ACLK);
          output AWADDR, AWLEN, AWSIZE, AWBURST, AWVALID;
          output ARADDR, ARLEN, ARSIZE, ARBURST, ARVALID;
          output WDATA,  WSTRB, WLAST,  WVALID;
          output BREADY, RREADY;
          input AWREADY, ARREADY, WREADY;
          input BVALID, BRESP;
          input RVALID, RDATA, RLAST, RRESP;
     endclocking
     clocking mon_cb @(posedge ACLK);
          input AWADDR, AWLEN, AWSIZE, AWBURST, AWVALID, AWREADY;
          input ARADDR, ARLEN, ARSIZE, ARBURST, ARVALID, ARREADY;
          input WDATA,  WSTRB, WLAST,  WVALID,  WREADY;
          input BVALID, BREADY, BRESP;
          input RDATA,  RLAST, RVALID, RREADY, RRESP;
     endclocking
     modport DRV (clocking drv_cb, input ACLK, input ARESETn);
     modport MON (clocking mon_cb, input ACLK, input ARESETn);
     property aw_valid;
          @(posedge ACLK) disable iff (!ARESETn)
               $rose(AWVALID) |-> ##1 ($stable(AWADDR)  &&
                                       $stable(AWLEN)   &&
                                       $stable(AWSIZE)  &&
                                       $stable(AWBURST))
                                       throughout (AWREADY && AWVALID) [->0];
     endproperty
     property w_valid;
          @(posedge ACLK) disable iff (!ARESETn)
               $rose(WVALID) |-> ##1 ($stable(WDATA) &&
                                      $stable(WSTRB) &&
                                      $stable(WLAST))
                                  throughout (WREADY & WVALID) [->0];
     endproperty
     property ar_valid;
          @(posedge ACLK) disable iff (!ARESETn)
               $rose(ARVALID) |-> ##1 ($stable(ARADDR) &&
                                       $stable(ARLEN)  &&
                                       $stable(ARSIZE) &&
                                       $stable(ARBURST))
                                       throughout (ARREADY && ARREADY) [->0];
     endproperty
     property r_valid;
          @(posedge ACLK) disable iff (!ARESETn)
              $rose(RVALID) |-> ##1 ($stable(RDATA) &&
                                     $stable(RRESP) &&
                                     $stable(RLAST))
                                     throughout (RREADY && RVALID) [->0];
     endproperty
     property b_valid;
          @(posedge ACLK) disable iff (!ARESETn)
               $rose(BVALID) |-> ##1 ($stable(BRESP))
                                      throughout (BREADY && BVALID) [->0];
     endproperty
     assert property (aw_valid);
     assert property (w_valid);
     assert property (b_valid);
     assert property (ar_valid);
     assert property (r_valid);
endinterface    
