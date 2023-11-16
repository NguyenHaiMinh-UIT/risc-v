interface riscv_interface (input bit clk);
    logic reset_n ;
    logic [31:0] addr;
    logic [31:0] data;

    clocking cb (posedge clk) ; 
    output re
endinterface 
