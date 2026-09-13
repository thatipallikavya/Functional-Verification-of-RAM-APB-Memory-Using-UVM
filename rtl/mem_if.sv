interface mem_if
#(parameter ADDR_WIDTH = 4,
  parameter WIDTH      = 8
)
(
    input logic clk,
    input logic rst
);
    logic wr_rd;
    logic valid;
    logic ready;
    logic [ADDR_WIDTH-1:0] addr;
    logic [WIDTH-1:0]      wdata;
    logic [WIDTH-1:0]      rdata;
    // Driver Clocking Block
    clocking drv_cb @(posedge clk);
        default input #0 output #1;
        input  rdata;
        input  ready;
        output wr_rd;
        output addr;
        output wdata;
        output valid;
    endclocking
    // Monitor Clocking Block
    clocking mon_cb @(posedge clk);
        default input #1;
        input wr_rd;
        input addr;
        input wdata;
        input rdata;
        input ready;
input valid;
    endclocking
    modport DRV_MP (clocking drv_cb);
    modport MON_MP (clocking mon_cb);
endinterface
