`timescale 1ns/1ps
`include "C:\\Users\\night\\Desktop\\HK6\\CE409\\CE409_LAB5\\risc-v_lab5\\Packet.sv"
// `include "Packet.sv" 
program automatic test_bench_2(rv_io.tb rv_io);
    static int pkts_generated = 0;
    string s;
    shortreal cover_percentage = 0 ;
    Packet pkt2send = new("obj1_");
    ////================***CLASS GEN***==================///
    class gen;
        bit [6:0] op;
        bit [2:0] f3;
        bit [6:0] f7;

        static logic [31:0] ins_arr[$];
        static logic [31:0] temp_arr[10] = '{
            32'h00202183,
            32'hff618213,
            32'h00218293,
            32'h40520333,
            32'h00034663,
            32'h00602223,
            32'h010000ef,
            32'h40428333,
            32'h00602223,
            32'h004000ef};
        covergroup cover_gr_Integer ;
            op1: coverpoint op  { 
                option.auto_bin_max = 256;
                bins R_op = {7'b0110011};
                bins I_op = {7'b0010011};
            }
            // op_I: coverpoint op {
            //     option.auto_bin_max = 256;
            //     bins I_op = {7'b0010011};
            // }
            f: coverpoint f3 {
                bins f30 = {0};
                bins f31 = {1};
                bins f32 = {2};
                bins f33 = {3};
                bins f34 = {4};
                bins f35 = {5};
                bins f36 = {6};
                bins f37 = {7};
            }
            op2: coverpoint op {
                bins LUI_op = {7'b0110111};
                bins AUIPIC_op = {7'b0010111};
            }
            // f7 : coverpoint f7 {
            //     option.auto_bin_max = 256;
            //     bins f71 = {7'b0000000};
            //     bins f72 = {7'b0100000};
            // }
            cr1 : cross op1,f ;

        endgroup

        covergroup cover_gr_load_store;
            op_load : coverpoint op {
                option.auto_bin_max = 256;
                bins Load_op = {7'b0000011};
            }
            op_store : coverpoint op {
                option.auto_bin_max = 256;
                bins Store_op = {7'b0100011};
            }
            f_load: coverpoint f3 {
                bins f30 = {0};
                bins f31 = {1};
                bins f32 = {2};
                bins f34 = {4};
                bins f35 = {5};
            }
            f_store : coverpoint f3 {
                bins f30 = {0};
                bins f31 = {1};
                bins f32 = {2};
            }
            cross_load : cross op_load,f_load;
            cros_store : cross op_store,f_store;
        endgroup : cover_gr_load_store
        covergroup cover_gr_branch_jump;
            op_jal : coverpoint op {
                option.auto_bin_max = 256;
                bins jal_op = {7'b1101111}    ;
            }
            op_jalr : coverpoint op {
                option.auto_bin_max = 256;
                bins jalr_op = {7'b1100111};
            }
            op_B : coverpoint op {
                option.auto_bin_max = 256;
                bins branch_op = {7'b1100011};
            }
            f : coverpoint f3 {
                bins f30 = {0};
                bins f31 = {1};
                bins f34 = {4};
                bins f35 = {5};
                bins f36 = {6};
                bins f37 = {7};
            }
            cr1 : cross op_B,f;
        endgroup
        function new();
            cover_gr_Integer  = new();          
            cover_gr_load_store = new();
            cover_gr_branch_jump = new();
        endfunction
        function void gen_integer();
            pkt2send.constraint_select(0);
            assert(pkt2send.randomize());
            op = pkt2send.opcode;
            f3 = pkt2send.funct3;
            f7 = pkt2send.funct7;
            ins_arr.push_back(pkt2send.genarate());
            pkts_generated++;
            s.itoa(pkts_generated);
            pkt2send.display(s);
        endfunction
        function void gen_load_store();
            pkt2send.constraint_select(1);
            assert(pkt2send.randomize());
            op = pkt2send.opcode;
            f3 = pkt2send.funct3;
            f7 = pkt2send.funct7;
            ins_arr.push_back(pkt2send.genarate());
            pkts_generated++;
            s.itoa(pkts_generated);
            pkt2send.display(s);
        endfunction : gen_load_store
        function void gen_branch_jump();
            pkt2send.constraint_select(2);
            assert(pkt2send.randomize());
            op = pkt2send.opcode;
            f3 = pkt2send.funct3;
            f7 = pkt2send.funct7;
            ins_arr.push_back(pkt2send.genarate());
            pkts_generated++;
            s.itoa(pkts_generated);
            pkt2send.display(s);
        endfunction : gen_branch_jump
        function abs(input int i);
            // ins_arr.push_back(32'h004000ef);
            // ins_arr.push_back(32'h00602223);
            // ins_arr.push_back(32'h40428333);
            // ins_arr.push_back(32'h010000ef);
            // ins_arr.push_back(32'h00602223);
            // ins_arr.push_back(32'h00034663);
            // ins_arr.push_back(32'h40520333);
            // ins_arr.push_back(32'h00218293);
            // ins_arr.push_back(32'hff618213);
            // ins_arr.push_back(32'h00202183);
            // ins_arr.push_back(32'h004000ef);
            ins_arr.push_back(temp_arr[i]);

        endfunction
        // function void gen_all();
        //     pkt2send.constraint_select(3);
        //     assert(pkt2send.randomize());
        //     op = pkt2send.opcode;
        //     f3 = pkt2send.funct3;
        //     f7 = pkt2send.funct7;
        //     ins_arr.push_back(pkt2send.genarate());
        //     pkts_generated++;
        //     s.itoa(pkts_generated);
        //     pkt2send.display(s);
        // endfunction : gen_all

    endclass : gen
    ////================***CLASS GEN***==================///
    ////===============***CLASS DRIVE***==================///
    class driver;
        gen pkt = new();
        function void drive();
            foreach (pkt.ins_arr[i]) begin
                rv_io.cb.instr_in <= pkt.ins_arr[i];
            end
        endfunction
    endclass //driver
    ////===============***CLASS DRIVE***==================///

    task reset();
        rv_io.reset_n = 1'b0;
        repeat(2) @(rv_io.cb);
    endtask : reset
    gen geng = new();
    driver pktdrive = new();

    ////===============*** MAIN ***==================///
    initial begin
//        geng.coverage coverage_inst = new();
        reset();
        repeat(100) @(rv_io.cb)begin
            rv_io.reset_n = 1'b1;
            geng.gen_load_store();
            geng.cover_gr_load_store.sample();
            pktdrive.drive();
        end
        cover_percentage = geng.cover_gr_load_store.get_inst_coverage();
        $display("coverage percent: %f %%", cover_percentage);

        reset();
        // geng.abs();
        // repeat(10) @(rv_io.cb) begin
            // integer i = 10;
            // geng.abs(i);
            // rv_io.reset_n = 1'b1;
            // pktdrive.drive();
            // i--;
        // end
           
        repeat(200) @(rv_io.cb)begin
            rv_io.reset_n = 1'b1;
            geng.gen_integer();
            geng.cover_gr_Integer.sample();
            pktdrive.drive();
        end
        cover_percentage = geng.cover_gr_Integer.get_inst_coverage();
        $display("coverage percent: %f %%", cover_percentage);

        reset();
        repeat (100) @(rv_io.cb) begin
            rv_io.reset_n = 1'b1;
            geng.gen_branch_jump();
            geng.cover_gr_branch_jump.sample();
            pktdrive.drive();
        end
        cover_percentage = geng.cover_gr_branch_jump.get_inst_coverage();
        $display("coverage percent: %f %%", cover_percentage);        
            // cover_percentage = geng.cover_gr_Integer.get_coverage();
    end
    ////===============*** END MAIN ***==================///
endprogram : test_bench_2
