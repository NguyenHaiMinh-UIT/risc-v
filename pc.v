module pc (
    input [31:0] pc_next,
    input clk,rst,
    output reg [31:0] pc
);
    // reg [31:0] pc;
    // assign pc_next = 32'b0;
always @(posedge clk ) begin
    if (!rst) pc <= 32'b0;
    else 
    pc <= pc_next;    
end
endmodule  