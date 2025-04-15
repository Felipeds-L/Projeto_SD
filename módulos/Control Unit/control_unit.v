module control_unit (
    input  [5:0] Op,           
    input  [5:0] Funct,        
    output reg RegDst,         
    output reg ALUSrc,         
    output reg MemtoReg,       
    output reg RegWrite,       
    output reg MemWrite,       
    output reg Branch,         
    output reg [2:0] ALUControl 
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
                    6'b011000: ALUControl = 3'b011; // mul
    				6'b011010: ALUControl = 3'b101; // div
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