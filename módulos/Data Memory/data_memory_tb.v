module DataMemory_tb;

    // inputs
    reg clk;
    reg memwrite;
    reg [31:0] endereco; // == ALUresult
    reg [31:0] writedata;

    // outputs
    wire [31:0] readdata;

    // instanciando o modulo data memory
    DataMemory uut (
        .clk(clk),
        .memwrite(memwrite),
        .endereco(endereco),
        .writedata(writedata),
        .readdata(readdata)
    );

    // geração do clock
    initial begin
        clk = 0; // inicia o clock em 0
    end

    always #5 clk = ~clk; // alterna o clock a cada 5 unidades de tempo

    // testes
    initial begin
        // inicia tudo em 0
        memwrite = 0;
        endereco = 0;
        writedata = 0;

        // teste 1: escrita na memoria
        #10; // espera 10 unidades de tempo
        $display("Teste 1: Escrevendo no endereço 0x00000004 o valor 0xDEADBEEF");
        memwrite = 1; // ativa escrita
        endereco = 32'h00000004; // endereco 4
        writedata = 32'hDEADBEEF; // dado a ser escrito

        #10; // espera 10 unidades de tempo
        memwrite = 0; // desativa escrita

        // teste 2: leitura da memoria
        #10; // espera 10 unidades de tempo
        $display("Teste 2: Lendo do endereço 0x00000004");
        endereco = 32'h00000004; // endereco 4

        #10; // espera 10 unidades de tempo entre um e outro

        // teste 3: escrita em outro endereco
        $display("Teste 3: Escrevendo no endereço 0x00000008 o valor 0xCAFEBABE");
        memwrite = 1; // ativa escrita
        endereco = 32'h00000008; // endereco 8
        writedata = 32'hCAFEBABE; // dado a ser escrito

        #10; // espera 10 unidades de tempo
        memwrite = 0; // desativa escrita

        // teste 4: leitura do endereco 8
        #10; // espera 10 unidades de tempo
        $display("Teste 4: Lendo do endereço 0x00000008");
        endereco = 32'h00000008; // endereco 8

        #10;
        $finish; // finaliza a simulacao
    end

    // monitor para acompanhar os dados
    initial begin
        $monitor("Tempo: %t | clk: %b | memwrite: %b | endereco: %h | writedata: %h | readdata: %h",
                 $time, clk, memwrite, endereco, writedata, readdata);
    end
endmodule