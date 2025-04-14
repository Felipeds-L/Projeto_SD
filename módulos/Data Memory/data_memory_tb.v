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

    // testes
    initial begin
        // inicia tudo em 0
        clk = 0; 
        memwrite = 0;
        endereco = 0;
        writedata = 0;

        // teste 1: escrita na memoria
        #10; // espera 10 unidades de tempo
        memwrite = 1; // ativa escrita
        endereco = 32'h00000004; // endereco 4
        writedata = 32'hDEADBEEF; // dado a ser escrito

        
        #10; // espera 10 unidades de tempo
        memwrite = 0; // desativa escrita

        // teste 2: leitura da memoria
        #10; // espera 10 unidades de tempo
        endereco = 32'h00000004; // endereco 4

        #10; // espera 10 unidades de tempo entre um e outro

        // teste 3: escrita em outro endereco
        memwrite = 1; // ativa escrita
        endereco = 32'h00000008; // endereco 8
        writedata = 32'hCAFEBABE; // dado a ser escrito

        #10; // espera 10 unidades de tempo
        memwrite = 0; // desativa escrita

        // teste 4: leitura do endereco 8
        #10; // espera 10 unidades de tempo
        endereco = 32'h00000008; // endereco 8
        
        #10; // espera 10 unidades de tempo

        #100;
        $finish; // finaliza a simulacao
    end

    // monitor para acompanhar os dados
    initial begin
        $monitor("Tempo: %t | clk: %b | memwrite: %b | endereco: %h | writedata: %h | readdata: %h",
                 $time, clk, memwrite, endereco, writedata, readdata);
    end
endmodule