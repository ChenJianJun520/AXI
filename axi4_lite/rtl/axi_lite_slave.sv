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
    output logic rd_en
);

    // ------------------- Write Transaction -------------------
    //  Write Address Channel
    assign waddr = s_axi_lite.awaddr;
    
    always_ff @(posedge clk or negedge rst)
        if(!rst)
            s_axi_lite.awready <= 0;
        else if(s_axi_lite.awready && s_axi_lite.awvalid)
            s_axi_lite.awready <= 0;
        else if(wready && wvalid)
            s_axi_lite.awready <= 1;
        else
            s_axi_lite.awready <= 0;

    //  Write Data Channel
    assign wdata = s_axi_lite.wdata;
    
    always_ff @(posedge clk or negedge rst)
        if(!rst)
            s_axi_lite.wready <= 0;
        else if(s_axi_lite.wready && s_axi_lite.wvalid)
            s_axi_lite.wready <= 0;
        else if(wready && wvalid)
            s_axi_lite.wready <= 1;
        else
            s_axi_lite.wready <= 0;

    //  Write Response Channel
    assign s_axi_lite.bresp = bresp;

    always_ff @(posedge clk or negedge rst)
        if(!rst)
            s_axi_lite.bvalid <= 0;
        else if(wready && wvalid)
            s_axi_lite.bvalid <= 1; 
        else if(s_axi_lite.bvalid && s_axi_lite.bready)
            s_axi_lite.bvalid <= 0;
        else
            s_axi_lite.bvalid <= s_axi_lite.bvalid;

    logic awvalid_reg,wvalid_reg;
    always_ff @(posedge clk or negedge rst)
        if(!rst)begin
            awvalid_reg <= 0;
            wvalid_reg <= 0;
        end
        else begin
            awvalid_reg <= s_axi_lite.awvalid;
            wvalid_reg <= s_axi_lite.wvalid;
        end

    logic awvalid_pos,wvalid_pos;
    assign awvalid_pos = s_axi_lite.awvalid && !awvalid_reg;
    assign wvalid_pos = s_axi_lite.wvalid && !wvalid_reg;

    always_ff @(posedge clk or negedge rst)
        if(!rst)
            wvalid <= 0;
        else if(awvalid_pos && wvalid_pos)
            wvalid <= 1;
        else if(wvalid && wready)
            wvalid <= 0;
        else
            wvalid <= wvalid;

    // ------------------- Read Transaction -------------------
    //  Read Address Channel
    assign raddr = s_axi_lite.araddr;

    assign s_axi_lite.arready = 1;

    //  Read Data Channel
    assign s_axi_lite.rresp = rresp;

    always_ff @(posedge clk or negedge rst)
        if(!rst)
            s_axi_lite.rvalid <= 0;
        else if(s_axi_lite.arvalid)
            s_axi_lite.rvalid <= 1;
        else if(s_axi_lite.rvalid && s_axi_lite.rready)
            s_axi_lite.rvalid <= 0;
        else
            s_axi_lite.rvalid <= s_axi_lite.rvalid;

    assign s_axi_lite.rdata = rdata;

    logic arvalid_reg;
    always_ff @(posedge clk or negedge rst)
        if(!rst)
            arvalid_reg <= 0;
        else 
            arvalid_reg <= s_axi_lite.arvalid;

    assign rd_en = s_axi_lite.arvalid && !arvalid_reg;

endmodule

