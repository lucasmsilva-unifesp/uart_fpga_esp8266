module fifo
#(
    parameter FIFO_DEPTH = 16,       // Profundidade do FIFO
    parameter DATA_WIDTH = 8         // Largura dos dados
)
(
    input wire CLK,
    input wire RST,
    input wire FIFOEN,
    input wire RXCLR,
    input wire TXCLR,
    input wire DMAMODE,
    input wire [1:0] RXFIFTL,
    input wire [DATA_WIDTH-1:0] fifo_data_in,
    input wire fifo_wr_en,
    output reg [DATA_WIDTH-1:0] fifo_data_out,
    output reg fifo_full,
    output reg fifo_empty
);

reg [7:0] fifo_mem [0:15];

reg [$clog2(FIFO_DEPTH)-1:0] wr_ptr;
reg [$clog2(FIFO_DEPTH)-1:0] rd_ptr;

reg [$clog2(FIFO_DEPTH):0] count;

// TODO: implement DMAMODE
// TODO: implement RXFIFTL

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        wr_ptr <= 0;
        rd_ptr <= 0;
        count <= 0;
        fifo_full <= 0;
        fifo_empty <= 1;
    end else begin
        if (FIFOEN) begin
            if (fifo_wr_en && !fifo_full) begin
                fifo_mem[wr_ptr] <= fifo_data_in;
                wr_ptr <= wr_ptr + 1;
                count <= count + 1;

                if (count == 16) begin
                    fifo_full <= 1;
                end
            end

            if (!fifo_empty) begin
                fifo_data_out <= fifo_mem[rd_ptr];
                rd_ptr <= rd_ptr + 1;
                count <= count - 1;

                if (count == 0) begin
                    fifo_empty <= 1;
                end
            end

            if (RXCLR) begin
                wr_ptr <= 0;
                rd_ptr <= 0;
                count <= 0;
                fifo_full <= 0;
                fifo_empty <= 1;
            end

            if (TXCLR) begin
                wr_ptr <= 0;
                rd_ptr <= 0;
                count <= 0;
                fifo_full <= 0;
                fifo_empty <= 1;
            end
        end
    end
end

endmodule
