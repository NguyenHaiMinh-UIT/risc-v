module pc_adder(
    input [31:0] pc1,
    input [31:0] pc2,
    output reg [31:0] pc_out
);
    always @(*) begin
        assign pc_out = pc1 + pc2;
    end
    
    
    
endmodule