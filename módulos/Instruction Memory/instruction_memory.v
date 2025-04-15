module instruction_memory(
    input [31:0] address,
    output reg [31:0] instruction
);

    reg [31:0] mem [0:1023];

    initial begin
        // Carregando instrução em Assembly para rodar no MIPS
        mem[0] = 32'h2001000A; // addi $1, $0, 10
        mem[1] = 32'h2002000B; // addi $2, $0, 11
        mem[2] = 32'h00221820; // add  $3, $1, $2
        mem[3] = 32'hAC030000; // sw   $3, 0($s0)

        // Preenche o restante com nops
        for (integer i = 6; i < 1024; i = i + 1)
            mem[i] = 32'h00000000;
    end

    always @(*) begin
        instruction = mem[address[11:2]];
    end
endmodule
