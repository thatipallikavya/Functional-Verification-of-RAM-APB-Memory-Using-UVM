module top;
import uvm_pkg::*;
import test_pkg::*;
bit clock;
always #5 clock=!clock;
bit rst;
initial
begin
rst =1;
#20;
rst=0;
end
mem_if in0(clock,rst);
memory DUV(.clk(in0.clk),
           .rst(in0.rst),
           .wr_rd(in0.wr_rd),
           .addr(in0.addr),
           .wdata(in0.wdata),
           .rdata(in0.rdata),
           .valid(in0.valid),
           .ready(in0.ready));
initial
        begin
                uvm_config_db#(virtual mem_if)::set(null,"*","vif",in0);
                run_test("read_write_test"); //For read_write operation.It can be use for separate read and write operation also
        end
endmodule
