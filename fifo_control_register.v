module fifo_control_register
(
    input wire CLK,
    input wire RST,
    input wire [7:0] fcr_write_data,  // Dados de entrada para escrever no FCR
    input wire fcr_wr_en,      // Sinal de habilitação de escrita no FCR
    output reg FIFOEN,       // Habilita o FIFO (FIFOEN)
    output reg RXCLR,     // Sinal para limpar o Receiver FIFO
    output reg TXCLR,     // Sinal para limpar o Transmitter FIFO
    output reg DMAMODE,
    output reg [1:0] RXFIFTL // Configuração do nível de disparo do Receiver FIFO
);

// Valor inicial do FCR
localparam FCR_DEFAULT = 8'b00000000;

initial begin
    FIFOEN = 1'b1;
    RXCLR = 1'b0;
    TXCLR = 1'b0;
    DMAMODE = 1'b0;
    RXFIFTL = 2'b01;
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        // Inicializa os valores padrão
        FIFOEN <= 1'b0;
        RXCLR <= 1'b0;
        TXCLR <= 1'b0;
        DMAMODE <= 1'b0;
        RXFIFTL <= 2'b00; // Trigger Level padrão: 1 byte
    end else if (fcr_wr_en) begin
        // Atualiza os valores com base no fcr_write_data
        FIFOEN <= fcr_write_data[0];       // FIFO Enable
        RXCLR <= fcr_write_data[1];    // RX FIFO Reset
        TXCLR <= fcr_write_data[2];    // TX FIFO Reset
        DMAMODE <= fcr_write_data[3];         // DMA Mode
        RXFIFTL <= fcr_write_data[5:4]; // RX Trigger Level
    end else begin
        RXCLR <= 1'b0;
        TXCLR <= 1'b0;
    end
end

endmodule
