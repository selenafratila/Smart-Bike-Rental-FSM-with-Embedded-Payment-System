`timescale 1ns / 1ps

module bike_renting_TOP(
    input logic CK,
    input logic RESET,
    input logic [2:0] USER_ID,
    input logic START_RENT, 
    input logic RETURN_BIKE,
    output logic LOCK_OPEN,
    output logic WARNING_LED,
    output logic ERROR_LED,
    output logic [15:0] TOTAL_COST,
    output logic [15:0] CREDIT_LEFT);

logic w_timer_en,w_write_en;
logic [15:0] w_timer_val, w_new_balance, w_current_balance,w_total_cost;

timer TIMER (.ck(CK),
             .reset(RESET),
             .en(w_timer_en),
             .start_rent(START_RENT),
             .timer_val(w_timer_val) );
alu ALU (.timer_val(w_timer_val),
         .total_cost(w_total_cost) );
memory MEMORY(.ck(CK),
              .write_en(w_write_en),
              .user_id(USER_ID),
              .balance_in(w_new_balance),
              .current_balance(w_current_balance) );
fsm FSM(.ck(CK),
        .reset(RESET),
        .start_rent(START_RENT),
        .return_bike(RETURN_BIKE),
        .balance_in(w_current_balance),
        .cost_in(w_total_cost),
        .timer_en(w_timer_en),
        .write_en(w_write_en),
        .lock_open(LOCK_OPEN),
        .error_led(ERROR_LED),
        .warning_led(WARNING_LED),
        .new_balance_out(w_new_balance) ); 
        
assign CREDIT_LEFT=w_current_balance;
assign TOTAL_COST=w_total_cost; 
  
endmodule
