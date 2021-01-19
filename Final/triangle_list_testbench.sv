module triangle_list_testbench();

timeunit 10ns;
timeprecision 1ns;

parameter WI = 2;
parameter WF = 2;
parameter Waddr = 3;
parameter size = 5;

logic Clk, Reset;
logic r_en, w_en;
logic [2:0][2:0][(WI+WF)-1:0] triangle_in;
logic [2:0][2:0][(WI+WF)-1:0] triangle_out;
logic is_empty, is_full, read_done;
logic [Waddr-1:0] r_addr,w_addr;
logic [Waddr-1:0] num;
reg   [(WI+WF)*9-1:0] list [size:0];

triangle_list #(.WI(WI), .WF(WF), .size(size)) tl(.*);

assign num = tl.num;
assign r_addr = tl.r_addr;
assign w_addr = tl.w_addr;
assign list = tl.tlr.list;

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

#2 triangle_in = {9{{(WI+WF){1'b1}}}};
#2 w_en = 1'b1;
#2 w_en = 1'b0;

#2 triangle_in = {9{{(WI+WF){1'b0}}}};
#2 w_en = 1'b1;
#2 w_en = 1'b0;

#2 triangle_in = {9{{(WI+WF){1'b1}}}};
#2 w_en = 1'b1;
#2 w_en = 1'b0;

// #2 triangle_in = {9{{WI{1'b1}},{WF{1'b1}}}};
// #2 w_en = 1'b1;
// #2 w_en = 1'b0;

#2 r_en = 1;
#2 r_en = 0;

#2 r_en = 1;
#2 r_en = 0;

#2 r_en = 1;
#2 r_en = 0;

#2 r_en = 1;
#2 r_en = 0;

#2 r_en = 1;
#2 r_en = 0;

#2 r_en = 1;
#2 r_en = 0;

#2 r_en = 1;
#2 r_en = 0;

#2 r_en = 1;
#2 r_en = 0;

end
endmodule
