class apb_monitor extends uvm_monitor;

  `uvm_component_utils(apb_monitor)

  virtual mem_if.MON_MP vif;
  apb_config apb_cfg;

  uvm_analysis_port #(apb_xtn) monitor_port;

  extern function new(string name="apb_monitor",
                      uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task collect_data(apb_xtn xtn);
 // extern task collect_write(apb_xtn xtn);
 // extern task collect_read(apb_xtn xtn);

endclass


//---------------------------------------------------------
// Constructor
//---------------------------------------------------------
function apb_monitor::new(string name="apb_monitor",
                          uvm_component parent);

  super.new(name,parent);

  monitor_port = new("monitor_port",this);

endfunction


//---------------------------------------------------------
// Build Phase
//---------------------------------------------------------
function void apb_monitor::build_phase(uvm_phase phase);

  super.build_phase(phase);

  if(!uvm_config_db#(apb_config)::get(this,"","apb_config",apb_cfg))
    `uvm_fatal(get_type_name(),
               "Failed to get apb_config in monitor")

endfunction


//---------------------------------------------------------
// Connect Phase
//---------------------------------------------------------
function void apb_monitor::connect_phase(uvm_phase phase);

  super.connect_phase(phase);

  vif = apb_cfg.vif;

  if(vif == null)
    `uvm_fatal("MONITOR","Virtual Interface is NULL")

  $display("[%0t] MONITOR : VIF Connected",$time);

endfunction
//---------------------------------------------------------
// Run Phase
//---------------------------------------------------------
task apb_monitor::run_phase(uvm_phase phase);

  apb_xtn xtn;

  $display("[%0t] MONITOR : run_phase started",$time);

  forever begin

    xtn = apb_xtn::type_id::create("xtn");

    $display("[%0t] MONITOR : Waiting for transaction",$time);

    collect_data(xtn);

    $display("[%0t] MONITOR : Transaction captured",$time);

    monitor_port.write(xtn);

    $display("[%0t] MONITOR : Transaction sent to scoreboard",$time);

  end

endtask


//---------------------------------------------------------
// Collect Data
//---------------------------------------------------------
task apb_monitor::collect_data(apb_xtn xtn);

  forever begin

    @(vif.mon_cb);

    $display("[%0t] MONITOR : clk valid=%0b ready=%0b wr_rd=%0b addr=%0h",
             $time,
             vif.mon_cb.valid,
             vif.mon_cb.ready,
             vif.mon_cb.wr_rd,
             vif.mon_cb.addr);

    if(vif.mon_cb.ready) begin

      xtn.valid = vif.mon_cb.valid;
      xtn.wr_rd = vif.mon_cb.wr_rd;
      xtn.addr  = vif.mon_cb.addr;
      xtn.ready = vif.mon_cb.ready;

      if(vif.mon_cb.wr_rd) begin

        xtn.wdata = vif.mon_cb.wdata;

        $display("[%0t] MONITOR : WRITE addr=%0h data=%0h",
                 $time,
                 xtn.addr,
                 xtn.wdata);

      end
      else begin

        xtn.rdata = vif.mon_cb.rdata;

        $display("[%0t] MONITOR : READ addr=%0h data=%0h",
                 $time,
                 xtn.addr,
                 xtn.rdata);

      end

      `uvm_info("APB_MONITOR",
                $sformatf("Transaction\n%s", xtn.sprint()),
                UVM_LOW)

      break;

    end

  end

endtask
