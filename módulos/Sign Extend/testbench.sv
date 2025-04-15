module tb_SignExtend;

    // Sinais de entrada/saída
    reg [15:0] Instr;
    wire [31:0] Signlmm;

    // Instância do módulo
    SignExtend uut (
        .Instr(Instr),
        .Signlmm(Signlmm)
    );

    // Estímulos
    initial begin
        // Caso 1: valor positivo
        Instr = 16'h0004; // Deve extender para 0x00000004
        #10;
        // Caso 2: valor negativo (-1)
        Instr = 16'hFFFF; // Deve extender para 0xFFFFFFFF
        #10;
        // Caso 3: valor negativo (-32768)
        Instr = 16'h8000; // Deve extender para 0xFFFF8000
        #10;
        // Caso 4: valor positivo (0x7FFF)
        Instr = 16'h7FFF; // Deve extender para 0x00007FFF
        #10;

        $finish;
    end

    // Monitorar sinais
    initial begin
        $monitor("Tempo = %0t, Instr = 0x%h, Signlmm = 0x%h", $time, Instr, Signlmm);
    end

endmodule
