import axi_lite_pkg::*;

module tb_top;

    bit clk;
    bit rst;

    axi_lite_if u_axi_lite_if(clk,rst);

    localparam STEP = 10;

    always begin
        aclk = 1; #(STEP / 2);
        aclk = 0; #(STEP / 2);
    end

    addr_t waddr;
    data_t wdata;
    logic start_write;
    logic w_error;
    logic w_done;

    addr_t raddr;
    data_t rdata;
    logic start_read;
    logic r_error;
    logic r_done;






endmodule
