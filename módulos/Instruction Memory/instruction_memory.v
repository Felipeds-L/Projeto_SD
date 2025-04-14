module instruction_memory(
    input [31:0] address,        // Endereço de 32 bits (byte address)
    output reg [31:0] instruction // Instrução de 32 bits lida
);

    // Memória principal: 1024 palavras de 32 bits (4KB)
    reg [31:0] mem [0:1023];     // Índice de 10 bits (0-1023)

    // Inicialização da memória com instruções de exemplo
    initial begin
        // Formato das instruções em hexadecimal
        mem[0] = 32'h8C010000;   // lw $1, 0($0)
        mem[1] = 32'h8C020004;   // lw $2, 4($0)
        mem[2] = 32'h8C030008;   // lw $3, 8($0)
        mem[3] = 32'h20040064;   // addi $4, $0, 100
        mem[4] = 32'h00222802;   // mul $5, $1, $2
        mem[5] = 32'h00A43803;   // div $7, $5, $4
        mem[6] = 32'h00273822;   // sub $6, $1, $7
        mem[7] = 32'h10600002;   // beq $3, $0, 2 (offset=2)
        mem[8] = 32'h00273820;   // add $6, $1, $7
        mem[9] = 32'hAC060000;   // sw $6, 0($0)
        
        // Preenche o restante com nops (0x00000000)
        for (integer i = 10; i < 1024; i = i + 1)
            mem[i] = 32'h00000000;
    end

    // Leitura da memória (combinacional)
    always @(*) begin
        instruction = mem[address[11:2]]; // Converte byte address para word address
    end

endmodule
