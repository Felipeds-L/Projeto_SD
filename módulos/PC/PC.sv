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
