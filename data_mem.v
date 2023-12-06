module data_mem(
    input clk,rst,
    input [31:0] A,
    input [31:0] WD,
    input [1:0] RWE,
    output  [31:0] RD
);
    integer i;
    // reg  [31:0] temp_addr;
    reg [31:0] mem  [0:1023];

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            for (i=0;i<1024;i=i+1) begin
                mem[i] = 32'b0;
            end
        end
        else  begin
            if (RWE == 1)  mem[A] <= {{24{WD[7]}}, WD[7:0]}; // SB
            else if (RWE == 2)  mem[A] <= {{16{WD[15]}}, WD[15:0]}; // SH
            else if (RWE == 3)  mem[A] <= WD; // SW
            // else mem[A] <= WD;
        end
    end
    assign  RD = mem[A];
endmodule 
