module AXI_to_APB_bridge 
#(parameter start_slave_0 = 32'h00      ,
            end_slave_0   = 32'hFFF     ,
            start_slave_1 = 32'h1000    ,
            end_slave_1   = 32'h1FFF    ,
            start_slave_2 = 32'h2000    ,
            end_slave_2   = 32'h2FFF
)
(
     input wire     ACLK      ,   
     input wire     ARESETn   ,   
    
     input wire     PCLK      ,   
     input wire     PRESETn   ,   

     input wire [31:0] AWADDR ,
     input wire [7:0]  AWLEN  ,
     input wire [2:0]  AWSIZE ,
     input wire [1:0]  AWBURST,
     input wire        AWVALID,
     output wire       AWREADY,

     input wire [31:0] ARADDR ,
     input wire [7:0]  ARLEN  ,
     input wire [2:0]  ARSIZE ,
     input wire [1:0]  ARBURST,
     input wire        ARVALID,
     output wire       ARREADY,

     input wire [31:0] WDATA  ,
     input wire [3:0]  WSTRB  ,
     input wire        WLAST  ,
     input wire        WVALID ,
     output wire       WREADY ,

     output wire       BVALID ,
     input wire        BREADY ,
     output wire [1:0] BRESP  ,

     output wire [31:0] RDATA , 
     output wire        RLAST ,
     output wire        RVALID,
     input wire         RREADY,
     output wire [1:0]  RRESP ,

     output wire [31:0]   PADDR     ,
     output wire          PWRITE    ,
     output wire [3:0]    PSTRB     ,
     output wire          PSEL1     ,
     output wire          PSEL2     ,
     output wire          PSEL3     ,
     output wire          PENABLE   ,
     output wire [31:0]   PWDATA    ,
     input  wire [31:0]   PRDATA    ,
     input  wire          PREADY    ,
     input  wire          PSLVERR   
);
     wire           aw_empty, aw_done                  ;
     wire           aw_almost_empty, ar_almost_empty   ;
     wire           wr_almost_empty, rd_almost_full   ;
     wire           rfull, rd_trans_done               ;
     wire [44:0]    aw_addr, ar_addr                   ;
     wire           ar_empty, ar_done                  ;
     wire           wr_empty                           ;
     wire [35:0]    wr_data                            ;
     wire [31:0]    rd_data                            ;
     wire [1:0]     rresp_in, bresp_in                 ;
     wire           wr_enable, rd_enable               ;
     wire [2:0]     AW_SIZE                            ;

assign AW_SIZE = aw_addr [4:2];
     
     axi_slave #(.DEPTH_AX(2), .DEPTH_WR(6)) axi  (
                                                       .ACLK     ( ACLK    ),
                                                       .ARESETn  ( ARESETn ),

                                                       .PCLK     ( PCLK    ),    
                                                       .PRESETn  ( PRESETn ),

                                                       .AWADDR   ( AWADDR  ),
                                                       .AWLEN    ( AWLEN   ),
                                                       .AWSIZE   ( AWSIZE  ),
                                                       .AWBURST  ( AWBURST ),
                                                       .AWVALID  ( AWVALID ),
                                                       .AWREADY  ( AWREADY ),

                                                       .ARADDR   ( ARADDR  ),
                                                       .ARLEN    ( ARLEN   ),
                                                       .ARSIZE   ( ARSIZE  ),
                                                       .ARBURST  ( ARBURST ),
                                                       .ARVALID  ( ARVALID ),
                                                       .ARREADY  ( ARREADY ),

                                                       .WDATA    ( WDATA   ),
                                                       .WSTRB    ( WSTRB   ),
                                                       .WLAST    ( WLAST   ),
                                                       .WVALID   ( WVALID  ),
                                                       .WREADY   ( WREADY  ),
                                                       .BVALID   ( BVALID  ),
                                                       .BREADY   ( BREADY  ),
                                                       .BRESP    ( BRESP   ),

                                                       .RDATA    ( RDATA   ),
                                                       .RLAST    ( RLAST   ),
                                                       .RVALID   ( RVALID  ),
                                                       .RREADY   ( RREADY  ),
                                                       .RRESP    ( RRESP   ),

                                                       .aw_empty           ( aw_empty          ),
                                                       .aw_done            ( aw_done           ),
                                                       .aw_addr            ( aw_addr           ),
                                                       .ar_empty           ( ar_empty          ),
                                                       .ar_done            ( ar_done           ),
                                                       .ar_addr            ( ar_addr           ),
                                                       .aw_almost_empty    ( aw_almost_empty   ),
                                                       .ar_almost_empty    ( ar_almost_empty   ),

                                                       .wr_empty           ( wr_empty          ),
                                                       .wdone              ( wr_enable         ),
                                                       .w_data             ( wr_data           ),
                                                       .bresp_in           ( bresp_in          ),
                                                       .wr_almost_empty    ( wr_almost_empty   ),

                                                       .rfull              ( rfull             ),
                                                       .r_en               ( rd_enable         ),
                                                       .rresp_in           ( rresp_in          ),
                                                       .r_data             ( rd_data           ),
                                                       .rd_trans_done      ( rd_trans_done     ),
                                                       .rd_almost_full     ( rd_almost_full    )
                                             );
     apb_master #(.start_slave_0 ( start_slave_0  )  ,
                  .end_slave_0   ( end_slave_0    )  ,
                  .start_slave_1 ( start_slave_1  )  ,
                  .end_slave_1   ( end_slave_1    )  ,
                  .start_slave_2 ( start_slave_2  )  ,
                  .end_slave_2   ( end_slave_2    )
               )
               apb (
                                                       .PCLK               ( PCLK         ),    
                                                       .PRESETn            ( PRESETn      ),
                                                       .PADDR              ( PADDR        ),
                                                       .PWRITE             ( PWRITE       ),
                                                       .PSTRB              ( PSTRB        ),
                                                       .PSEL1              ( PSEL1        ),
                                                       .PSEL2              ( PSEL2        ),
                                                       .PSEL3              ( PSEL3        ),
                                                       .PENABLE            ( PENABLE      ),
                                                       .PWDATA             ( PWDATA       ),
                                                       .PRDATA             ( PRDATA       ),
                                                       .PREADY             ( PREADY       ),
                                                       .PSLVERR            ( PSLVERR      ),
                                                       .AW_SIZE            ( AW_SIZE      ),
                                                       .aw_empty           ( aw_empty     ),
                                                       .aw_done            ( aw_done      ),
                                                       .aw_addr            ( aw_addr      ),
                                                       .ar_empty           ( ar_empty     ),
                                                       .ar_done            ( ar_done      ),
                                                       .ar_addr            ( ar_addr      ),
                                                       .wr_empty           ( wr_empty     ),
                                                       .wr_enable          ( wr_enable    ),
                                                       .wr_data            ( wr_data      ),
                                                       .rd_enable          ( rd_enable    ),
                                                       .rd_full            ( rfull        ),
                                                       .rd_data            ( rd_data      ),
                                                       .rresp_in           ( rresp_in     ),
                                                       .bresp_in           ( bresp_in     ),
                                                       .rd_trans_done      ( rd_trans_done     ),
                                                       .aw_almost_empty    ( aw_almost_empty   ),
                                                       .ar_almost_empty    ( ar_almost_empty   ),
                                                       .wr_almost_empty    ( wr_almost_empty   ),
                                                       .rd_almost_full     ( rd_almost_full    )
               );
endmodule
