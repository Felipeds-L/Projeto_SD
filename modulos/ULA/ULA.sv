timescale 1ns / 1ps

// Inicia o módulo da Unidade Lógica Aritmética
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