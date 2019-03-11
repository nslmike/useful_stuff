

`default_nettype none

module slr_multi_cross #
(
   parameter   REGS_BEFORE  = 1,
   parameter   REGS_AFTER   = 1,
   parameter   WIDTH        = 16,
   parameter   NUM_SLRS     = 3
)
(
   input wire                    clk,
   //
   input wire     [WIDTH-1 : 0]  d,
   output logic   [WIDTH-1 : 0]  q,
   //
   input wire                    sreset
);

   wire  [WIDTH-1:0]    data_pipe[NUM_SLRS];

   assign data_pipe[0] = d;

   genvar g;
   for (g = 0; g < (NUM_SLRS - 1); g++) begin : GEN_SLR_CROSS
      slr_cross #
      (
         .REGS_BEFORE   ( REGS_BEFORE  ),
         .REGS_AFTER    ( REGS_AFTER   ),
         .WIDTH         ( WIDTH        )
      ) slr_cross_inst (
         .clk,
         .d       ( data_pipe [g + 0]  ),
         .q       ( data_pipe [g + 1]  ),
         .sreset
      );
   end : GEN_SLR_CROSS

   reg [REGS_AFTER + REGS_BEFORE - 1 : 0] extra_delay;

   always_ff @ (posedge clk) {q, extra_delay} <= (extra_delay << 1) | (sreset ? 1'b0 : data_pipe[NUM_SLRS - 1]);

   // assign q = data_pipe[NUM_SLRS - 1];

endmodule : slr_multi_cross

`default_nettype wire
