module tb_PCPlus4;

    // Sinais
    reg [31:0] PC;
    wire [31:0] PCplus4;

    // Instância do módulo
    PCPlus4 uut (
        .PC(PC),
        .PCplus4(PCplus4)
    );

    // Estímulos
    initial begin
        // Teste 1: PC = 0
        PC = 32'h00000000; // Esperado: 0x00000004
        #10;
        // Teste 2: PC = 4
        PC = 32'h00000004; // Esperado: 0x00000008
        #10;
        // Teste 3: PC = 0x00000020
        PC = 32'h00000020; // Esperado: 0x00000024
        #10;

        $finish;
    end

    // Monitoramento
    initial begin
        $monitor("Tempo = %0t, PC = 0x%h, PCplus4 = 0x%h", $time, PC, PCplus4);
    end

endmodule
