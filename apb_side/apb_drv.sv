class apb_driver extends uvm_driver#(apb_xtn);
  `uvm_component_utils(apb_driver)

  virtual mem_if.DRV_MP vif;
  apb_config apb_cfg;

  extern function new(string name="apb_driver",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task write(apb_xtn xtn);
  extern task read(apb_xtn xtn);
  extern task send_to_dut(apb_xtn xtn);

endclass


function apb_driver::new(string name="apb_driver",uvm_component parent);
  super.new(name,parent);
endfunction


function void apb_driver::build_phase(uvm_phase phase);
  if(!uvm_config_db#(apb_config)::get(this,"","apb_config",apb_cfg))
    `uvm_fatal(get_type_name(),"uvm_config is failed to get in apb_drv")
endfunction


function void apb_driver::connect_phase(uvm_phase phase);
  vif = apb_cfg.vif;
endfunction


task apb_driver::run_phase(uvm_phase phase);

 // $display("[%0t] DRIVER : run_phase started",$time);

  forever
  begin

   // $display("[%0t] DRIVER : Waiting for transaction",$time);

    seq_item_port.get_next_item(req);

   // $display("[%0t] DRIVER : Transaction received",$time);
    $display("wr_rd=%0d addr=%0h wdata=%0h",
              req.wr_rd,req.addr,req.wdata);

    send_to_dut(req);

    $display("[%0t] DRIVER : Transaction completed",$time);

    seq_item_port.item_done();

  end

endtask


task apb_driver::send_to_dut(apb_xtn xtn);

  $display("[%0t] DRIVER : Entered send_to_dut",$time);

  if(xtn.wr_rd)
    write(xtn);
  else
    read(xtn);

endtask


task apb_driver::write(apb_xtn xtn);

  //$display("[%0t] DRIVER : WRITE task entered",$time);

  @(vif.drv_cb);

  //$display("[%0t] DRIVER : Clock received",$time);

  vif.drv_cb.valid <= 1;
  vif.drv_cb.wr_rd <= 1;
  vif.drv_cb.addr  <= xtn.addr;
  vif.drv_cb.wdata <= xtn.wdata;

 // $display("[%0t] DRIVER : Waiting for READY",$time);

  wait(vif.drv_cb.ready);

 // $display("[%0t] DRIVER : READY received",$time);

  vif.drv_cb.valid <= 0;

  `uvm_info("APB_DRIVER",
            $sformatf("printing from apb_driver write\n%s",
            xtn.sprint()),UVM_LOW)

endtask


task apb_driver::read(apb_xtn xtn);

 // $display("[%0t] DRIVER : READ task entered",$time);

  @(vif.drv_cb);

  //$display("[%0t] DRIVER : Clock received",$time);

  vif.drv_cb.valid <= 1;
  vif.drv_cb.wr_rd <= 0;
  vif.drv_cb.addr  <= xtn.addr;

  //$display("[%0t] DRIVER : Waiting for READY",$time);

  wait(vif.drv_cb.ready);

//  $display("[%0t] DRIVER : READY received",$time);

  vif.drv_cb.valid <= 0;

  `uvm_info("APB_DRIVER",
            $sformatf("printing from apb_driver read\n%s",
            xtn.sprint()),UVM_LOW)

endtask
