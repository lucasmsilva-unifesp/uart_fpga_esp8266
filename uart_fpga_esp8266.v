module uart_fpga_esp8266
(
    input CLOCK_50, // clock of 50MHz
    input RST
);

wire BCLK;

baudrate baudrate
(
    .CLK(CLOCK_50),
    .RST(RST),
    .BCLK(BCLK)
);

endmodule
