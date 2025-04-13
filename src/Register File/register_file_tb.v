`timescale 1ns / 1ps

module RegisterFile_tb;

// define os inputs
reg clk;
reg reg_write; // sinal de controle para escrita (1 bit)
reg [4:0] read_reg1; // primeiro registrador a ser lido (rs)
reg [4:0] read_reg2; // segundo registrador a ser lido (rt)
reg [4:0] write_reg; // registrador onde será escrito (rd)
reg [31:0] write_data; // dado a ser escrito no registrador (32 bits)

// define os outputs
wire [31:0] read_data1; // primeiro registrador lido (32 bits)
wire [31:0] read_data2; // segundo registrador lido (32 bits)

// chama o módulo do registrador e passa os sinais de entrada e saída
RegisterFile uut (
    .clk(clk),
    .reg_write(reg_write),
    .read_reg1(read_reg1),
    .read_reg2(read_reg2),
    .write_reg(write_reg),
    .write_data(write_data),
    .read_data1(read_data1),
    .read_data2(read_data2)
);

// gerador do clock
always #5 clk = ~clk; // gera um clock com período de 10 unidades de tempo

// sequência de teste
initial begin
    // inicializa os sinais de entrada com 0
    clk = 0;
    reg_write = 0;
    read_reg1 = 0;
    read_reg2 = 0;
    write_reg = 0;
    write_data = 0;

    // monitor para verificar o funcionamento do registrador
    $monitor("Tempo: %t | Reg1: %d -> Dado1: %h | Reg2: %d -> Dado2: %h",
             $time, read_reg1, read_data1, read_reg2, read_data2);

    // escreve no registrador 5
    #10;
    write_reg = 5; // define o registrador de destino como 5
    write_data = 32'hABCD1234; // escreve o valor ABCD1234
    reg_write = 1; // habilita a escrita
    #10;
    reg_write = 0; // desabilita a escrita

    // lê do registrador 5 e 0
    #10;
    read_reg1 = 5; // define o primeiro registrador de leitura como 5
    read_reg2 = 0; // define o segundo registrador de leitura como 0 ($zero)

    // escreve no registrador 10
    #10;
    write_reg = 10; // define o registrador de destino como 10
    write_data = 32'h12345678; // escreve o valor 12345678
    reg_write = 1;
    #10;
    reg_write = 0;

    // ler do registrador 10 e 5
    #10;
    read_reg1 = 10; // lê do registrador 10
    read_reg2 = 5; // lê do registrador 5

    // sobrescreve o registrador 5 com outro valor
    #10;
    write_reg = 5; 
    write_data = 32'h87654321; // novo valor para o registrador 5
    reg_write = 1;
    #10;
    reg_write = 0;

    // ler do registrador 5 e 10 novamente
    #10;
    read_reg1 = 5; 
    read_reg2 = 10; 

    $finish; // finaliza a simulação
end

endmodule