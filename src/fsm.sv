`timescale 1ns / 1ps

module fsm(
    input logic ck,
    input logic reset,
    input logic start_rent,
    input logic return_bike,
    input logic [15:0] balance_in, // memory
    input logic [15:0] cost_in, // ALU
    output logic timer_en,
    output logic write_en,
    output logic lock_open,
    output logic error_led,
    output logic warning_led,
    output logic [15:0] new_balance_out );
 
localparam logic [2:0] IDLE    = 3'b000;
localparam logic [2:0] CHECK   = 3'b001;
localparam logic [2:0] RENTING = 3'b010;
localparam logic [2:0] PAY     = 3'b011;
localparam logic [2:0] ERROR   = 3'b100;

logic [2:0] state;  

always_ff@(posedge ck) begin
    if(reset) begin state<=IDLE;
                    new_balance_out<=0;
              end 
       else case(state) 
                  IDLE: if(start_rent) state<=CHECK;
                      
                 CHECK: if(balance_in>=5) state<=RENTING;
                             else state<=ERROR;
                        
               RENTING: if (cost_in>=balance_in) begin new_balance_out<=0;
                                                        state<= PAY;
                                                  end
                            else if (return_bike) begin new_balance_out<=balance_in-cost_in;
                                                        state<=PAY;
                                                  end
                            
                   PAY: if(cost_in>balance_in) state<=ERROR;
                            else state<=IDLE;
                        
                 ERROR: if(!start_rent && !return_bike) state<=IDLE;
                       
               default: state<=IDLE;
            endcase 
 end
 
always_comb begin
    timer_en=0;
    write_en=0;
    lock_open=0;
    error_led=0;
    warning_led=0;

    case(state)
        IDLE: ; 
        
        CHECK: ; 
        
        RENTING: begin
                    lock_open=1;
                    if(!return_bike) timer_en=1;
                       else timer_en=0;
                    if((balance_in-cost_in)<5) warning_led=1; 
                 end
                 
        PAY: write_en  = 1;
        
        ERROR:  error_led = 1;
 
    endcase
end                
endmodule
