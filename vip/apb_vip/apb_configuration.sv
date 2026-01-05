class apb_configuration extends uvm_object;
     typedef enum bit {
          NO_ERROR = 0,
          ERROR    = 1 
     } error_response;
     
     rand error_response error;

     `uvm_object_utils_begin  (apb_configuration)
          `uvm_field_enum     (error_response, error, UVM_ALL_ON | UVM_HEX)
     `uvm_object_utils_end

     function new(string name = "apb_configuration");
          super.new(name);
     endfunction: new
endclass: apb_configuration
