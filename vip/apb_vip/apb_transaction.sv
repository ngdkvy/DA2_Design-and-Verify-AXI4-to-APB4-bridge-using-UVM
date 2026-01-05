class apb_transaction extends uvm_sequence_item;
     typedef enum bit {
          WRITE = 1,
          READ  = 0
     } xact_type_enum;

     typedef enum bit {
          NO_ERROR = 1,
          ERROR    = 0
     } error_response;
     typedef enum bit [1:0] {
          PSEL1  = 2'b00,
          PSEL2  = 2'b01,
          PSEL3  = 2'b10
     }psel_choose;
     
     rand bit [`APB_ADDR_WIDTH-1:0] addr;
     rand bit [`APB_DATA_WIDTH-1:0] data;
     rand xact_type_enum            xact_type;
     rand error_response            error;
     rand psel_choose               psel;
     rand bit [3:0]                 strb;
     
     `uvm_object_utils_begin  (apb_transaction)
          `uvm_field_enum     (xact_type_enum, xact_type, UVM_ALL_ON | UVM_HEX)
          `uvm_field_enum     (error_response, error    , UVM_ALL_ON | UVM_HEX)
          `uvm_field_enum     (psel_choose,    psel     , UVM_ALL_ON | UVM_HEX)
          `uvm_field_int      (addr                     , UVM_ALL_ON | UVM_HEX)
          `uvm_field_int      (data                     , UVM_ALL_ON | UVM_HEX)
          `uvm_field_int      (strb                     , UVM_ALL_ON | UVM_HEX)
     `uvm_object_utils_end

     function new(string name = "apb_transaction");
          super.new(name);
     endfunction: new

endclass: apb_transaction
