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

localparam DIVISOR = CLOCK / (BAUDRATE * BAUDCLOCK);
localparam COUNT_BITS = $clog2(DIVISOR);

reg [COUNT_BITS-1:0] counter;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        counter <= 0;   
        BCLK    <= 1'b0;   
    end else if (counter == (DIVISOR-1)) begin
        counter <= 0;
        BCLK <= 1'b1;
    end else begin
        counter <= (counter + 1)  & {(COUNT_BITS){1'b1}};
        BCLK <= 1'b0;
    end
end

endmodule
