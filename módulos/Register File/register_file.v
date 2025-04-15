`timescale 1ps/1ps // pra não dar erro de tempo de simulação

module RegisterFile(
    // entradas
    input clk,              // clock de 1 bit             
    input reg_write,            // sinal de controle para escrita (1 bit)
    input [4:0] read_reg1, read_reg2, write_reg,    // endereços de leitura (rs, rt) e escrita (rd) (5 bits cada)
    input [31:0] write_data,   // dado a ser escrito (32 bits)

    // saidas
    output [31:0] read_data1,  // primeiro registrador lido (32 bits)
    output [31:0] read_data2   // segundo registrador lido (32 bits)
);

    // define aqui: 32 registradores de 32 bits
    reg [31:0] registradores [31:0];

    // inicia todos os registradores com 0
    integer i; // define o i como um inteiro
    initial begin
        for (i = 0; i < 32; i = i + 1) begin // percorre todos os registradores e iguala 0
            registradores[i] = 0;
        end
    end

    // leitura dos registradores
    assign read_data1 = registradores[read_reg1];
    assign read_data2 = registradores[read_reg2];

    // escrita dos registradores
    always @(posedge clk) begin // sempre que ocorre uma borda de subida do clock == quando o clock muda de 0 pra 1
        if (reg_write && write_reg != 0) begin // se o sinal de escrita for 1 (1 = escrever e 0 = não escrever)

            registradores[write_reg] <= write_data; // escreve o dado no registrador
            $display("Escrevendo no registrador %d: %h", write_reg, write_data); // printa o valor do registrador e o dado escrito pra verificcao
        end
    end

endmodule