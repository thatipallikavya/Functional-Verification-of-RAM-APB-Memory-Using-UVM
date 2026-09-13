class apb_xtn extends uvm_sequence_item;
`uvm_object_utils(apb_xtn)
  rand bit wr_rd;
  rand bit valid;
  rand bit [3:0]addr;
  rand bit [7:0] wdata;
  // Response fields
  bit [7:0] rdata;
  bit ready;
  // Optional Constraints
  constraint valid_c
  {
    valid == 1;
  }
  extern function new(string name="apb_xtn");
  extern function void do_print(uvm_printer printer);
endclass
//======================================================
// Constructor
//======================================================
function apb_xtn::new(string name="apb_xtn");
  super.new(name);
endfunction
//======================================================
// Print Method
//======================================================
function void apb_xtn::do_print(uvm_printer printer);
  super.do_print(printer);
  printer.print_field("wr_rd", wr_rd, 1, UVM_BIN);
  printer.print_field("valid", valid, 1, UVM_BIN);
  printer.print_field("addr", addr, 4, UVM_HEX);
  printer.print_field("wdata", wdata, 8, UVM_HEX);
 printer.print_field("rdata", rdata, 8, UVM_HEX);
  printer.print_field("ready", ready, 1, UVM_BIN);
endfunction
