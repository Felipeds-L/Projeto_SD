module DataMemory(
    // entradas
    input clk,
    input memwrite,
    input [31:0] endereco, // == ALUresult
    input [31:0] writedata,

    // saidas
    output [31:0] readdata
);

reg [31:0] memory [0:255]; // 256 palavras de 32 bits

always @(posedge clk) begin // escreve na memoria na borda de subida do clock

    if (memwrite) begin // se memwrite for 1, escreve na memoria

        $display("No tempo: %0t, escrevendo na memória: %h, o endereço: %h", $time, writedata, endereco); // imprime pra eu acompanhar

        memory[endereco[7:0]] <= writedata; // escrevendo na memoria

    end
end

assign readdata = memory[endereco[7:0]]; // le da memoria, sempre que o endereco mudar, readdata muda tambem

endmodule
