`timescale 1ns/1ps
module test_bench(
);
    reg clk,rst;
    
    top top_instance(
        .clk(clk),
        .rst(rst)
    );
    initial begin
        clk <= 1'b0;
        forever #1 clk = ~clk;
    end
    initial begin
        rst = 0;
        #4 rst = 1;
    end
    
    
endmodule