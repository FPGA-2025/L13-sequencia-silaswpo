module Sequencia (
    input wire clk,
    input wire rst_n,

    input wire setar_palavra,
    input wire [7:0] palavra,

    input wire start,
    input wire bit_in,

    output reg encontrado
);

// Registradores internos
reg [7:0] palavra_guardada;
reg [7:0] shift_reg;
reg recebendo;  // Novo controle interno: começa a receber depois de start

always @(posedge clk) begin
    if (!rst_n) begin
        palavra_guardada <= 8'd0;
        shift_reg <= 8'd0;
        encontrado <= 1'b0;
        recebendo <= 1'b0;
    end else begin
        if (setar_palavra) begin
            palavra_guardada <= palavra;
            shift_reg <= 8'd0;
            encontrado <= 1'b0;
            recebendo <= 1'b0;
        end else begin
            if (start) begin
                recebendo <= 1'b1; // Ativa recebimento
                shift_reg <= {shift_reg[6:0], bit_in}; // já aceita bit no mesmo ciclo
                if ({shift_reg[6:0], bit_in} == palavra_guardada) begin
                    encontrado <= 1'b1;
                    recebendo <= 1'b0; // Se encontrou, para de receber
                end
            end else if (recebendo && !encontrado) begin
                shift_reg <= {shift_reg[6:0], bit_in};
                if ({shift_reg[6:0], bit_in} == palavra_guardada) begin
                    encontrado <= 1'b1;
                    recebendo <= 1'b0; // Se encontrou, para de receber
                end
            end
        end
    end
end

endmodule
