module fifo
#(
    parameter DATA_WIDTH = 8,
    parameter ADDR = 16
)
(
    input clk,
    input rst,
    input wr_en,
    input rd_en,
    input [DATA_WIDTH-1:0] wr_data,
    output reg [DATA_WIDTH-1:0] rd_data,
    output full,
    output empty
)

reg [DATA_WIDTH-1:0] fifo_mem [0:ADDR-1];

reg [$clog2(ADDR):0] wr_ptr;
reg [$clog2(ADDR):0] rd_ptr;

reg [$clog2(ADDR):0] count;

assign full = (count == ADDR);
assign empty = (count == 0);

always @(posedge clk or posedge rst)
begin
    if (rst) begin
        wr_ptr <= 0;
        rd_ptr <= 0;
        rd_data <= 0;
        count <= 0;
    end else begin
        if (wr_en && !full) begin
            fifo_mem[wr_ptr] <= wr_data;
            wr_ptr <= wr_ptr + 1;
        end

        if (rd_en && !empty) begin
            rd_data <= fifo_mem[rd_ptr];
            rd_ptr <= rd_ptr + 1;
        end

        case ({wr_en && !full, rd_en && !empty})
            2'b10: count <= count + 1;
            2'b01: count <= count - 1;
            default: count <= count;  
        endcase
    end
end

endmodule
