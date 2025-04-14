// 1. Memória de Instruções (primeiro estágio - busca da instrução)
module instruction_memory(
    input [31:0] address,        // Endereço de 32 bits (byte address)
    output reg [31:0] instruction // Instrução de 32 bits lida
);

    // Memória principal: 1024 palavras de 32 bits (4KB)
    reg [31:0] mem [0:1023];     // Índice de 10 bits (0-1023)

    // Inicialização da memória com instruções de exemplo
    initial begin
        // Formato das instruções em hexadecimal
        mem[0] = 32'h8C010000;   // lw $1, 0($0)
        mem[1] = 32'h8C020004;   // lw $2, 4($0)
        mem[2] = 32'h8C030008;   // lw $3, 8($0)
        mem[3] = 32'h20040064;   // addi $4, $0, 100
        mem[4] = 32'h00222802;   // mul $5, $1, $2
        mem[5] = 32'h00A43803;   // div $7, $5, $4
        mem[6] = 32'h00273822;   // sub $6, $1, $7
        mem[7] = 32'h10600002;   // beq $3, $0, 2 (offset=2)
        mem[8] = 32'h00273820;   // add $6, $1, $7
        mem[9] = 32'hAC060000;   // sw $6, 0($0)
        
        // Preenche o restante com nops (0x00000000)
        for (integer i = 10; i < 1024; i = i + 1)
            mem[i] = 32'h00000000;
    end

    // Leitura da memória (combinacional)
    always @(*) begin
        instruction = mem[address[11:2]]; // Converte byte address para word address
    end
endmodule

// 2. Program Counter (controle de fluxo)
module ProgramCounter(
    input clk,
    input [31:0] PCNext,
    output reg [31:0] PC
);

initial begin
    PC = 0;
end

always @(posedge clk) begin
    PC <= PCNext;
end
endmodule

// 3. Cálculo de PC+4
module PCPlus4(
  input [31:0] PC,
    output [31:0] PCplus4
);

assign PCplus4 = PC + 4;
endmodule

// 4. Cálculo de desvio (PC Branch)
module PCBranch(
    input [31:0] PCplus4,
    input [31:0] shifted,
    output [31:0] pcbranch
);

assign pcbranch = PCplus4 + shifted;
endmodule

// 5. Banco de Registradores
module RegisterFile(
    // entradas
    input clk,              // clock de 1 bit             
    input reg_write,            // sinal de controle para escrita (1 bit)
    input [4:0] read_reg1, read_reg2, write_reg,    // endereços de leitura (rs, rt) e escrita (rd) (5 bits cada)
    input [31:0] write_data,   // dado a ser escrito (32 bits)

    // saidas
    output [31:0] read_data1,  // primeiro registrador lido (32 bits)
    output [31:0] read_data2   // segundo registrador lido (32 bits)
);

    // define aqui: 32 registradores de 32 bits
    reg [31:0] registradores [31:0];

    // inicia todos os registradores com 0
    integer i; // define o i como um inteiro
    initial begin
        for (i = 0; i < 32; i = i + 1) begin // percorre todos os registradores e iguala 0
            registradores[i] = 0;
        end
    end

    // leitura dos registradores
    assign read_data1 = registradores[read_reg1];
    assign read_data2 = registradores[read_reg2];

    // escrita dos registradores
    always @(posedge clk) begin // sempre que ocorre uma borda de subida do clock == quando o clock muda de 0 pra 1
        if (reg_write) begin // se o sinal de escrita for 1 (1 = escrever e 0 = não escrever)
            registradores[write_reg] <= write_data; // escreve o dado no registrador
            $display("Escrevendo no registrador %d: %h", write_reg, write_data); // printa o valor do registrador e o dado escrito pra verificcao
        end
    end
endmodule

// 6. Extensão de sinal
module SignalExtend(
    input [15:0] Instr,
    output reg [31:0] Signlmm
);

always @(*) begin
    Signlmm = {{16{Instr[15]}}, Instr};
end
endmodule

// 7. Unidade Lógica Aritmética (ULA)
module ULA(
    input [31:0] entrada_01, entrada_02,
    input [2:0] ULA_control,
    output reg [31:0] ULA_result,
    output Zero
);

