class Packet;
    rand bit [6:0] opcode;  // opcode
    rand bit [4:0] rs1;
    rand bit [4:0] rs2;
    rand bit [4:0] rd;
    rand bit [11:0] imm;
    rand bit [19:0] imm_20;
    rand bit [2:0] funct3;
    rand bit [6:0] funct7;
    string name,content;
    bit [31:0] instruction;
    ////===============================***CONSTRAINS***=====================================////
    constraint group_integer {
        // rd inside {[1:31]};
        funct3 dist {[0:7]:=1};
        opcode dist {7'b0110011:=1, 7'b0010011:=1 ,7'b0110111:=1, 7'b0010111:=1};
        if (opcode == 7'b0110011) // R_type
        {
            
            if (funct3 == 0 || funct3 == 5)
            funct7 dist {7'b0000000:/1,7'b0100000:/1};
            else funct7 == 7'b0000000;
        }
        else if (opcode == 7'b0010011) // I_R_type
        {   
            imm inside {[0:2]};
            if (funct3 == 5) {
                funct7 dist {7'b0000000, 7'b0100000};
            }
            else funct7 == 7'b0000000;
        }
        else if  (opcode == 7'b0110111 || opcode == 7'b0010111) {
            imm_20 inside {[1:10]};
        }

       
    }
    constraint group_load_store {
        // rd inside {[1:31]};
        opcode dist {7'b0000011,7'b0100011};
        imm inside {[1:16]};
        if (opcode == 7'b0000011)
            funct3 dist {0,1,2,4,5};
        else if (opcode == 7'b0100011)
            funct3 dist {[0:2]};
    }
    constraint group_branch_jump {
        // rd inside {[1:31]};
        opcode dist {7'b1101111, 7'b1100111, 7'b1100011};
        if (opcode == 7'b1101111)
            imm_20 inside {-12,-8,-4,4,8,12};
        else if (opcode == 7'b1100111) {
            imm inside {-12,-8,-4, 4 ,8 ,12};
            rs1 == 0;
            funct3 == 0;
        }
        else if (opcode == 7'b1100011) {
            imm inside {[1:16]};
            funct3 dist {0,1,4,5,6,7};
        }
    }
    constraint all_instruction {
        
        opcode dist {7'b0110011:=1, 7'b0010011:=1 ,7'b0110111:=1, 7'b0010111:=1,7'b0000011:=1,7'b0100011:=1,7'b1101111:=1, 7'b1100111:=1, 7'b1100011:=1};
        funct3 dist {[0:7]:=1};
        if (opcode == 7'b0110011) // R_type
        {
            rd inside {[1:31]};
            if (funct3 == 0 || funct3 == 5)
            funct7 dist {7'b0000000:=1,7'b0100000:=1};
            else funct7 == 7'b0000000;
        }
        else if (opcode == 7'b0010011) // I_R_type
        {   
            rd inside {[1:31]};
            imm inside {[0:2]};
            if (funct3 == 5) {
                funct7 dist {7'b0000000, 7'b0100000};
            }
            else funct7 == 7'b0000000;
        }
        else if  (opcode == 7'b0110111 || opcode == 7'b0010111) {
            rd inside {[1:31]};
            imm_20 inside {[1:10]};
        }
        else if (opcode == 7'b0000011) {
            rd inside {[1:31]};
            funct3 dist {0,1,2,4,5};
            imm inside {[1:16]};
        }
        else if (opcode == 7'b0100011) {
            funct3 dist {[0:2]};
            imm inside {[1:16]};
        }
        else if (opcode == 7'b1101111)
            imm_20 inside {-12,-8,-4,4,8,12};
        else if (opcode == 7'b1100111) {
            imm inside {-8,-4, 4 ,8 ,12};
            rs1 == 0;
            funct3 == 0;
        }
        else if (opcode == 7'b1100011) {
            imm inside {[1:16]};
            funct3 dist {0,1,4,5,6,7};
        }
    }
////==============================***CONSTRAINS***====================================///
    extern function new(input string name = "Packet");
    extern function logic[31:0] genarate();
    extern function void display(input string prefix = "NOTE");
    extern function void constraint_select(input bit [1:0] constrain_sel);
endclass //className
///====================================================================================//
function Packet::new(input string name);
    this.name = name;
endfunction : new
///====================================================================================//
function logic [31:0] Packet::genarate();
    case (this.opcode)
        7'b0110011 : instruction = {funct7,rs2,rs1,funct3,rd,opcode}; // R
        7'b0010011 : begin // I
            if (funct3 == 1 || funct3 == 5) 
                instruction = {funct7,imm[4:0],rs1,funct3,rd,opcode};
            else 
                instruction = {imm,rs1,funct3,rd,opcode};
        end
        7'b0000011 : instruction = {imm,rs1,funct3,rd,opcode}; // Load
        7'b0100011 : instruction = {imm[11:5],rs2,rs1,funct3,imm[4:0],opcode}; // store
        7'b1100011 : instruction = {imm[12], imm[10:5], rs2,rs1,funct3,imm[4:1],imm[11],opcode}; // B
        7'b0110111 : instruction = {imm_20,rd,opcode};//LUI
        7'b0010111 : instruction = {imm_20,rd,opcode}; // AUIPC
        7'b1101111 : instruction = {imm_20[20],imm_20[10:1],imm_20[11], imm_20[19:12],rd,opcode};//JAL
        7'b1100111 : instruction = {imm, rs1,funct3,rd,opcode}; // JALR
        default: instruction = 32'bx;
    endcase
    return instruction;
endfunction : genarate
///====================================================================================//
function void Packet::display(input string prefix);
    this.content = prefix;
    $display("====================================");

    $display("name: %s%s",name, content);

    $display("OPCODE: %b", opcode);
    $display("RS1: %d", this.rs1);
    $display("RS2: %d", this.rs2);
    $display("RD: %d", this.rd);
    $display("Immediate: %d\t%h", this.imm,this.imm);
    $display("Immediate_20: %d\t%h", this.imm_20,this.imm_20);
    $display("FUNCT3: %b", this.funct3);
    $display("FUNCT7: %b", this.funct7);
    $display("Instruction: %h", this.instruction);
endfunction : display

function void Packet::constraint_select(input bit [1:0] constrain_sel);
    if (constrain_sel == 0) begin
        this.group_integer.constraint_mode(1);
        this.group_load_store.constraint_mode(0);
        this.group_branch_jump.constraint_mode(0);
        this.all_instruction.constraint_mode(0);
    end
    else if (constrain_sel == 1) begin
        this.group_integer.constraint_mode(0);
        this.group_load_store.constraint_mode(1);
        this.group_branch_jump.constraint_mode(0);
        this.all_instruction.constraint_mode(0);
    end
    else if (constrain_sel == 2) begin
        this.group_integer.constraint_mode(0);
        this.group_load_store.constraint_mode(0);
        this.group_branch_jump.constraint_mode(1);
        this.all_instruction.constraint_mode(0);
    end
    else if (constrain_sel == 3) begin
        this.group_integer.constraint_mode(0);
        this.group_load_store.constraint_mode(0);
        this.group_branch_jump.constraint_mode(0);
        this.all_instruction.constraint_mode(1);
    end
endfunction
