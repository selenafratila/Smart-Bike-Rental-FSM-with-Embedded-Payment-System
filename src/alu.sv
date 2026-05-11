`timescale 1ns / 1ps

module alu ( 
    input  logic [15:0] timer_val,
    output logic [15:0] total_cost );

always_comb 
begin 
        if (timer_val<=15)  total_cost=5;
        else 
            total_cost=5+(timer_val-15);
end
    
endmodule
