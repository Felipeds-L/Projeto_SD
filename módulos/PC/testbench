module tb_ProgramCounter;

    // Sinais de entrada/saída
    reg clk;
    reg [31:0] PCNext;
    wire [31:0] PC;
    
    // Instância do módulo
    ProgramCounter uut (
        .clk(clk),
        .PCNext(PCNext),
        .PC(PC)
    );
    
    // Gerador de clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Clock de 10 unidades de tempo
    end
    
    // Estímulos para o módulo
    initial begin
        // Inicialização dos sinais
        PCNext = 0;
        #10;
        PCNext = 32'h00000004;
        #10;
        PCNext = 32'h00000008;
        #10;

        $finish;
    end
    
    // Monitorar sinais
    initial begin
      $monitor("Tempo = %0t, clk = %b, PCNext = %h, PC = %h", $time, clk, PCNext,PC);
    end

endmodule
