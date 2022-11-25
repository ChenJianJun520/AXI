import axi_lite_pkg::*;

interface axi_lite_if;

    //  Read Address Channel
    addr_t araddr;
    logic arvalid;
    logic arready;

    //  Read Data Channel
    data_t rdata;
    resp_t rresp;
    logic rvalid;
    logic rready;

    //  Write Address Channel
    addr_t awaddr;
    logic awvalid;
    logic awready;

    //  Write Data Channel
    data_t wdata;
    strb_t wstrb;
    logic wvalid;
    logic wready;

    //  Write Response Channel
    resp_t bresp;
    logic bvalid;
    logic bready;

    modport master (
        output araddr, arvalid, input arready,
        output rready, input rdata, rresp, rvalid,
        output awaddr, awvalid, input awready,
        output wdata, wstrb, wvalid, input wready,
        output bready, input bresp, bvalid
    );

    modport slave (
        input araddr, arvalid, output arready,
        input rready, output rdata, rresp, rvalid,
        input awaddr, awvalid, output awready,
        input wdata, wstrb, wvalid, output wready,
        input bready, output bresp, bvalid
    );

endinterface

