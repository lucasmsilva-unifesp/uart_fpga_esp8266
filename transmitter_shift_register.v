module transmitter_shift_register
(
    input BCLK,
    input RST,
    input ts_load,         // signal to load data to register
    input ts_shift,        // signal to shift bit
    input [7:0] data_in,   // data to transmit
    output [1:0] wsl,      // word length select
    // output stb,            // number of STOP
    // output [2:0] parity,   // parity signal
    // output bc,             // break control
    output reg TX_OUT,     // transmitted data
    output reg tsr_busy // signal when register is busy
);

reg [11:0] shift_reg;          // register with start, data and stop bit
reg [3:0] bit_counter;         // bit counter

localparam START_WIDTH = 1'b1;
localparam STOP_WIDTH = 1'b1;

wire [3:0] data_width;
assign data_width = 4'h05 + wsl;

// TODO: make stop options
// TODO: make parity options
// TODO: make break control options

wire [3:0] tx_width;
assign tx_width = START_WIDTH + data_width + STOP_WIDTH;

initial begin
    TX_OUT = 1'b1;
    tsr_busy = 1'b0;
    
end

always @(posedge BCLK or posedge RST) begin
    if (RST) begin
        shift_reg   <= 10'b11111111;  // inative line(idle, default is 1)
        bit_counter <= 0;
        tsr_busy    <= 0;
        TX_OUT      <= 1;              
    end else if (ts_load) begin
        // TODO: Other options of shift_reg
        shift_reg   <= {1'b1, // stop
                        data_in, 
                        1'b0}; // start
        bit_counter <= tx_width;
        tsr_busy    <= 1; 
    end else if (ts_shift && tsr_busy) begin
        TX_OUT      <= shift_reg[0];
        shift_reg   <= {1'b1, shift_reg[9:1]};
        bit_counter <= bit_counter - 1;

        if (bit_counter == 1) begin
            tsr_busy <= 0;
        end
    end
end

endmodule
