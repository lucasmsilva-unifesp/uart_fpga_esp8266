module transmitter_timing_control
(
    input BCLK,
    input RST,
    input signal_start,     // signal to initiaze trasmition
    input signal_busy,      // signal to indicate the transmitter is busy
    output reg signal_load, // signal to load data to register
    output reg signal_shift // signal to shift bit
);

reg [3:0] state;

localparam IDLE = 0;
localparam LOAD = 1;
localparam SHIFT = 2;

always @(posedge BCLK or posedge RST) begin
    if (RST) begin
        state        <= IDLE;
        signal_load  <= 0;
        signal_shift <= 0;
    end else begin
        case (state)
        IDLE: begin
            if (signal_start && !signal_busy) begin
                state <= LOAD;
            end
            signal_load  <= 0;
            signal_shift <= 0;
        end
        LOAD: begin
            LOAD: begin
                signal_load <= 1;
                state       <= SHIFT;
            end
        end
        SHIFT: begin
            signal_load  <= 0;
            signal_shift <= 1; 
            if (!signal_busy) begin
                state <= IDLE; 
            end
        end
		  endcase
    end
end

endmodule
