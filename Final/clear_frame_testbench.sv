module clear_frame_testbench();

timeunit 10ns;
timeprecision 1ns;

logic Clk, Reset, clear_frame_start;
logic [9:0] DrawX, DrawY;
logic [9:0] h_counter, v_counter;
logic clear_frame_done;
logic curr_state;

clear_frame cf(.*);

assign h_counter = cf.h_counter;
assign v_counter = cf.v_counter;
assign curr_state = cf.curr_state;

always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end 

initial begin: TEST_VECTORS
Reset = 1;
clear_frame_start = 0;
#5 Reset = 0;
#5 clear_frame_start = 1;

#100 clear_frame_start = 0;
#1000000 clear_frame_start = 1;
 
end


endmodule
