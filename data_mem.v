module data_mem(
    input clk,rst,
    input [31:0] A,
    input [31:0] WD,
    input [1:0] RWE,
    // input [3:0] sup_bit,
    output  [31:0] RD
);
    integer i;
    // reg  [31:0] temp_addr;
    reg [31:0] mem  [0:63];

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            for (i=0;i<64;i=i+1) begin
                mem[i] = 32'b0;
            end
            // mem[20] = 15;
            // mem[16] = 65340;
            // mem[24] = 243;
            // mem[28] = 167722668;
        end
        else  begin
            //  0 : mem[A] <= WD ; 
            if (RWE == 1)  mem[A] <= {{24{WD[7]}}, WD[7:0]}; // SB
            else if (RWE == 2)  mem[A] <= {{16{WD[7]}}, WD[7:0]}; // SH
            else if (RWE == 3)  mem[A] <= WD; // SW
            // else mem[A] <= WD;
        end
    end
    assign  RD = mem[A];
endmodule 
