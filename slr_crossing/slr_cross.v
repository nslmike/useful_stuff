

`default_nettype none

module slr_cross #
(
   parameter   REGS_BEFORE  = 1,
   parameter   REGS_AFTER   = 1,
   parameter   WIDTH        = 16
)
(
   input wire                    clk,
   input wire     [WIDTH-1 : 0]  d,
   output wire    [WIDTH-1 : 0]  q,
   input wire                    sreset
);

   (* shreg_extract="no" *)
   reg   [WIDTH-1:0]       regs_before;

   (* USER_SLL_REG="true", shreg_extract="no" *)
   reg   [WIDTH-1 : 0]     laguna_tx;

   (* USER_SLL_REG="true", shreg_extract="no" *)
   reg   [WIDTH-1 : 0]     laguna_rx;


   (* shreg_extract="no" *)
   reg   [WIDTH-1:0]       regs_after;

   generate
      if (REGS_BEFORE == 0) begin
         always @* regs_before = d;
      end else begin
         always @ (posedge clk) regs_before <= sreset ? 0 : d;
      end
   endgenerate

   always @ (posedge clk) begin
      laguna_tx <= regs_before;
      laguna_rx <= laguna_tx;
   end

   generate
      if (REGS_AFTER == 0) begin
         always @* regs_after = d;
      end else begin
         always @ (posedge clk) regs_after <= sreset ? 0 : laguna_rx;
      end
   endgenerate

   assign q = regs_after;

endmodule : slr_cross

`default_nettype wire
