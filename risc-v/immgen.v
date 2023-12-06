module immgen (
    input [31:0] in,
    input immSel,
    output reg [31:0] imm_out
);
    wire [6:0] opcode;

    parameter I_R_type      = 7'b0010011;
    parameter LUI           = 7'b0110111;
    parameter AUIPC         = 7'b0010111;
    parameter B_type        = 7'b1100011;
    parameter I_Load_type   = 7'b0000011;
    parameter S_type        = 7'b0100011;
    parameter JAL_type      = 7'b1101111;
    parameter JALR_type     = 7'b1100111;

    assign opcode = in[6:0];
    always @(*) begin
        if (immSel) begin
            case (opcode)
                I_R_type    :  imm_out = {{20{in[31]}}, in[31:20]};
                LUI         :  imm_out = {in[31:12], 12'b0};
                AUIPC       :  imm_out = {in[31:12], 12'b0};
                B_type      :  imm_out = {{20{in[31]}}, in[7], in[30:25], in[11:8],1'b0};
                I_Load_type :  imm_out = {{20{in[31]}}, in[31:20]};
                S_type      :  imm_out = {{20{in[31]}}, in[31:25], in[11:7]};
                JAL_type    :  imm_out = {{12{in[31]}}, in[19:12], in[20], in[30:21],1'b0};
                JALR_type   :  imm_out = {{20{in[31]}}, in[31:20]};
                default: imm_out  =  32'bx;
            endcase
        end
        else   imm_out =  31'b0;
    end

endmodule
