import axi_lite_pkg::*;

module axi_lite_slave(
    input clk,
    input rst,

    axi_lite_if.slave s_axi_lite,

    //  External control
    output data_t wdata,
    output addr_t waddr,
    output wvalid,
    input wready,
    input resp_t bresp,

    input data_t rdata,
    output addr_t raddr,
    input rvalid,
    output rready,
    input resp_t rresp
);

    // ------------------- Write Transaction -------------------
    //  Write Address Channel
    assign waddr = s_axi_lite.awaddr;
    
    logic awready_reg;
    always_ff @(posedge clk or negedge rst)
        if(!rst)
            awready_reg <= 0;
        else if(wready)
            awready_reg <= 1;
        else
            awready_reg <= 0;
    assign s_axi_lite.awready = awready_reg;

    //  Write Data Channel
    assign wdata = s_axi_lite.wdata;
    
    logic wready_reg;
    always_ff @(posedge clk or negedge rst)
        if(!rst)
            wready_reg <= 0;
        else if(wready)
            wready_reg <= 1;
        else
            wready_reg <= 0;
    assign s_axi_lite.wready = wready_reg;

    //  Write Response Channel
    assign s_axi_lite.bresp = bresp;

    logic bvalid_reg;
    always_ff @(posedge clk or negedge rst)
        if(!rst)
            bvalid_reg <= 0;
        else if(wready)
            bvalid_reg <= 1; 
        else if(s_axi_lite.bvalid && s_axi_lite.bready)
            bvalid_reg <= 0;
        else
            bvalid_reg <= bvalid_reg;
    assign s_axi_lite.bvalid = bvalid_reg;

    assign s_axi_lite.bresp = bresp;

    logic wvalid_reg;
    always_ff @(posedge clk or negedge rst)
        if(!rst)
            wvalid_reg <= 0;
        else if(s_axi_lite.awvalid && s_axi_lite.wvalid)
            wvalid_reg <= 1;
        else if(wvalid && wready)
            wvalid_reg <= 0;
        else
            wvalid_reg <= wvalid_reg;
    assign wvalid = wvalid_reg;


    // ------------------- Read Transaction -------------------
    //  Read Address Channel
    assign raddr = s_axi_lite.araddr;

    logic arready_reg;
    always_ff @(posedge clk or negedge rst)
        if(!rst)
            arready_reg <= 0;
        else if(s_axi_lite.arvalid)
            arready_reg <= 1;
        else
            arready_reg <= 0;
    assign s_axi_lite.arready = arready_reg;

    //  Read Data Channel
    assign s_axi_lite.rdata = rdata;

    assign s_axi_lite.rresp = rresp;

    logic rvalid_reg;
    always_ff @(posedge clk or negedge rst)
        if(!rst)
            rvalid_reg <= 0;
        else if(rvalid && rready)
            rvalid_reg <= 1;
        else if(s_axi_lite.rvalid && s_axi_lite.rready)
            rvalid_reg <= 0;
        else
            rvalid_reg <= rvalid_reg;
    assign s_axi_lite.rvalid = rvalid_reg;

    logic rready_reg;
    always_ff @(posedge clk or negedge rst)
        if(!rst)
            rready_reg <= 0;
        else if(s_axi_lite.arvalid)
            rready_reg <= 1;
        else if(rvalid && rready)
            rready_reg <= 0;
        else
            rready_reg <= rready_reg;
    assign rready = rready_reg;

    assign s_axi_lite.rdata = rdata;

endmodule

