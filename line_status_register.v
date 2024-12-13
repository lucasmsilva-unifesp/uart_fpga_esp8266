module line_status_register (
    input wire BCLK,
    input wire RST,
    input wire data_ready,         // Indicates if there is data in the RBR (Receiver Buffer Register)
    input wire overrun_error,      // Indicates buffer error (data overwrite)
    input wire parity_error,       // Indicates parity error
    input wire framing_error,      // Indicates framing error
    input wire break_interrupt,    // Indicates detection of a "break" signal
    input wire thr_empty,          // Indicates THR is empty
    input wire tsr_empty,          // Indicates TSR is empty
    input wire fifo_error,         // Indicates FIFO reception error
    output reg [7:0] LSR           // Line Status Register
);

localparam LSR_DEFAULT = 8'b01100000;

initial begin
    LSR = LSR_DEFAULT;
end

always @(posedge BCLK or posedge RST) begin
    if (RST) begin
        LSR <= LSR_DEFAULT; // Initialize with THRE=1 and TEMT=1
    end else begin
        LSR[0] <= data_ready;           // Data Ready: Indicates that data is available
        LSR[1] <= overrun_error;        // Overrun Error: Buffer overrun error
        LSR[2] <= parity_error;         // Parity Error: Parity error
        LSR[3] <= framing_error;        // Framing Error: Framing error
        LSR[4] <= break_interrupt;      // Break Interrupt: Interrupt by "break"
        LSR[5] <= thr_empty;            // Transmitter Holding Register Empty: THR is empty
        LSR[6] <= tsr_empty;            // Transmitter Shift Register Empty: TSR is empty
        LSR[7] <= fifo_error;           // FIFO Error: FIFO error
    end
end

endmodule
