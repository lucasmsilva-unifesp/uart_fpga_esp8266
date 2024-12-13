module transmitter_timing_control
(
    input BCLK,
    input RST,
    input tx_start,       // signal to initiaze trasmition
    input thr_empty,      // THR is empty
    input tsr_busy,       // signal to indicate the transmitter is busy
    input [7:0] LCR,      // register LCR
    output [1:0] wsl,     // word length select
    // output stb,           // number of STOP
    // output [2:0] parity,  // parity signal
    // output bc,            // break control
    output reg load_data, // signal to load data to register
    output reg shift_tsr  // signal to shift bit
);


assign wsl = LCR[1:0];
// assign stb = LCR[2];
// assign parity = {LCR[5], LCR[4], LCR[3]};
// assign bc = LCR[6];

reg [1:0] state;

localparam IDLE = 2'b00;
localparam LOAD = 2'b01;
localparam SHIFT = 2'b10;

always @(posedge BCLK or posedge RST) begin
    if (RST) begin
        state     <= IDLE;
        load_data <= 0;
        shift_tsr <= 0;
    end else begin
        case (state)
        IDLE: begin
            if (tx_start && !tsr_busy) begin
                state <= LOAD;
            end
            load_data <= 0;
            shift_tsr <= 0;
        end
        LOAD: begin
            LOAD: begin
                load_data <= 1;
                state     <= SHIFT;
            end
        end
        SHIFT: begin
            load_data <= 0;
            shift_tsr <= 1; 
            if (!tsr_busy) begin
                state <= IDLE; 
            end
        end
		  endcase
    end
end

endmodule
