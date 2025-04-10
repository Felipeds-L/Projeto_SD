`timescale 1ns / 1ps

module ULA_tb;

// Inputs
reg [31:0] entrada_01;
reg [31:0] entrada_02;
reg [2:0] ULA_cpntrol;

// Outputs
wire [31:0] ULA_result;
wire Zero;

// Instantiate the Unit Under Test (UUT)
ULA uut (
    .entrada_01(entrada_01),
    .entrada_02(entrada_02),
    .ULA_cpntrol(ULA_cpntrol),
    .ULA_result(ULA_result),
    .Zero(Zero)
);

initial begin
    // Initialize Inputs
    entrada_01 = 0;
    entrada_02 = 0;
    ULA_cpntrol = 0;

    // Test AND operation
    #10;
    entrada_01 = 32'hA5A5A5A5;
    entrada_02 = 32'h5A5A5A5A;
    ULA_cpntrol = 3'b000;
    #10;

    // Test OR operation
    ULA_cpntrol = 3'b001;
    #10;

    // Test ADD operation
    entrada_01 = 32'h0000000F;
    entrada_02 = 32'h00000001;
    ULA_cpntrol = 3'b010;
    #10;

    // Test SUB operation
    entrada_01 = 32'h0000000F;
    entrada_02 = 32'h0000000F;
    ULA_cpntrol = 3'b110;
    #10;

    // Test SLT operation
    entrada_01 = 32'h0000000A;
    entrada_02 = 32'h0000000F;
    ULA_cpntrol = 3'b111;
    #10;

    // Test NOR operation
    entrada_01 = 32'hA5A5A5A5;
    entrada_02 = 32'h5A5A5A5A;
    ULA_cpntrol = 3'b100;
    #10;

    // Test undefined operation (Default case)
    ULA_cpntrol = 3'b011; // Not defined in the ULA
    #10;

    $finish;
end

endmodule