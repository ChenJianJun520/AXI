import axi_lite_pkg::*;

module  axi_lite_master(
    input clk,
    input rst,

    axi_lite_if.master m_axi_lite,


    //  External control
    input addr_t waddr,
    input data_t wdata,
    input start_write,
    output w_error,
    output w_done,

    input addr_t raddr,
    output data_t rdata,
    input start_read,
    output r_error,
    output r_done

);

    //  ----------------- Write Transaction ------------------
    logic start_write_reg;
    always_ff @(posedge clk or negedge rst)
        if(!rst)
            start_write_reg <= 0;
        else
            start_write_reg <= start_write;

    logic start_w_en = start_write && !start_write_reg;

    //  Write Address Channel
    addr_t waddr_reg;
    always_ff @(posedge clk or negedge rst)
        if(!rst)
            waddr_reg <= 0;
        else if(start_w_en)
            waddr_reg <= waddr;
        else
            waddr_reg <= waddr_reg;
    assign  m_axi_lite.awaddr = waddr_reg;

    logic awvalid_reg;
    always_ff @(posedge clk or negedge rst)
        if(!rst)
            awvalid_reg <= 0;
        else if(start_w_en)
            awvalid_reg <= 1;
        else if(m_axi_lite.awready)
            awvalid_reg <= 0;
        else
            awvalid_reg <= awvalid_reg;
    assign  m_axi_lite.awvalid = awvalid_reg;

    //  Write Data Channel
    data_t wdata_reg;
    always_ff @(posedge clk or negedge rst)
        if(!rst)
            wdata_reg <= 0;
        else if(start_w_en)
            wdata_reg <= wdata;
        else
            wdata_reg <= wdata_reg;
    assign  m_axi_lite.wdata = wdata_reg;

    assign  m_axi_lite.wstrb = 4'b1111;

    logic wvalid_reg;
    always_ff @(posedge clk or negedge rst)
        if(!rst)
            wvalid_reg <= 0;
        else if(start_w_en)
            wvalid_reg <= 1;
        else if(m_axi_lite.wready)
            wvalid_reg <= 0;
        else
            wvalid_reg <= wvalid_reg;
    assign  m_axi_lite_wvalid = wvalid_reg;

    //  Response Channel
    logic bready_reg;
    always_ff @(posedge clk or negedge rst)
        if(!rst)
            bready_reg <= 0;
        else if(start_w_en)
            bready_reg <= 1;
        else if(w_done)
            bready_reg <= 0;
        else
            bready_reg <= bready_reg;
    assign  m_axi_lite.bready = bready_reg;

    logic w_error_reg;
    always_ff @(posedge clk or negedge rst)
        if(!rst)
            w_error_reg <= 0;
        else if(start_w_en)
            w_error_reg <= 0;
        else if(m_axi_lite.bvalid && m_axi_lite.bready)
            w_error_reg <= (m_axi_lite.bresp==RESP_OKAY)? 0 : 1;
        else
            w_error_reg <= w_error_reg;
    assign  w_error = w_error_reg;

    logic w_done_reg;
    always_ff @(posedge clk or negedge rst)
        if(!rst)
            w_done_reg <= 0;
        else if(start_w_en)
            w_done_reg <= 0;
        else if(m_axi_lite.bvalid && m_axi_lite.bready)
            w_done_reg <= 1;
        else
            w_done_reg <= w_done_reg;
    assign  w_done = w_done_reg;

    //  ----------------- Read Transaction ------------------
    logic start_read_reg;
    always_ff @(posedge clk or negedge rst)
        if(!rst)
            start_read_reg <= 0;
        else
            start_read_reg <= start_read;

    logic start_r_en = start_read && !start_read_reg;

    //  Read Address Channel
    addr_t raddr_reg;
    always_ff @(posedge clk or negedge rst)
        if(!rst)
            raddr_reg <= 0;
        else if(start_r_en)
            raddr_reg <= raddr; 
        else
            raddr_reg <= raddr_reg;
    assign  m_axi_lite.araddr = raddr_reg;
   
    logic arvalid_reg;
    always_ff @(posedge clk or negedge rst)
        if(!rst)
            arvalid_reg <= 0;
        else if(start_r_en)
            arvalid_reg <= 1;
        else if(m_axi_lite.arready)
            arvalid_reg <= 0;
        else
            arvalid_reg <= arvalid_reg;
    assign  m_axi_lite.arvalid = arvalid_reg;

    //  Read Data Channel
    logic rready_reg;
    always_ff @(posedge clk or negedge rst)
        if(!rst)
            rready_reg <= 0;
        else if(start_r_en)
            rready_reg <= 1;
        else if(m_axi_lite.rvalid)
            rready_reg <= 0;
        else
            rready_reg <= rready_reg;
    assign  m_axi_lite.rready = rready_reg;

    assign rdata = m_axi_lite.rdata;

    logic r_error_reg; 
    always_ff @(posedge clk or negedge rst)
        if(!rst)
            r_error_reg <= 0;
        else if(m_axi_lite.rvalid)
            r_error_reg <= (m_axi_lite.rresp==RESP_OKAY)? 0 : 1;
        else
            r_error_reg <= r_error_reg;
    assign  r_error = r_error_reg;

    logic r_done_reg;
    always_ff @(posedge clk or negedge rst)
        if(!rst)
            r_done_reg <= 0;
        else if(start_r_en)
            r_done_reg <= 0;
        else if(m_axi_lite.rvalid)
            r_done_reg <= 1;
        else
            r_done_reg <= r_done_reg;
    assign r_done = r_done_reg;

endmodule

