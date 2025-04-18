`timescale 1ns/1ps

module control_unit_tb;

    // Entradas
    reg [5:0] Op;
    reg [5:0] Funct;

    // Saídas
    wire RegDst;
    wire ALUSrc;
    wire MemtoReg;
    wire RegWrite;
    wire MemWrite;
    wire Branch;
    wire [2:0] ALUControl;

    // Instancia o módulo de controle
    control_unit uut (
        .Op(Op),
        .Funct(Funct),
        .RegDst(RegDst),
        .ALUSrc(ALUSrc),
        .MemtoReg(MemtoReg),
        .RegWrite(RegWrite),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .ALUControl(ALUControl)
    );

    // Testes
    initial begin
        $display("Tempo | Op       | Funct    || RegDst ALUSrc MemtoReg RegWrite MemWrite Branch ALUControl");
        $display("------------------------------------------------------------------------------------------");

        // Instrução tipo R: add
        Op = 6'b000000; Funct = 6'b100000; #10;
        $display("%4dns | %b | %b ||   %b      %b       %b        %b        %b        %b      %b",
                 $time, Op, Funct, RegDst, ALUSrc, MemtoReg, RegWrite, MemWrite, Branch, ALUControl);

        // Instrução tipo R: sub
        Funct = 6'b100010; #10;
        $display("%4dns | %b | %b ||   %b      %b       %b        %b        %b        %b      %b",
                 $time, Op, Funct, RegDst, ALUSrc, MemtoReg, RegWrite, MemWrite, Branch, ALUControl);

        // Instrução lw
        Op = 6'b100011; Funct = 6'bxxxxxx; #10;
        $display("%4dns | %b | %b ||   %b      %b       %b        %b        %b        %b      %b",
                 $time, Op, Funct, RegDst, ALUSrc, MemtoReg, RegWrite, MemWrite, Branch, ALUControl);

        // Instrução sw
        Op = 6'b101011; #10;
        $display("%4dns | %b | %b ||   %b      %b       %b        %b        %b        %b      %b",
                 $time, Op, Funct, RegDst, ALUSrc, MemtoReg, RegWrite, MemWrite, Branch, ALUControl);

        // Instrução beq
        Op = 6'b000100; #10;
        $display("%4dns | %b | %b ||   %b      %b       %b        %b        %b        %b      %b",
                 $time, Op, Funct, RegDst, ALUSrc, MemtoReg, RegWrite, MemWrite, Branch, ALUControl);

        // Instrução inválida
        Op = 6'b111111; #10;
        $display("%4dns | %b | %b ||   %b      %b       %b        %b        %b        %b      %b",
                 $time, Op, Funct, RegDst, ALUSrc, MemtoReg, RegWrite, MemWrite, Branch, ALUControl);

        $finish;
    end

endmodule



// Resultado do Teste 
warning: Some design elements have no explicit time unit and/or
       : time precision. This may cause confusing timing results.
       : Affected design elements are:
       :   -- module control_unit declared here: design.sv:1
Tempo | Op       | Funct    || RegDst ALUSrc MemtoReg RegWrite MemWrite Branch ALUControl
------------------------------------------------------------------------------------------
  10ns | 000000 | 100000 ||   1      0       0        1        0        0      010
  20ns | 000000 | 100010 ||   1      0       0        1        0        0      110
  30ns | 100011 | xxxxxx ||   0      1       1        1        0        0      010
  40ns | 101011 | xxxxxx ||   0      1       0        0        1        0      010
  50ns | 000100 | xxxxxx ||   0      0       0        0        0        1      110
  60ns | 111111 | xxxxxx ||   0      0       0        0        0        0      xxx
testbench.sv:66: $finish called at 60000 (1ps)