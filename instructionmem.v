module instructionmem(
    input [31:0] address, // pc
    input [31:0]  instr_in,
    output  [31:0] RD
);
    reg [31:0] A [0:1023];
    assign  RD = A[address>>2]  ;
    always @(*) begin
            A[address>>2] = instr_in;
    end   
    //        $readmemh ("hex_file.mem", A);
endmodule 
