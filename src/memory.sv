`timescale 1ns / 1ps

module memory(
    input logic ck,
    input logic write_en,
    input logic [2:0] user_id,
    input logic [15:0] balance_in, //FSM
    output logic [15:0] current_balance );
    
logic [15:0] mem[0:7];

initial
  begin 
  mem[0]=100;
  mem[1]=15;
  mem[2]=65;
  mem[3]=10;
  mem[4]=3;
  mem[5]=12;
  mem[6]=30;
  mem[7]=5;
  end

assign current_balance=mem[user_id]; //read

always_ff@(posedge ck) 
  if(write_en) mem[user_id]<=balance_in; //write
 
endmodule
