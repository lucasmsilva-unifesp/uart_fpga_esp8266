module transmitter_shift_register
(
    input BCLK,
    input RST,
    input ts_load,         // signal to load data to register
    input ts_shift,        // signal to shift bit
    output reg TX_OUT,     // transmitted data
    output reg tsr_busy // signal when register is busy
);

reg [9:0] shift_reg;          // register with start, data and stop bit
reg [3:0] bit_counter;         // bit counter

localparam START_WIDTH = 1'b1;
localparam STOP_WIDTH = 1'b1;
localparam DEFAULT_REG = 10'b1011011010;

// TODO: make stop options
// TODO: make parity options
// TODO: make break control options

initial begin
    TX_OUT = 1'b1;
    shift_reg = DEFAULT_REG;
end

always @(posedge BCLK or posedge RST) begin
    if (RST) begin
        shift_reg   <= 10'b11111111;  // inative line(idle, default is 1)
        bit_counter <= 0;
        tsr_busy    <= 0;
        TX_OUT      <= 1;              
    end else if (ts_load) begin
		  shift_reg   <= DEFAULT_REG;
        bit_counter <= 10;
        tsr_busy    <= 1; 
    end else if (tsr_busy) begin
        TX_OUT      <= shift_reg[0];
        shift_reg   <= {1'b1, shift_reg[9:1]};
        bit_counter <= bit_counter - 1;

        if (bit_counter == 0) begin
            tsr_busy <= 0;
        end
    end
end

endmodule
