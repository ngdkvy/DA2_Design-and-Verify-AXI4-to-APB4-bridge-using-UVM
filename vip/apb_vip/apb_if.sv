interface apb_if(input bit PCLK, input bit PRESETn);
     logic [`APB_ADDR_WIDTH-1:0]   PADDR       ;
     logic                         PWRITE      ; 
     logic [3:0]                   PSTRB       ;
     logic                         PSEL1       ;
     logic                         PSEL2       ;
     logic                         PSEL3       ;
     logic                         PENABLE     ;
     logic [`APB_DATA_WIDTH-1:0]   PWDATA      ;
     logic [`APB_DATA_WIDTH-1:0]   PRDATA  = 0 ;
     logic                         PREADY  = 0 ;
     logic                         PSLVERR = 0 ;
     
     clocking drv_cb @(posedge PCLK);
          input PADDR, PWRITE, PSTRB, PSEL1, PSEL2, PSEL3, PENABLE, PWDATA;
          output PRDATA, PREADY, PSLVERR;
     endclocking
     clocking mon_cb @(posedge PCLK);
          input PADDR, PWRITE, PSTRB, PSEL1, PSEL2, PSEL3, PENABLE, PWDATA;
          input PRDATA, PREADY, PSLVERR;
     endclocking
     modport DRV (clocking drv_cb, input PCLK, input PRESETn);
     modport MON (clocking mon_cb, input PCLK, input PRESETn);
     property penable_not_assert_before_psel;
          @(posedge PCLK) disable iff (!PRESETn)
               PENABLE |-> (PSEL1 || PSEL2 || PSEL3);
     endproperty
     property penable_dessert_after_pready;
          @(posedge PCLK) disable iff (!PRESETn)
               (PENABLE && PREADY) |=> !PENABLE;
     endproperty
     property penable_hold_until_pready;
          @(posedge PCLK) disable iff (!PRESETn)
               (PENABLE && !PREADY) |=> PENABLE;
     endproperty
     property addr_data_check;
          @(posedge PCLK) disable iff (!PRESETn)
          (PSEL1 || PSEL2 || PSEL3) |-> ##1 $stable(PADDR) && 
                                            $stable(PWDATA)&&
                                            $stable(PRDATA)
                                            throughout PENABLE[->0];
     endproperty
     assert property (penable_not_assert_before_psel);
     assert property (penable_dessert_after_pready);
     assert property (penable_hold_until_pready);
     assert property (addr_data_check);
endinterface    
