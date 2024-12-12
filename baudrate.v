module baudrate
#(
    parameter CLOCK = 50000000,
    parameter BAUDRATE = 9600,
    parameter BAUDCLOCK = 16
)
(
    input CLK,
	input RST,
    output reg BCLK
);

localparam LIMITER = CLOCK / (BAUDRATE * BAUDCLOCK);
localparam COUNTER_WIDTH = $clog2(LIMITER);

reg [COUNTER_WIDTH-1:0] counter;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        counter <= 0;   
        BCLK    <= 1'b0;   
    end else if (counter == (LIMITER-1)) begin
        counter <= 0;
        BCLK <= 1'b1;
    end else begin
        counter <= (counter + 1)  & {(COUNTER_WIDTH){1'b1}};
        BCLK <= 1'b0;
    end
end

endmodule