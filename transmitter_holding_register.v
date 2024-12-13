module transmitter_holding_register (
    input wire CLK,
    input wire RST,
    input wire FIFOEN,
    input wire [7:0] thr_data_in,
    input wire thr_write,           // signal to write in THR
    input wire tsr_ready,           // TSR (Transmitter Shift Register) is ready
    output reg [7:0] th_data_out,
    output reg th_empty             // THR is empty and recive more data              
);

reg [7:0] holding_reg;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        holding_reg  <= 8'b0;
        th_data_out  <= 8'b0;
        th_empty     <= 1'b1;
    end else if (!FIFOEN) begin
        if (thr_write & th_empty) begin
            holding_reg <= thr_data_in;
            th_empty    <= 1'b0;
        end

        // TODO: make thr stay empty until new data is put

        if (tsr_ready & !th_empty) begin
            th_data_out <= holding_reg;
            th_empty    <= 1'b1;
        end
    end
end

endmodule
