// Mike_I's vhdl-2-verilog convertion of
// olofk (github.com/olofk) module from libaxis repo

`default_nettype none

module axis_sync_fifo #
(
    parameter DATA_WIDTH = 0,
    parameter DEPTH_WIDTH = 0
)
(
    input wire                      clk,
    input wire  [DATA_WIDTH-1:0]    s_tdata,
    input wire                      s_tvalid,
    output wire                     s_tready,
    output wire [DATA_WIDTH-1:0]    m_tdata,
    output wire                     m_tvalid,
    input wire                      m_tready,
    output wire [DEPTH_WIDTH-1:0]   data_count,
    input wire                      rst
);

// synthesis translate_off
    initial begin
        if ((DATA_WIDTH < 1) || (DEPTH_WIDTH < 1)) begin
            $error("Error! DATA_WIDTH and DEPTH_WIDTH shoul be > 0");
            $fatal();
        end
    end
// synthesis translate_on

    wire    wr_en;
    wire    rd_en;
    wire    full;
    wire    empty;

    assign wr_en = ~full & s_tvalid;
    assign s_tready = ~full;

    assign m_tvalid = ~empty;
    assign rd_en = ~empty & m_tready;

    fifo_fwft #
    (
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH_WIDTH(DEPTH_WIDTH)
    )
    fifo_fwft_inst
    (
        .clk,
        .rst,
        .din    ( s_tdata       ),
        .wr_en,
        .full,
        .dout   ( m_tdata       ),
        .rd_en,
        .empty,
        .cnt    ( data_count    )
    );

endmodule // axis_sync_fifo

`default_nettype wire

