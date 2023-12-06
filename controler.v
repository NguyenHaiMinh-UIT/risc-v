module controler (
    input  [6:0] opcode,
    input  [14:12] funct3,
    input  funct7, // instruction[30]
    input  eq,lt,
    output reg pc_sel /*write = 0, read = 1*/,brUn,
    output reg [1:0] mem_write,
    output reg [3:0] alu_control ,
    output reg immSel,Asel,Bsel,
    output reg [1:0] WBsel,
    output  reg [2:0] reg_write
);

    ///========== USE FOR OPCODE ===========///
    parameter R_type        = 7'b0110011;
    parameter I_R_type      = 7'b0010011;
    parameter LUI           = 7'b0110111;
    parameter AUIPC         = 7'b0010111;
    parameter B_type        = 7'b1100011;
    parameter I_Load_type   = 7'b0000011;
    parameter S_type        = 7'b0100011;
    parameter JAL_type      = 7'b1101111;
    parameter JALR_type     = 7'b1100111;
    ///======= USE FOR ALU CONTROL =====///
    parameter   add     =   4'b0000;
    parameter   sub     =   4'b0001;
    parameter   orr     =   4'b0010;
    parameter   andd    =   4'b0011;
    parameter   xorr    =   4'b0100;
    parameter   slt     =   4'b0101;
    parameter   sll     =   4'b0110;
    parameter   srl     =   4'b0111;
    parameter   sra     =   4'b1000;
    parameter   sltu    =   4'b1001;
    parameter   lui     =   4'b1111;
    ///========= USE FOR FUNCT 3 ========///
    parameter   ADD     =   3'b000;
    parameter   SUB     =   3'b000;
    parameter   ORR     =   3'b110;
    parameter   ANDD    =   3'b111;
    parameter   XORR    =   3'b100;
    parameter   SLT     =   3'b010;
    parameter   SLL     =   3'b001;
    parameter   SRL     =   3'b101;
    parameter   SRA     =   3'b101;
    parameter   SLTU    =   3'b011;


    always @(*) begin
        case (opcode)
            R_type      :  begin
                if(funct7) begin
                    case (funct3)
                        SUB: alu_control  = sub;
                        SRA: alu_control  = sra;
                    endcase
                end
                else begin
                    case (funct3)
                        ADD : alu_control = add;
                        SLL : alu_control = sll;
                        SLT : alu_control = slt;
                        SLTU: alu_control = sltu;
                        XORR: alu_control = xorr;
                        SRL : alu_control = srl;
                        SRA : alu_control = sra;
                        ORR : alu_control = orr;
                        ANDD: alu_control = andd;
                    endcase
                end
                pc_sel = 0;
                immSel = 0;
                reg_write = 1;
                mem_write = 0;
                brUn = 0;
                Asel = 0;
                Bsel = 0;
                WBsel = 1;
            end
            I_R_type    :  begin
                case (funct3)
                    ADD : alu_control = add;
                    // SUB : alu_control = sub; 
                    ORR : alu_control = orr;
                    ANDD: alu_control = andd;
                    XORR: alu_control = xorr;
                    SLT : alu_control = slt;
                    SLTU: alu_control = sltu;
                    SLL : alu_control = sll;
                    SRL : alu_control = srl;
                    SRA : alu_control = sra;
                endcase
                begin
                    pc_sel = 0;
                    immSel = 1;
                    mem_write = 0;
                    reg_write = 1;
                    Asel = 0;
                    Bsel = 1;
                    brUn = 0;
                    WBsel = 1;
                end

            end
            LUI         :  begin
                pc_sel = 0;
                immSel = 1;
                reg_write = 1;
                Bsel = 1;
                Asel = 0;
                alu_control = lui;
                WBsel = 1;
                mem_write = 0;

            end
            AUIPC       :  begin
                pc_sel = 0;
                immSel = 1;
                reg_write = 1;
                Bsel = 1;
                Asel = 1;
                alu_control = add;
                mem_write = 0;
                WBsel = 1;
            end
            B_type      :  begin
                case (funct3)
                    3'b000 : begin // BEQ
                        brUn = 0;
                        if (eq) pc_sel = 1;
                        else pc_sel = 0;
                    end
                    3'b001 : begin // BNE
                        brUn = 0;
                        if (!eq) pc_sel = 1;
                        else pc_sel = 0;
                    end
                    3'b100 : begin
                        brUn = 0;
                        if (lt) pc_sel = 1;
                        else pc_sel = 0;
                    end
                    3'b101 : begin
                        brUn = 0;
                        if (!lt) pc_sel = 1;
                        else pc_sel = 0 ;
                    end
                    // default: ;
                endcase
                begin
                    immSel = 1;
                    reg_write = 0;
                    Bsel = 1;
                    Asel = 1;
                    alu_control = add;
                    mem_write = 1;
                    WBsel = 3;
                end
            end
            I_Load_type :  begin
                case (funct3)
                    3'b000 : reg_write = 2;
                    3'b001 : reg_write = 3;
                    3'b010 : reg_write = 1;
                    3'b100 : reg_write = 4;
                    3'b101 : reg_write = 5;
                    default : reg_write = 1;
                endcase
                begin
                    pc_sel = 0;
                    immSel = 1;
                    Bsel = 1;
                    Asel = 0;
                    alu_control = add;
                    mem_write = 3;
                    WBsel = 0;
                end
            end
            S_type      :  begin
                case (funct3)
                    3'b000 : mem_write = 1;
                    3'b001 : mem_write = 2;
                    3'b010 : mem_write = 3;
                    default: mem_write = 2'b0;
                endcase
                begin
                    pc_sel = 0;
                    immSel = 1;
                    reg_write = 0;
                    Bsel = 1;
                    Asel = 0;
                    alu_control = add;
                    WBsel = 3;
                end

            end
            JAL_type    :  begin
                pc_sel = 1;
                immSel = 1;
                reg_write = 1;
                Bsel = 1;
                Asel = 1;
                alu_control = add;
                mem_write = 0;
                WBsel = 2;
            end
            JALR_type   :  begin
                pc_sel = 1;
                immSel = 1;
                reg_write = 1;
                Bsel = 1; 
                Asel = 0;
                alu_control = add;
                mem_write = 0;
                WBsel = 2;
            end
            default: begin
            pc_sel = 0;
            immSel = 0;
            reg_write = 1;
            brUn = 0;
            Asel = 0;
            Bsel = 0;
            mem_write = 0;
            WBsel = 1;
            alu_control=3;
            end
        endcase

    end
endmodule