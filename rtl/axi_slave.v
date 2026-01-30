module axi_slave #(parameter DEPTH_AX = 3, DEPTH_WR = 8)
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
     output wire        AWREADY,

     input wire [31:0] ARADDR ,
     input wire [7:0]  ARLEN  ,
     input wire [2:0]  ARSIZE ,
     input wire [1:0]  ARBURST,
     input wire        ARVALID,
     output wire        ARREADY,

     input wire [31:0] WDATA  ,
     input wire [3:0]  WSTRB  ,
     input wire        WLAST  ,
     input wire        WVALID ,
     output wire        WREADY ,

     output wire       BVALID ,
     input wire        BREADY ,
     output wire [1:0] BRESP  ,

     output wire [31:0] RDATA , 
     output wire        RLAST ,
     output wire        RVALID,
     input wire         RREADY,
     output wire [1:0]  RRESP ,

     output wire         aw_empty            ,
     input wire          aw_done             ,
     output wire [44:0]  aw_addr             ,
     output wire         aw_almost_empty     ,

     output wire         ar_empty            ,
     input wire          ar_done             ,
     output wire [44:0]  ar_addr             ,
     output wire         ar_almost_empty     ,

     output wire         wr_empty            ,
     input wire          wdone               ,
     output wire [35:0]  w_data              ,
     output wire         wr_almost_empty     ,
     input wire  [1:0]   bresp_in            ,

     output wire         rfull          ,
     input wire          r_en           ,
     input wire [1:0]    rresp_in       ,
     input wire [31:0]   r_data         ,
     input wire          rd_trans_done  ,
     output wire         rd_almost_full 
);
     wire           aw_full, ar_full         ;
     wire           w_full                   ;
     wire           rd_empty                 ;
     wire           rlast_tmp                ;
     wire [1:0]     bresp_tmp                ;
     reg [1:0]      bresp_r                  ;
     reg            rlast_r                  ;

     wire [44:0]    aw_fifo_tmp, ar_fifo_tmp ;
     wire [31:0]    r_data_tmp               ;
     wire [33:0]    rd_fifo_tmp              ; 
assign aw_fifo_tmp = {AWADDR [31:0], AWLEN [7:0], AWSIZE [2:0], AWBURST [1:0]};
assign ar_fifo_tmp = {ARADDR [31:0], ARLEN [7:0], ARSIZE [2:0], ARBURST [1:0]};

     asys_FIFO #(DEPTH_AX, 45) aw_fifo (
                                             .wclk          ( ACLK              ),
                                             .rclk          ( PCLK              ),
                                             .wrstn         ( ARESETn           ),
                                             .rrstn         ( PRESETn           ),
                                             .wren          ( AWVALID           ),   
                                             .rden          ( aw_done           ),
                                             .wdata         ( aw_fifo_tmp       ),
                                             .rdata         ( aw_addr           ),
                                             .wfull         ( aw_full           ),
                                             .rempty        ( aw_empty          ),
                                             .almost_empty  ( aw_almost_empty   ),
                                             .almost_full   ( )
                                        );
     asys_FIFO #(DEPTH_AX, 45) ar_fifo (
                                             .wclk          ( ACLK              ),
                                             .rclk          ( PCLK              ),
                                             .wrstn         ( ARESETn           ),
                                             .rrstn         ( PRESETn           ),
                                             .wren          ( ARVALID           ),
                                             .rden          ( ar_done           ),
                                             .wdata         ( ar_fifo_tmp       ),
                                             .rdata         ( ar_addr           ),
                                             .wfull         ( ar_full           ),
                                             .rempty        ( ar_empty          ),
                                             .almost_empty  ( ar_almost_empty   ),
                                             .almost_full   ( )
                                        );
assign AWREADY = AWVALID & ~aw_full;
assign ARREADY = ARVALID & ~ar_full;
     
     asys_FIFO #(DEPTH_WR, 36) wr_fifo (
                                             .wclk          ( ACLK              ),
                                             .rclk          ( PCLK              ),
                                             .wrstn         ( ARESETn           ),
                                             .rrstn         ( PRESETn           ),
                                             .wren          ( WVALID & WREADY   ),
                                             .rden          ( wdone             ),
                                             .wdata         ( {WDATA, WSTRB}    ),
                                             .rdata         ( w_data            ),
                                             .wfull         ( w_full            ),
                                             .rempty        ( wr_empty          ),
                                             .almost_empty  ( wr_almost_empty   ),
                                             .almost_full   ( )
                                        );

assign bresp_tmp = (bresp_in == 2'b10) ? 2'b10 :
                   (BVALID & BREADY)   ? (~(BVALID & BREADY) ? 2'b00 : bresp_r) : bresp_r;
assign BRESP     = (BVALID & BREADY)   ? bresp_r : 2'b00;

     always @(posedge ACLK or negedge ARESETn)
     begin
          if (~ARESETn)
               bresp_r <= 0;
          else
               bresp_r <= bresp_tmp;
     end
assign BVALID = aw_done             ;
assign WREADY = WVALID & ~w_full    ;

assign r_data_tmp  = (ar_addr [4:2] == 3'b000) ? {24'h00, r_data [7:0]} :
                     (ar_addr [4:2] == 3'b001) ? {16'h00, r_data [15:0]} :
                     (ar_addr [4:2] == 3'b010) ? r_data [31:0] : 32'h00;
assign rd_fifo_tmp = {r_data_tmp, rresp_in};

     asys_FIFO #(DEPTH_WR, 34) rd_fifo (
                                             .wclk          ( ACLK              ),
                                             .rclk          ( PCLK              ),
                                             .wrstn         ( ARESETn           ),
                                             .rrstn         ( PRESETn           ),
                                             .wren          ( r_en              ),
                                             .rden          ( RVALID            ),
                                             .wdata         ( rd_fifo_tmp       ),
                                             .rdata         ( {RDATA, RRESP}    ),
                                             .wfull         ( rfull             ),
                                             .rempty        ( rd_empty          ),
                                             .almost_empty  (                   ),
                                             .almost_full   ( rd_almost_full    )
                                        );
assign rlast_tmp = rd_trans_done               ? rd_trans_done :
                   (RVALID & RREADY) & rlast_r ? 0 : rlast_r; 
assign RLAST     = rd_trans_done | rlast_r;
assign RVALID    = ~rd_empty;

     always @(posedge ACLK or negedge ARESETn)
          if (~ARESETn)
               rlast_r <= 0;
          else
               rlast_r <= rlast_tmp;

endmodule

