module transmitter
#(
    parameter DATA_WIDTH = 8,
    parameter STOP_BITS = 1,
)
(
    input wire clk,
    input wire rst,
    input wire bclk,
    input wire tx_start,
    input wire [DATA_WIDTH-1:0] data_in, 
    output reg tx,
    output reg tx_busy
);

localparam IDLE  = 3'b000,
localparam START = 3'b001,
localparam DATA  = 3'b010,
localparam STOP  = 3'b011;

reg [2:0] state, next_state;
reg [DATA_WIDTH-1:0] data_reg;
reg [$clog2(DATA_WIDTH):0] bit_idx;
reg [$clog2(STOP_BITS):0] stop_count;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
    end else if (baud_tick) begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        IDLE: 
            if (tx_start) 
                next_state = START;
            else 
                next_state = IDLE;
        START: 
            next_state = DATA;
        DATA: 
            if (bit_idx == DATA_WIDTH-1)
                next_state = STOP;
            else
                next_state = DATA;
        STOP: 
            if (stop_count == STOP_BITS-1)
                next_state = IDLE;
            else
                next_state = STOP;
        default: 
            next_state = IDLE;
    endcase
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        tx <= 1'b1;       // Linha inativa
        tx_busy <= 1'b0;  // Não ocupado
        data_reg <= 0;
        bit_idx <= 0;
        stop_count <= 0;
    end else if (baud_tick) begin
        case (state)
            IDLE: begin
                tx <= 1'b1;        // Linha inativa
                tx_busy <= 1'b0;   // Não ocupado
                if (tx_start) begin
                    data_reg <= data_in; // Carrega os dados
                    bit_idx <= 0;
                    stop_count <= 0;
                    tx_busy <= 1'b1;    // Ocupado
                end
            end
            START: begin
                tx <= 1'b0; // Start bit
            end
            DATA: begin
                tx <= data_reg[bit_idx]; // Transmite o bit atual
                bit_idx <= bit_idx + 1;
            end
            STOP: begin
                tx <= 1'b1;        // Stop bit
                stop_count <= stop_count + 1;
            end
        endcase
    end
end

endmodule
