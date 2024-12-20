module uart_fpga_esp8266
#(
	parameter DATA_WIDTH = 4'd8
)
(
    input CLK,
    input RST,
    input wire signal_start,
    output wire signal_busy,
    output wire BCLK,
    output wire signal_load,
    output wire signal_shift,
    output wire TX_OUT
);

// ---- BAUDRATE ----

baudrate
#(
    .CLOCK(500000), // DE2-155 is 50MHz of clock
    .BAUDRATE(9600),
    .BAUDCLOCK(16)    // number of tick in one BCLK
)
baudrate
(
    .CLK(CLK),
    .RST(RST),
    .BCLK(BCLK)
);
// -----------------

// ---- TTC ----
transmitter_timing_control transmitter_timing_control (
    .BCLK(BCLK),
    .RST(RST),
    .tx_start(signal_start),
    .tsr_busy(signal_busy),
    .load_data(signal_load),
    .shift_tsr(signal_shift)
);
// -------------

// ---- TSR ----
transmitter_shift_register transmitter_shift_register_inst (
    .BCLK(BCLK),
    .RST(RST),
    .ts_load(signal_load),
    .ts_shift(signal_shift),
    .TX_OUT(TX_OUT),
    .tsr_busy(signal_busy)
);
// -------------

endmodule
