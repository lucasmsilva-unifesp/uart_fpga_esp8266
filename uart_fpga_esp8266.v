module uart_fpga_esp8266
(
    input CLK,
    input RST,
    input btn,
    input [DATA_WIDTH-1:0] data_in,
    output wire TX_OUT
);

// ---- BAUDRATE ----
wire BCLK;

baudrate
#(
    .CLOCK(50000000), // DE2-155 is 50MHz of clock
    .BAUDRATE(9600),
    .BAUDCLOCK(16)    // number of tick in one BCLK
)
baudrate
(
    .CLK(CLK),
    .RST(RST),
    .BCLK(BCLK)
);
// -----------------

// ---- LCR ----
/**
 * LCR (Line Control Register) description:
 * 
 * The Line Control Register (LCR) is an 8-bit register used to control the 
 * serial communication protocol. The LCR is used to select the data word length, 
 * the number of stop bits, and the parity mode.
 * 
 * LCR[1:0] - Data Word Length (DWL):
 * 00 - 5 bits
 * 01 - 6 bits
 * 10 - 7 bits
 * 11 - 8 bits (default)
 * 
 * LCR[2] - Number of Stop Bits (STB):
 * 0 - 1 stop bit (default)
 * 1 - 2 stop bits
 * 
 * LCR[3] - Parity Enable (PE):
 * 0 - Parity disabled (default)
 * 1 - Parity enabled
 * 
 * LCR[4] - Parity Type (PT):
 * 0 - Odd parity (default)
 * 1 - Even parity
 * 
 * LCR[5] - Set Parity (SP):
 * 0 - Normal parity (default)
 * 1 - Stick parity
 * 
 * LCR[6] - Break Control (BC):
 * 0 - Normal operation (default)
 * 1 - Send break signal
 * 
 * LCR[7] - Divisor Latch Access Bit (DLAB):
 * 0 - Normal operation (default)
 * 1 - Access DLL and DLM
 *
 * Default value for LCR (Line Control Register):
 * 0x03 -> 8 bits of data, 1 stop bit, no parity
 */

localparam LCR_DEFAULT = 8'h03;

reg [7:0] LCR = LCR_DEFAULT;
// -------------

// ---- FCR ----
wire fcr_write_data;
wire fcr_wr_en;
wire FIFOEN;
wire RXCLR;
wire TXCLR;
wire DMAMODE;
wire [1:0] RXFIFTL;

fifo_control_register fifo_control_inst (
    .CLK(CLK), 
    .RST(RST), 
    .fcr_write_data(fcr_write_data), 
    .fcr_wr_en(fcr_wr_en), 
    .FIFOEN(FIFOEN), 
    .RXCLR(RXCLR), 
    .TXCLR(TXCLR), 
    .DMAMODE(DMAMODE), 
    .RXFIFTL(RXFIFTL)
);
// -------------

// ---- TTC ----
reg signal_start = 0;
wire signal_load;
wire signal_shift;
wire signal_busy;

wire [1:0] wsl;
wire stb;
wire [2:0] parity;
wire bc;

transmitter_timing_control transmitter_timing_control (
    .BCLK(BCLK),
    .RST(RST),
    .tx_start(signal_start),
    .thr_empty(thr_empty),
    .tsr_busy(signal_busy),
    .LCR(LCR),
    .wsl(wsl),
    .load_data(signal_load),
    .shift_tsr(signal_shift)
);
// -------------

// ---- THR ----
wire thr_write;
wire th_empty;
wire [7:0] th_data_in;
wire [7:0] th_data_out;

assign th_data_in = data_in;

transmitter_holding_register transmitter_holding_register(
    .CLK(BCLK),
    .RST(RST),
    .FIFOEN(FIFOEN),
    .thr_data_in(th_data_in),
    .thr_write(thr_write),
    .tsr_ready(tsr_ready),
    .th_data_out(th_data_out),
    .th_empty(th_empty)
);
// -------------

// ---- Transmitter FIFO ----
localparam FIFO_DEPTH = 16;
localparam DATA_WIDTH = 8;

wire [DATA_WIDTH-1:0] tx_fifo_data_in;
wire fifo_wr_en;
wire [DATA_WIDTH-1:0] tx_fifo_data_out;
wire tx_fifo_full;
wire tx_fifo_empty;

assign tx_fifo_data_in = data_in;

fifo
#(
    .FIFO_DEPTH(16),
    .DATA_WIDTH(8)
) 
transmitter_fifo (
    .CLK(CLK),
    .RST(RST),
    .FIFOEN(FIFOEN),
    .RXCLR(RXCLR),
    .TXCLR(TXCLR),
    .DMAMODE(DMAMODE),
    .RXFIFTL(RXFIFTL),
    .fifo_data_in(tx_fifo_data_in),
    .fifo_wr_en(fifo_wr_en),
    .fifo_data_out(tx_fifo_data_out),
    .fifo_full(tx_fifo_full),
    .fifo_empty(tx_fifo_empty)
);
// --------------------------

// ---- TSR ----
wire tsr_ready;
wire [DATA_WIDTH-1:0] tsr;

assign tsr = (FIFOEN) ? tx_fifo_data_out : th_data_out;

transmitter_shift_register transmitter_shift_register_inst (
    .BCLK(BCLK),
    .RST(RST),
    .ts_load(signal_load),
    .ts_shift(signal_shift),
    .data_in(data_out),
    .TX_OUT(TX_OUT),
    .tsr_busy(signal_busy)
);
// -------------

endmodule
