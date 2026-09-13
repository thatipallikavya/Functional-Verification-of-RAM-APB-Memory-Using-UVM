module memory
#(
    parameter ADDR_WIDTH = 4,
    parameter WIDTH= 8
)
(
input logic clk,
input logic rst,
input logic wr_rd,
input logic valid,
input logic [3:0] addr,
input logic [7:0] wdata,
output logic [7:0] rdata,
output logic ready
);
logic [WIDTH-1:0] mem[(2**ADDR_WIDTH)-1:0];
integer i;
always_ff @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        ready <= 0;
        rdata <= 0;
        for(i=0;i<(2**ADDR_WIDTH);i=i+1)
            mem[i] <= 0;
    end
    else
    begin
        ready <= 0;
        if(valid)
        begin
            ready <= 1;
if(wr_rd)
            begin
                mem[addr] <= wdata;
            end
            else
            begin
                rdata <= mem[addr];
            end
        end
    end
end
endmodule
