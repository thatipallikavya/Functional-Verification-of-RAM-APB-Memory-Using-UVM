class write_sequence extends uvm_sequence #(apb_xtn);
  `uvm_object_utils(write_sequence)
  apb_xtn tr;
  extern function new(string name = "write_sequence");
  extern task body();
endclass
function write_sequence::new(string name = "write_sequence");
  super.new(name);
endfunction
task write_sequence::body();
  repeat(10)
  begin
    tr = apb_xtn::type_id::create("tr");
    start_item(tr);
    assert(tr.randomize() with
    {
      wr_rd == 1;
      valid == 1;
    });
    finish_item(tr);
  end
endtask
class read_sequence extends write_sequence;
  `uvm_object_utils(read_sequence)
  extern function new(string name = "read_sequence");
  extern task body();
endclass
function read_sequence::new(string name = "read_sequence");
  super.new(name);
endfunction
task read_sequence::body();
  repeat(10)
 begin
    tr = apb_xtn::type_id::create("tr");
    start_item(tr);
    assert(tr.randomize() with
    {
      wr_rd == 0;
      valid == 1;
    });
    finish_item(tr);
  end
endtask
class read_write_sequence extends read_sequence;
  `uvm_object_utils(read_write_sequence)
  extern function new(string name = "read_write_sequence");
  extern task body();
endclass
function read_write_sequence::new(string name = "read_write_sequence");
  super.new(name);
endfunction
task read_write_sequence::body();
  repeat(20)
  begin
    tr = apb_xtn::type_id::create("tr");
    start_item(tr);
    assert(tr.randomize() with
    {
      valid == 1;
    });
    finish_item(tr);
  end
endtask
