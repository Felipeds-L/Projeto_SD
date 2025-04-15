module SignExtend(
    input [15:0] Instr,
    output reg [31:0] Signlmm
);

always @(*) begin
    Signlmm = {{16{Instr[15]}}, Instr};
end

endmodule
