module PCBranch(
    input [31:0] PCplus4,
    input [31:0] shifted,
    output [31:0] pcbranch
);

assign pcbranch = PCplus4 + shifted;

endmodule
