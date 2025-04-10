`timescale 1ns / 1ps

module ULA_tb;


reg [31:0] entrada_01;
reg [31:0] entrada_02;
reg [2:0] ULA_cpntrol;


wire [31:0] ULA_result;
wire Zero;

ULA uut (
    .entrada_01(entrada_01),
    .entrada_02(entrada_02),
    .ULA_cpntrol(ULA_cpntrol),
    .ULA_result(ULA_result),
    .Zero(Zero)
);

initial begin
    
    entrada_01 = 0;
    entrada_02 = 0;
    ULA_cpntrol = 0;

    #10;
    entrada_01 = 32'hA5A5A5A5;
    entrada_02 = 32'h5A5A5A5A;
    ULA_cpntrol = 3'b000;
    #10;

    ULA_cpntrol = 3'b001;
    #10;

    entrada_01 = 32'h0000000F;
    entrada_02 = 32'h00000001;
    ULA_cpntrol = 3'b010;
    #10;

    entrada_01 = 32'h0000000F;
    entrada_02 = 32'h0000000F;
    ULA_cpntrol = 3'b110;
    #10;

    entrada_01 = 32'h0000000A;
    entrada_02 = 32'h0000000F;
    ULA_cpntrol = 3'b111;
    #10;

    entrada_01 = 32'hA5A5A5A5;
    entrada_02 = 32'h5A5A5A5A;
    ULA_cpntrol = 3'b100;
    #10;

    ULA_cpntrol = 3'b011;
    #10;

    $finish;
end

endmodule