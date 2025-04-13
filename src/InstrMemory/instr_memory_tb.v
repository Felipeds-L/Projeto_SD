module InstrMemory_tb;
    // entradas
    reg [31:0] endereco; // endereco de 32 bits

    // saidas
    wire [31:0] instrucao; // instrucao de 32 bits

    // instancia o modulo InstrMemory
    InstrMemory uut ( 
        .endereco(endereco), // conecta a entrada endereco
        .instrucao(instrucao) // conecta a saida instrucao
    );

    initial begin // bloco inicial
        
        endereco = 0; // inicializa o endereco com 0

        #10; // espera 10 unidades de tempo

        endereco = 4; // altera o endereco para 4

        #10; // espera 10 unidades de tempo

        endereco = 8; // altera o endereco para 8

        #10; // espera 10 unidades de tempo

        endereco = 12; // altera o endereco para 12

        #10; // espera 10 unidades de tempo

        endereco = 16; // altera o endereco para 16

        #10; // espera 10 unidades de tempo

        $finish; // finaliza a simulacao

    end

    // monitor para verificar o funcionamento do InstrMemory
    initial begin
        $monitor("Tempo: %t | Endereco: %h -> Instrucao: %h",
                 $time, endereco, instrucao); // imprime o tempo, endereco e instrucao
    end

endmodule

// intrucoes para rodar o tb no terminal, digite:
// cd "<caminho do projeto>\src\InstrMemory"
// iverilog -o instr_memory_tb instr_memory_tb.v instr_memory.v
// vvp instr_memory_tb