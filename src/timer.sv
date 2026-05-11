`timescale 1ns / 1ps
module timer(
    input  logic ck, 
    input  logic reset,
    input  logic en, 
    input logic start_rent,        
    output logic [15:0] timer_val);


always_ff @(posedge ck) begin
    if (reset||start_rent) 
        timer_val<=0;
    else if (en)              
        timer_val<=timer_val+1;
end

endmodule
