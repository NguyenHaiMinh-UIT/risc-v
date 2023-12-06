interface rv_io(input bit clk) ;
    logic reset_n;
    logic [31:0] instr_in;
    clocking cb @(posedge clk) ;
        default input #0 output #0;
        output reset_n;
        output instr_in;
    endclocking;
    modport tb(clocking cb, output reset_n);
endinterface

