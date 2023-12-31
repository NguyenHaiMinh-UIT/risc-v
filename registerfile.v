module  registerfile(
    input clk,rst,
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] WD3,
    input [2:0] WE3,
    output  [31:0] RD1,
    output  [31:0] RD2
);

    reg [31:0] mem [0:1023];
    integer i;
    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            for (i=0;i<1024;i=i+1) begin
                mem[i] <= 0;
            end
        end
        else begin
            if (WE3 == 1) mem[A3] <= WD3; // normal + LW
            else if (WE3 == 2) // LB
                mem[A3] <= {{24{WD3[7]}}, WD3[7:0]};
            else if (WE3 == 3) // LH
                mem[A3] <= {{16{WD3[15]}}, WD3[15:0]};
            else if (WE3 == 4) // LBU
                mem[A3] <= {24'b0, WD3[7:0]};
            else if (WE3 == 5) // LHU
                mem[A3] <= {16'b0, WD3[15:0]};
                // else WD3 <= 32'bx;
        end
    end
    assign RD1 = mem[A1];
    assign RD2 = mem[A2];
endmodule   