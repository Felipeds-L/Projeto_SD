module tb_PCBranch;

    // Sinais
    reg [31:0] PCplus4;
    reg [31:0] shifted;
    wire [31:0] pcbranch;

    // Instância do módulo
    PCBranch uut (
        .PCplus4(PCplus4),
        .shifted(shifted),
        .pcbranch(pcbranch)
    );

    // Estímulos
    initial begin
        // Teste 1: PCplus4 = 4, deslocamento = 4
        PCplus4 = 32'h00000004;
        shifted = 32'h00000004; // Esperado: 8
        #10;

        // Teste 2: PCplus4 = 0x00000008, deslocamento = 0x0000000C
        PCplus4 = 32'h00000008;
        shifted = 32'h0000000C; // Esperado: 0x00000014
        #10;

        // Teste 3: PCplus4 = 0x00000020, deslocamento = 0xFFFFFFF0 (-16)
        PCplus4 = 32'h00000020;
        shifted = 32'hFFFFFFF0; // Esperado: 0x00000010
        #10;

        $finish;
    end

    // Monitor
    initial begin
        $monitor("Tempo = %0t, PCplus4 = 0x%h, shifted = 0x%h, pcbranch = 0x%h",
                  $time, PCplus4, shifted, pcbranch);
    end

endmodule
