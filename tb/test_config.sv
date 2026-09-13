class test_config extends uvm_object;
`uvm_object_utils(test_config)

  int has_apb_agt = 1;

  function new(string name = "test_config");
    super.new(name);
  endfunction

endclass
