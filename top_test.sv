`timescale 1ns/1ps
module  top_test ();
    bit clk = 0;
    always #1 clk = ~clk;
    riscv_interface riscv_interface(.clk);
    auto_test_bench test_bench(riscv_interface);
    top DUT (
        .clk(clk),
        .rst(riscv_interface.reset_n)
    );

endmodule 