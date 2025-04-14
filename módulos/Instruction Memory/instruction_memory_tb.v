module testbench;

    reg [31:0] address;          // Registrador para fornecer o endereço
    wire [31:0] instruction;     // Fio para receber a instrução

    // Instancia o módulo de Instruction Memory
    instruction_memory imem(address, instruction);

    // Bloco inicial para testar o módulo
    initial begin
        // Teste com endereço 0
        address = 0;
        #10;  // Aguarda 10 unidades de tempo
        $display("Instrução no endereço 0: %h", instruction);

        // Teste com endereço 4
        address = 4;
        #10;
        $display("Instrução no endereço 4: %h", instruction);

        // Teste com endereço 8
        address = 8;
        #10;
        $display("Instrução no endereço 8: %h", instruction);

        // Teste com endereço fora do intervalo inicializado (ex.: 40)
        address = 40;
        #10;
        $display("Instrução no endereço 40: %h", instruction);
    end

endmodule
