class apb_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(apb_scoreboard)
  apb_xtn xtn;
covergroup mem_cg;

  option.per_instance = 1;

  WR_RD : coverpoint xtn.wr_rd {
    bins WRITE = {1};
    bins READ  = {0};
  }

  ADDR : coverpoint xtn.addr {
    bins ADDR[] = {[0:15]};
  }

  READY : coverpoint xtn.ready {
    bins READY = {1};
  }

  WDATA : coverpoint xtn.wdata {
    bins ZERO = {8'h00};
    bins FF   = {8'hFF};
    bins OTHERS = default;
  }

  RDATA : coverpoint xtn.rdata {
    bins ZERO = {8'h00};
    bins FF   = {8'hFF};
    bins OTHERS = default;
  }

  WR_RD_X_ADDR : cross WR_RD, ADDR;

endgroup
  // Analysis implementation port
//  uvm_analysis_imp #(apb_xtn,apb_scoreboard) sb_port;
  // Reference Memory
uvm_tlm_analysis_fifo#(apb_xtn) sb_port;
 bit [7:0] ref_mem [0:15];
  extern function new(string name="apb_scoreboard",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
 // extern function void write(apb_xtn xtn);
 // extern task write_check(apb_xtn xtn);
 // extern task read_check(apb_xtn xtn);
endclass
function apb_scoreboard::new(string name="apb_scoreboard",uvm_component parent);
  super.new(name,parent);
  sb_port = new("sb_port",this);
mem_cg=new();
endfunction
function void apb_scoreboard::build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction
task apb_scoreboard::run_phase(uvm_phase phase);

    forever begin

      // Receive transaction from monitor
      sb_port.get(xtn);
mem_cg.sample();

      // Write Operation
      if(xtn.wr_rd) begin

        ref_mem[xtn.addr] = xtn.wdata;

        `uvm_info("SCOREBOARD",
                  $sformatf("WRITE : Addr=%0d Data=%0h",
                            xtn.addr, xtn.wdata),
                  UVM_LOW)

      end

      // Read Operation
      else if(xtn.wr_rd==0) begin

        if(ref_mem[xtn.addr] == xtn.rdata)

          `uvm_info("SCOREBOARD",
                    $sformatf("PASS : Addr=%0d Expected=%0h Actual=%0h",
                              xtn.addr,
                              ref_mem[xtn.addr],
                              xtn.rdata),
                    UVM_LOW)

        else

          `uvm_error("SCOREBOARD",
                     $sformatf("FAIL : Addr=%0d Expected=%0h Actual=%0h",
                               xtn.addr,
                               ref_mem[xtn.addr],
                               xtn.rdata))
    end

    end

  endtask
