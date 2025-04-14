module PCPlus4(
  input [31:0] PC,
    output [31:0] PCplus4
);

assign PCplus4 = PC + 4;

endmodule
