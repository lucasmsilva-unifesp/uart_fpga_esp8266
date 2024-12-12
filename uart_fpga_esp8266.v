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

fifo
#(
    .DATA_WIDTH(8),
    .ADDR(16)
)
fifo_transmitter
(
    .clk(CLK),
    .rst(RST),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .wr_data(wr_data),
    .rd_data(rd_data),
    .full(full),
    .empty(empty)
)

endmodule
