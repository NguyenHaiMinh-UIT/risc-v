`timescale 1ns/1ps
module top_test_2 ();
    bit clock = 0 ;
    
    rv_io rv_io_instance(clock);
    test_bench_2 test_bench_2_instance(rv_io_instance);
    top_2 DUT (
        .clk(rv_io_instance.clk),
        .rst(rv_io_instance.reset_n),
        .instr_in(rv_io_instance.instr_in)
    );
    initial begin
      forever #10 begin
        clock = ~clock;
      end  
    end
    

endmodule
