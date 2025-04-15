`timescale 1ns/1ps
// 1. Memória de Instruções (primeiro estágio - busca da instrução)
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
    always @(posedge clk) begin
    if (reg_write && write_reg != 0) begin
        registradores[write_reg] <= write_data;
       $display("Escrevendo no registrador %d: %h", write_reg, write_data);
    end
end
endmodule

// 6. Extensão de sinal
module SignExtend(
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
        3'b000: ULA_result = entrada_01 & entrada_02;       // AND
        3'b001: ULA_result = entrada_01 | entrada_02;       // OR
        3'b010: ULA_result = entrada_01 + entrada_02;       // ADD
        3'b011: ULA_result = entrada_01 * entrada_02;       // MUL
        3'b100: ULA_result = ~(entrada_01 | entrada_02);    // NOR
        3'b101: ULA_result = entrada_01 / entrada_02;       // DIV
        3'b110: ULA_result = entrada_01 - entrada_02;       // SUB
        3'b111: ULA_result = (entrada_01 < entrada_02) ? 32'b1 : 32'b0; // SLT
        default: ULA_result = 32'b0;
    endcase
   
end

assign Zero = (ULA_result == 0);
endmodule

// 8. Memória de Dados (último estágio)
module DataMemory(
    // entradas/saídas
    input clk,
    input memwrite,
    input [31:0] endereco, // == ALUresult
    input [31:0] writedata,
    output [31:0] readdata
);

reg [31:0] memory [0:255]; // 256 palavras de 32 bits

always @(posedge clk) begin // escreve na memoria na borda de subida do clock
    if (memwrite) begin // se memwrite for 1, escreve na memoria
      $display("No tempo: %0t, escrevendo na memória: %h, o endereço: %h", $time, writedata, endereco); // imprime pra eu acompanhar
        memory[endereco[7:0]] <= writedata; // escrevendo na memoria
    end
end

assign readdata = memory[endereco[7:0]];
endmodule
// 9. Unidade de Controle
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

    // Inicializa os sinais com valores padrão (evita latch)
    always @(*) begin
        RegDst    = 0;         
        ALUSrc    = 0;         
        MemtoReg  = 0;         
        RegWrite  = 0;         
        MemWrite  = 0;         
        Branch    = 0;         
        ALUControl = 3'b000;   

        // Decodifica o campo Op para determinar o tipo da instrução
        case (Op)
            6'b000000: begin  // Instruções tipo R (Op = 0)
                RegDst    = 1;         
                RegWrite  = 1;         
                case (Funct)           
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
          	6'b001000: begin // addi
   				ALUSrc    = 1;
    			RegWrite  = 1;
   			    ALUControl = 3'b010; // ADD
			end

            6'b100011: begin // lw (load word)
                ALUSrc    = 1;         
                MemtoReg  = 1;         
                RegWrite  = 1;         
                ALUControl = 3'b010;   
            end

            6'b101011: begin // sw (store word)
                ALUSrc    = 1;         
                MemWrite  = 1;         
                ALUControl = 3'b010;   
            end

            6'b000100: begin // beq (branch if equal)
                Branch    = 1;         
                ALUControl = 3'b110;   
            end

            default: begin
                ALUControl = 3'bxxx;   // Instrução inválida ou não implementada
            end
        endcase
    end

endmodule

module Mux_RegDst(
    input [4:0] rt,
    input [4:0] rd,
    input RegDst,
    output [4:0] write_reg
);

assign write_reg = (RegDst) ? rd : rt;

endmodule

module Mux_ALUSrc(
    input [31:0] reg_data2,
    input [31:0] sign_extended,
    input ALUSrc,
    output [31:0] ALU_inputB
);

assign ALU_inputB = (ALUSrc) ? sign_extended : reg_data2;

endmodule

module Mux_MemtoReg(
    input [31:0] ALU_result,
    input [31:0] mem_data,
    input MemtoReg,
    output [31:0] write_data
);

assign write_data = (MemtoReg) ? mem_data : ALU_result;

endmodule

module Mux_PCSource(
    input [31:0] PCplus4,
    input [31:0] PCbranch,
    input PCSrc, // PCSrc = Branch & Zero: seleciona PCBranch quando for fazer salto
    output [31:0] PCNext
);

assign PCNext = (PCSrc) ? PCbranch : PCplus4;

endmodule

module ShiftLeft(
    input [31:0] Signlmm,
    output [31:0] out
);

assign out = Signlmm << 2;

endmodule

module MIPSCicloUnico(input clk);

    // -------------------------------
    // Fios principais
    // -------------------------------
    wire [31:0] PC, PCplus4, PCbranch, PCNext;
    wire [31:0] instruction;
    wire [4:0] rs, rt, rd, write_reg;
    wire [31:0] read_data1, read_data2, write_data;
    wire [31:0] sign_ext, shift_left_out;
    wire [31:0] ALU_inputB, ALU_result, mem_data;
    wire [5:0] opcode, funct;
    wire Zero;

    // -------------------------------
    // Sinais de controle
    // -------------------------------
    wire RegDst, ALUSrc, MemtoReg, RegWrite, MemWrite, Branch;
    wire [2:0] ALUControl;
    wire PCSrc;

    // -------------------------------
    // 1. Program Counter
    // -------------------------------
    ProgramCounter PC_reg(
        .clk(clk),
        .PCNext(PCNext),
        .PC(PC)
    );

    // -------------------------------
    // 2. Memória de Instruções
    // -------------------------------
    instruction_memory imem(
        .address(PC),
        .instruction(instruction)
    );

    // -------------------------------
    // 3. Unidade de Controle
    // -------------------------------
    assign opcode = instruction[31:26];
    assign funct  = instruction[5:0];

    control_unit ctrl(
        .Op(opcode),
        .Funct(funct),
        .RegDst(RegDst),
        .ALUSrc(ALUSrc),
        .MemtoReg(MemtoReg),
        .RegWrite(RegWrite),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .ALUControl(ALUControl)
    );

    // -------------------------------
    // 4. Decodificação de registradores
    // -------------------------------
    assign rs = instruction[25:21];
    assign rt = instruction[20:16];
    assign rd = instruction[15:11];

    // Banco de registradores
    RegisterFile regfile(
        .clk(clk),
        .reg_write(RegWrite),
        .read_reg1(rs),
        .read_reg2(rt),
        .write_reg(write_reg),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // -------------------------------
    // 5. Extensão de sinal
    // -------------------------------
    SignExtend sext(
        .Instr(instruction[15:0]),
        .Signlmm(sign_ext)
    );

    // -------------------------------
    // 6. Shift Left 2 (para branch)
    // -------------------------------
    ShiftLeft shift(
        .Signlmm(sign_ext),
        .out(shift_left_out)
    );

    // -------------------------------
    // 7. PC + 4
    // -------------------------------
    PCPlus4 plus4(
        .PC(PC),
        .PCplus4(PCplus4)
    );

    // -------------------------------
    // 8. PC Branch (PC+4 + offset)
    // -------------------------------
    PCBranch pc_br(
        .PCplus4(PCplus4),
        .shifted(shift_left_out),
        .pcbranch(PCbranch)
    );

    // -------------------------------
    // 9. MUXes
    // -------------------------------

    // MUX1: RegDst (escolha do registrador destino)
    Mux_RegDst mux_regdst(
        .rt(rt),
        .rd(rd),
        .RegDst(RegDst),
        .write_reg(write_reg)
    );

    // MUX2: ALUSrc (escolha do operando B da ALU)
    Mux_ALUSrc mux_alusrc(
        .reg_data2(read_data2),
        .sign_extended(sign_ext),
        .ALUSrc(ALUSrc),
        .ALU_inputB(ALU_inputB)
    );

    // MUX3: MemtoReg (dado escrito no banco de registradores)
    Mux_MemtoReg mux_memtoreg(
        .ALU_result(ALU_result),
        .mem_data(mem_data),
        .MemtoReg(MemtoReg),
        .write_data(write_data)
    );

    // MUX4: Branch (escolha do próximo PC)
    assign PCSrc = Branch & Zero;

    Mux_PCSource mux_pcsrc(
        .PCplus4(PCplus4),
        .PCbranch(PCbranch),
        .PCSrc(PCSrc),
        .PCNext(PCNext)
    );

    // -------------------------------
    // 10. Unidade Lógica Aritmética (ALU)
    // -------------------------------
    ULA alu(
        .entrada_01(read_data1),
        .entrada_02(ALU_inputB),
        .ULA_control(ALUControl),
        .ULA_result(ALU_result),
        .Zero(Zero)
    );

    // -------------------------------
    // 11. Memória de Dados
    // -------------------------------
    DataMemory dmem(
        .clk(clk),
        .memwrite(MemWrite),
        .endereco(ALU_result),
        .writedata(read_data2),
        .readdata(mem_data)
    );

endmodule