always @(*) begin
    case (ULA_control)
        3'b000: ULA_result = entrada_01 & entrada_02;   // AND
        3'b001: ULA_result = entrada_01 | entrada_02;   // OR
        3'b010: ULA_result = entrada_01 + entrada_02;   // ADD
        3'b110: ULA_result = entrada_01 - entrada_02;   // SUB
        3'b111: ULA_result = (entrada_01 < entrada_02) ? 32'b1 : 32'b0; // SLT
        3'b100: ULA_result = ~(entrada_01 | entrada_02); // NOR
        default: ULA_result = 32'b0;   // Default to zero
    endcase

    // Monitorando operações da ULA
    $display("At time %t, ULA_control: %b, entrada_01: %h, entrada_02: %h, ULA_result: %h, Zero: %b",
             $time, ULA_control, entrada_01, entrada_02, ULA_result, Zero);
end

assign Zero = (ULA_result == 0);
endmodule

// 8. Memória de Dados (último estágio)
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
        $display("No tempo: %t, escrevendo na memória: %h, o endereço: %h", $time, writedata, endereco); // imprime pra eu acompanhar
        memory[endereco[7:0]] <= writedata; // escrevendo na memoria
    end
end

assign readdata = memory[endereco[7:0]]; // le da memoria, sempre que o endereco mudar, readdata muda tambem
endmodule

module control_unit (
    input  [5:0] Op,           // Campo opcode da instrução (define o tipo: R, lw, sw, beq, etc)
    input  [5:0] Funct,        // Campo funct (usado apenas para instruções tipo R)
    output reg RegDst,         // Define qual campo será usado como registrador destino (rd ou rt)
    output reg ALUSrc,         // Define se a ALU usará um registrador ou um valor imediato como segundo operando
    output reg MemtoReg,       // Define se o dado a ser escrito no registrador vem da memória (lw) ou da ALU
    output reg RegWrite,       // Habilita escrita no banco de registradores
    output reg MemWrite,       // Habilita escrita na memória de dados
    output reg Branch,         // Sinal de controle usado para instrução de desvio condicional (beq)
    output reg [2:0] ALUControl // Sinal que define a operação da ALU (add, sub, and, or, etc.)
);

    always @(*) begin
        // Inicializa os sinais com valores padrão (evita latch)
        RegDst    = 0;         // Por padrão, destino é rt
        ALUSrc    = 0;         // Por padrão, segundo operando vem de registrador
        MemtoReg  = 0;         // Por padrão, resultado da ALU vai para o registrador
        RegWrite  = 0;         // Escrita desabilitada por padrão
        MemWrite  = 0;         // Escrita na memória desabilitada
        Branch    = 0;         // Sem desvio por padrão
        ALUControl = 3'b000;   // Operação padrão da ALU

        // Decodifica o campo Op para determinar o tipo da instrução
        case (Op)
            6'b000000: begin  // Instruções tipo R (Op = 0)
                RegDst    = 1;         // Usa o campo rd como destino
                RegWrite  = 1;         // Habilita escrita no registrador
                case (Funct)           // Funct determina operação exata da ALU
                    6'b100000: ALUControl = 3'b010; // add
                    6'b100010: ALUControl = 3'b110; // sub
                    6'b100100: ALUControl = 3'b000; // and
                    6'b100101: ALUControl = 3'b001; // or
                    6'b101010: ALUControl = 3'b111; // slt (set on less than)
                    6'b100111: ALUControl = 3'b100; // nor
                    default:   ALUControl = 3'bxxx; // Operação inválida
                endcase
            end

            6'b100011: begin // lw (load word)
                ALUSrc    = 1;         // Segundo operando da ALU é um imediato (offset)
                MemtoReg  = 1;         // Valor da memória será escrito no registrador
                RegWrite  = 1;         // Habilita escrita no registrador
                ALUControl = 3'b010;   // ALU faz add para calcular endereço
            end

            6'b101011: begin // sw (store word)
                ALUSrc    = 1;         // Segundo operando é imediato (offset)
                MemWrite  = 1;         // Habilita escrita na memória
                ALUControl = 3'b010;   // ALU faz add para calcular endereço
            end

            6'b000100: begin // beq (branch if equal)
                Branch    = 1;         // Ativa controle de desvio condicional
                ALUControl = 3'b110;   // ALU faz subtração para testar igualdade
            end

            default: begin
                ALUControl = 3'bxxx;   // Instrução inválida ou não implementada
            end
        endcase
    end

endmodule