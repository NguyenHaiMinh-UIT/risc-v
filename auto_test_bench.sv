`timescale 1ns/1ps
program automatic auto_test_bench(riscv_interface.tb riscv_io);

    initial begin
        run();
    end
    task  run();
        riscv_io.reset_n = 1'b0;
        #1 riscv_io.reset_n = 1'b1;
    endtask //automatic

endprogram