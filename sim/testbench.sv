`timescale 1ns / 1ps

module testbench ();
  
    logic ck;
    logic reset;
    logic [2:0] user_id;
    logic start_rent;
    logic return_bike;
    logic lock_open;
    logic error_led;
    logic warning_led;
    logic [15:0] total_cost;
    logic [15:0] credit_left;

    bike_renting_TOP dut (
        .CK(ck),
        .RESET(reset),
        .USER_ID(user_id),
        .START_RENT(start_rent),
        .RETURN_BIKE(return_bike),
        .LOCK_OPEN(lock_open),
        .ERROR_LED(error_led),
        .WARNING_LED(warning_led),
        .TOTAL_COST(total_cost),
        .CREDIT_LEFT(credit_left) );
  
    //clock
    initial begin 
            ck=0;
            forever #5 ck=~ck;
    end

    initial begin
        //system initialization and hardware reset 
        reset = 1; 
        user_id = 0; 
        start_rent = 0;
        return_bike = 0;
        #20 reset = 0; 

      //SCENARIO 1: normal trip for User 0 (100 Credits) 
      //check if balance goes from 100 to 94 after 16 clock cycles (time units) of using the bike
        user_id = 0;
        #10 start_rent = 1;
        #10 start_rent = 0;
        #160; // increased time to 16 clock cycles to see the cost growing to 6 Credits
        #10 return_bike = 1;
        #10 return_bike = 0;
        #30; 

        //SCENARIO 2: quick cancel for user 1 (15 RON)
        //should only charge the minimum tax (5 RON)
        user_id = 1;
        #10 start_rent = 1;
        #10 start_rent = 0;
        #10 return_bike = 1; 
        #10 return_bike = 0;
        #30;

        //SCENARIO 3: overdraft for user 5 (12 Credits) 
        //warning led should trigger, then error, then the credit becomes 0
        user_id = 5;
        #10 start_rent = 1;
        #10 start_rent = 0;
        #300; 
        start_rent = 0;
        return_bike = 0;
        #30;

        //SCENARIO 4: warning without error for user 3 (10 Credits) 
        //after 17 clock cycles, the cost should be 7 Credits, then the user is returning the bike before any error
        user_id = 3; 
        #10 start_rent = 1;
        #10 start_rent = 0;
        #170;
        #10 return_bike = 1;
        #10 return_bike = 0;
        #30;
      
        //SCENARIO 5: user 4 has only 3 Credits
        //minimum tax is 5 Credits-> this user should be rejected immediately
        user_id = 4; 
        #20; //wait a bit to see the credit_left = 3 on the wave
        #10 start_rent = 1; 
        #10 start_rent = 0;
        //at this point, lock_open should stay 0, and error_led should turn 1
        #30;
        
        $stop; 
    end
endmodule
