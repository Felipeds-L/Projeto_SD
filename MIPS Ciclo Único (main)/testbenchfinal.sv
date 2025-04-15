`timescale 1ns/1ps

module tb_MIPSCicloUnico;

    // Sinal de clock
    reg clk;

    // Instancia o processador
    MIPSCicloUnico uut (
        .clk(clk)
    );

    // Geração de clock: 10ns por ciclo (frequência de 100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Simulação por tempo suficiente
    initial begin
        $display("===== Iniciando simulação do programa MIPS =====");

        // Duração da simulação
        #100;
     	$display("Valor em $s1 (parcela1): %0d", uut.regfile.registradores[1]);
      	$display("Valor em $s2 (parcela2): %0d", uut.regfile.registradores[2]);
     	$display("Valor em $s3 (soma): %0d", uut.regfile.registradores[3]);
        $display("Valor em memória[0]: %0d", uut.dmem.memory[0]);

        $display("===== Fim da simulação =====");
        $finish;
    end

endmodule
