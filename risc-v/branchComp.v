module branchComp (
    input [31:0] A,B,
    input brUn,
    output reg eq,lt
);
    always @(*) begin
        if (!brUn) begin
            eq = ( ($signed(A)==$signed(B)) ) ? 1:0;
            lt = ( ($signed(A)<$signed(B))) ? 1:0;
        end
        else begin
            eq = (A == B) ? 1: 0;
            lt = (A < B) ? 1 : 0;
        end
    end

endmodule