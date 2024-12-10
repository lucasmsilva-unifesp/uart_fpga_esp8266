`timescale 1ns / 1ps

module uart_fpga_esp8266
(
    input clk,
    input rxd,
    output txd,
    output LEDmind,
    output LED
);

wire clk_9600; 
wire receive_ack; 
wire [7:0]data;

uart_tx uart_tx(
    .clk(clk_9600),
    .txd(txd),
    //.rst(1),
    .data_o(data), 
    .receive_ack(receive_ack),
    .LEDmind(LEDmind)
);

uart_rx uart_rx(
    .clk(clk_9600),
    .rxd(rxd),
    .data_i(data),
    .receive_ack( receive_ack),
    .LED(LED)
);

clk_div clk_div(
    .clk(clk),
    .clk_out(clk_9600)
);

endmodule
