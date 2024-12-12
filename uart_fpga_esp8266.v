module uart_fpga_esp8266
(
    input CLK,
    input RST
);

wire BCLK;

baudrate baudrate
#(
    .CLOCK(50000000), // DE2-155 is 50MHz of clock
    .BAUDRATE(9600),
    .BAUDCLOCK(16),   // number of tick in one BCLK
)
(
    .CLK(CLK),
    .RST(RST),
    .BCLK(BCLK)
);

endmodule
