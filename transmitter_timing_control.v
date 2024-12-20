module transmitter_timing_control
(
    input wire BCLK,
    input wire RST,
    input wire tx_start,       // signal to initiaze trasmition
    input wire tsr_busy,       // signal to indicate the transmitter is busy
    output reg load_data, // signal to load data to register
    output reg shift_tsr  // signal to shift bit
);


// assign wsl = LCR[1:0];

localparam IDLE = 2'b00;
localparam LOAD = 2'b01;
localparam SHIFT = 2'b10;

reg [1:0] state = IDLE;

always @(posedge BCLK or posedge RST) begin
    if (RST) begin
        state     <= IDLE;
        load_data <= 0;
        shift_tsr <= 0;
    end else begin
        case (state)
        IDLE: begin
            load_data <= 0;
            shift_tsr <= 0;
            if (tx_start) begin
                state <= LOAD;
					 load_data <= 1;
            end
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
