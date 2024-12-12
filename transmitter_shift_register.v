module transmitter_shift_register
(
    input BCLK,
    input RST,
    input signal_load,     // signal to load data to register
    input signal_shift,    // signal to shift bit
    input [7:0] data_in,   // data to transmit
    output reg TX_OUT,     // transmitted data
    output reg signal_busy // signal when register is busy
);

reg [9:0] shift_reg;          // register with start, data and stop bit
reg [3:0] bit_counter;        // bit counter

always @(posedge BCLK or posedge RST) begin
    if (RST) begin
        shift_reg   <= 10'b1111111111;  // inative line(idle, default is 1)
        bit_counter <= 0;
        signal_busy <= 0;
        TX_OUT      <= 1;              
    end else if (signal_load) begin
        shift_reg   <= {1'b1, data_in, 1'b0};
        bit_counter <= 10;                
        signal_busy <= 1;                        
    end else if (signal_shift && signal_busy) begin
        TX_OUT      <= shift_reg[0];
        shift_reg   <= {1'b1, shift_reg[9:1]};
        bit_counter <= bit_counter - 1;

        if (bit_counter == 1) begin
            signal_busy <= 0;
        end
    end
end

endmodule
