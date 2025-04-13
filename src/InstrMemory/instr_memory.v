module InstrMemory(
    input [31:0] endereco, // endereco de 32 bits
    output reg [31:0] instrucao // instrucao de 32 bits
);

    // define aqui: 32 instrucoes de 32 bits
    reg [31:0] memoria [0:31]; // memoria de 32 instrucoes de 32 bits

    // inicia a memoria com as instrucoes
    initial begin 
        $readmemh("instrucao.txt", memoria); // le o arquivo instrucao.txt e armazena na memoria
    end

    // atribui a instrucao ao endereco da memoria
    always @(*) begin
        instrucao = memoria[endereco[31:2]]; // pega o endereco e divide por 4 (desloca 2 bits pra direita) para pegar o endereco correto da memoria
    end

endmodule

// arquivo instrucao.txt
// 20080005   → addi $t0, $zero, 5
// 20090003   → addi $t1, $zero, 3
// 01095020   → add  $t2, $t0, $t1
// 012A5822   → sub  $t3, $t1, $t2
// AC0B0004   → sw   $t3, 4($zero)