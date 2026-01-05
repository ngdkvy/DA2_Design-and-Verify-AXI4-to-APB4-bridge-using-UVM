covergroup APB_IP with function sample(axi_transaction axi_trans);
     option.per_instance = 1;

     axi_transfer: coverpoint axi_trans.xact_type {
          bins axi_write = {axi_transaction::WRITE};
          bins axi_read  = {axi_transaction::READ};
     }

     axi_size: coverpoint axi_trans.size_type {
          bins BYTE = {axi_transaction::BYTE_1};
          bins HALF = {axi_transaction::BYTE_2};
          bins WORD = {axi_transaction::BYTE_4};
     }

     axi_burst: coverpoint axi_trans.burst_type {
          bins FIXED = {axi_transaction::FIXED};
          bins INCR  = {axi_transaction::INCR};
          bins WRAP  = {axi_transaction::WRAP};
     }

     axi_len: coverpoint axi_trans.len {
          bins len = {[0:18]};
     }

     common: cross axi_transfer, axi_size, axi_burst, axi_len;
endgroup
