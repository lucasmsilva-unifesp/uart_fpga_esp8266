module transmitter_holding_register (
    input CLK,
    input RST,
    input signal_wr_en,        // signal to write in THR
    input [7:0] data_in,
    input tsr_ready,           // TSR (Transmitter Shift Register) is ready
    output reg [7:0] data_out,
    output reg signal_ready    // THR is ready to recive more data              
);

reg [7:0] holding_reg;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        holding_reg  <= 8'b0;
        data_out     <= 8'b0;
        signal_ready <= 1'b1;
    end else begin
        if (signal_wr_en && signal_ready) begin
            holding_reg  <= data_in;
            signal_ready <= 1'b0;
        end

        if (tsr_ready && !signal_ready) begin
            data_out     <= holding_reg;
            signal_ready <= 1'b1;
        end
    end
end

endmodule
