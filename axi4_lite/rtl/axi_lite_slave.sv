module axi_lite_slave(
    input clk,
    input rst,

    axi_lite_if.slave s_axi_lite,

    //  External control
    output data_t wdata,
    output addr_t waddr,
    output logic wvalid,
    input wready,
    input resp_t bresp,

    input data_t rdata,
    output addr_t raddr,
    input resp_t rresp,
    input rvalid,
    output logic rd_en
);

    // ------------------- Write Transaction -------------------
    //  Write Address Channel
    assign waddr = s_axi_lite.awaddr;
    
    assign s_axi_lite.awready = wvalid && wready;

    //  Write Data Channel
    assign wdata = s_axi_lite.wdata;
    
    assign s_axi_lite.wready = wvalid && wready;

    //  Write Response Channel
    assign s_axi_lite.bresp = bresp;

    always_ff @(posedge clk or negedge rst)
        if(!rst)
            s_axi_lite.bvalid <= 0;
        else if(s_axi_lite.bvalid && s_axi_lite.bready)
            s_axi_lite.bvalid <= 0;
        else if(wvalid && wready)
            s_axi_lite.bvalid <= 1;
        else
            s_axi_lite.bvalid <= s_axi_lite.bvalid;

    assign wvalid = s_axi_lite.awvalid && s_axi_lite.wvalid;

    // ------------------- Read Transaction -------------------
    //  Read Address Channel
    assign raddr = s_axi_lite.araddr;

    assign s_axi_lite.arready = rvalid;

    //  Read Data Channel
    assign s_axi_lite.rresp = rresp;

    always_ff @(posedge clk or negedge rst)
        if(!rst)
            s_axi_lite.rvalid <= 0;
        else if(s_axi_lite.rvalid && s_axi_lite.rready)
            s_axi_lite.rvalid <= 0;
        else if(s_axi_lite.arvalid || rd_en)
            s_axi_lite.rvalid <= rvalid;
        else
            s_axi_lite.rvalid <= s_axi_lite.rvalid;
    
    always_ff @(posedge clk or negedge rst)
        if(!rst)
            s_axi_lite.rdata <= 0;
        else if(rvalid)
            s_axi_lite.rdata <= rdata;
        else
            s_axi_lite.rdata <= s_axi_lite.rdata;

    logic arvalid_reg;
    always_ff @(posedge clk or negedge rst)
        if(!rst)
            arvalid_reg <= 0;
        else 
            arvalid_reg <= s_axi_lite.arvalid;

    assign rd_en = s_axi_lite.arvalid && !arvalid_reg;

endmodule

