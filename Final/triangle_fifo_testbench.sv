module triangle_fifo_testbench();

timeunit 10ns;
timeprecision 1ns;

parameter WI = 2;
parameter WF = 2;
parameter size = 3;

logic Clk, Reset;
logic r_en, w_en;
logic [2:0][2:0][(WI+WF)-1:0] triangle_in;
logic [2:0][2:0][(WI+WF)-1:0] triangle_out;
logic is_empty, is_full;
logic [size-1:0] num;
logic [(WI+WF)*9-1:0] fifo [size-1:0];

triangle_fifo #(.WI(WI), .WF(WF), .size(size)) tf(.*);

assign num = tf.num;
assign fifo = tf.tfr.fifo;

always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end 

initial begin: TEST_VECTORS
Reset = 1;
r_en = 0;
w_en = 0;
#2 Reset = 0;

#2 triangle_in = {9{{(WI+WF){1'b1}}}};
#2 w_en = 1'b1;
#2 w_en = 1'b0;

#2 triangle_in = {9{{WI{1'b0}},{WF{1'b1}}}};
#2 w_en = 1'b1;
#2 w_en = 1'b0;

#2 triangle_in = {9{{WI{1'b1}},{WF{1'b0}}}};
#2 w_en = 1'b1;
#2 w_en = 1'b0;

#2 triangle_in = {9{{WI{1'b1}},{WF{1'b1}}}};
#2 w_en = 1'b1;
#2 w_en = 1'b0;

#2 r_en = 1;
#10 r_en = 0;

#2 triangle_in = {9{{(WI+WF){1'b0}}}};
#2 w_en = 1'b1;
#2 w_en = 1'b0;

#2 triangle_in = {9{{WI{1'b1}},{WF{1'b1}}}};
#2 w_en = 1'b1;
#2 w_en = 1'b0;

#2 r_en = 1;
#2 r_en = 0;

end
endmodule
