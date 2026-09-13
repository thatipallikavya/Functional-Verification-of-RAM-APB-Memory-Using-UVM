class test extends uvm_test;
  `uvm_component_utils(test)
  environment env;
  apb_config apb_cfg;
  test_config test_cfg;
  int has_apb_agt=1;
  extern function new(string name="test", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void end_of_elaboration_phase(uvm_phase phase);
endclass
//---------------- Constructor ----------------//
function test::new(string name="test", uvm_component parent);
  super.new(name,parent);
endfunction
//---------------- Build Phase ----------------//
function void test::build_phase(uvm_phase phase);
  super.build_phase(phase);
  env      = environment::type_id::create("env",this);
  apb_cfg  = apb_config::type_id::create("apb_cfg");
  test_cfg = test_config::type_id::create("test_cfg");
  if(!uvm_config_db#(virtual mem_if)::get(this,"","vif",apb_cfg.vif))
    `uvm_fatal("VIF_CONFIG",
               "Cannot get virtual interface from uvm_config_db")
  test_cfg.has_apb_agt = has_apb_agt;
  uvm_config_db#(test_config)::set(this,"*","test_config",test_cfg);
  uvm_config_db#(apb_config)::set(this,"*","apb_config",apb_cfg);
endfunction
//------------- End of Elaboration ------------//
function void test::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  uvm_top.print_topology();
endfunction
//======================================================//
//                 WRITE TEST                           //
//======================================================//
class write_test extends test;
  `uvm_component_utils(write_test)
  write_sequence w_seq;
read_sequence r_seq;
  function new(string name="write_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    w_seq = write_sequence::type_id::create("w_seq");
    r_seq =read_sequence::type_id::create("r_seq");
    w_seq.start(env.apb_agt.seqr);
r_seq.start(env.apb_agt.seqr);
    phase.drop_objection(this);
  endtask
endclass
//======================================================//
//                 READ TEST                            //
//======================================================//
class read_test extends test;
  `uvm_component_utils(read_test)
  read_sequence r_seq;
  function new(string name="read_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    r_seq = read_sequence::type_id::create("r_seq");
    r_seq.start(env.apb_agt.seqr);
    phase.drop_objection(this);
  endtask
endclass
//======================================================//
//              READ-WRITE TEST                         //
//======================================================//
class read_write_test extends test;
  `uvm_component_utils(read_write_test)
  read_write_sequence rw_seq;
  function new(string name="read_write_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    rw_seq = read_write_sequence::type_id::create("rw_seq");
    rw_seq.start(env.apb_agt.seqr);
    phase.drop_objection(this);
  endtask
endclass
