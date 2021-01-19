// since the sin function of fixedpoint_lib.sv performs poor
// i.e. the angle shall be in range of [0, pi/2], and around angle=0 or pi/2 it cannot work properly
// we make some additional features 
// now the input angle can be in range of [0, 2pi], the module will automatically transform the angle to corresponding angle in [0, pi/2] (using Induction Formula)
// and we use Taylor expansion around angle=0 to evaluate, we assign sin(alpha)=1 directly around angle=pi/2

module cal_sin # ( 
    // input angle, 4 diits integer, 8 digits decimal
    parameter WII  = 4,
    parameter WIF  = 8,
    // output sin, 2 digits integer, 12 digits decimal
    parameter WOI  = 2,
    parameter WOF  = 12,
    parameter bit ROUND= 1
)
(
    // input angle
    input  logic [WII+WIF-1:0] in,
    // output sin(angle)
    output logic [WOI+WOF-1:0] out
);

// pi = 3.1415926 = 3.243f69a25b094
// pi/2 = 1.921fb4d12d84a
// 1.5pi = 4.b65f1e73888dc
// 2pi=  6.487ed344b6128

// overflow indicator, just ignore them
logic overflow0, overflow1, overflow2, overflow3, overflow4;
// input of the state machine, will decide the transformation of the angle
logic [WII+WIF-1:0] angle_in;
// pi-angle, angle-pi. 2pi-angle, intermediate variables used in transformation
logic [WII+WIF-1:0] pi_sub_in, in_sub_pi, two_pi_sub_in;
// output of the state machine, positive and its negtive, the state machine will decide the output based on the transformation
logic [WOI+WOF-1:0] angle_out, neg_angle_out;

// calculate pi-angle
fxp_addsub #(.WIIA(4), .WIFA(8), .WIIB(WII), .WIFB(WIF), .WOI(WII), .WOF(WIF), .ROUND(1)) sub0 (
    .ina(12'h324), 
    .inb(in), 
    .sub(1'b1), 
    .out(pi_sub_in), 
    .overflow(overflow0)
);

// calculate angle-pi
fxp_addsub #(.WIIA(WII), .WIFA(WIF), .WIIB(4), .WIFB(8), .WOI(WII), .WOF(WIF), .ROUND(1)) sub1 (
    .ina(in), 
    .inb(12'h324), 
    .sub(1'b1), 
    .out(in_sub_pi), 
    .overflow(overflow1)
);

// calculate 2pi-angle
fxp_addsub #(.WIIA(4), .WIFA(8), .WIIB(WII), .WIFB(WIF), .WOI(WII), .WOF(WIF), .ROUND(1)) sub2 (
    .ina(12'h648), 
    .inb(in), 
    .sub(1'b1), 
    .out(two_pi_sub_in), 
    .overflow(overflow2)
);

// calculate the transformed angle, must be in range of [0, pi/2]
fix_sin sin ( 
    .in(angle_in), 
    .out(angle_out), 
    .i_overflow(overflow3)
);

// take the negative of the sin value
fxp_addsub #(.WIIA(2), .WIFA(12), .WIIB(WOI), .WIFB(WOF), .WOI(WOI), .WOF(WOF), .ROUND(1)) sub3 (
    .ina(14'b00000000000000), 
    .inb(angle_out), 
    .sub(1'b1), 
    .out(neg_angle_out), 
    .overflow(overflow4)
);

always_comb
begin
    // using Induction Formula to extend angle range
    // [3pi/2, 2pi]
    if ( in >= 12'h4b6 )
        begin
            angle_in = two_pi_sub_in;
            out = neg_angle_out;
        end
    // [pi, 3pi/2]
    else if ( in >= 12'h324 )
        begin
            angle_in = in_sub_pi;
            out = neg_angle_out;
        end
    // [pi/2, pi]
    else if ( in >= 12'h192 )
        begin
            angle_in = pi_sub_in;
            out = angle_out;
        end
    // [0, pi/2]
    else
        begin
            angle_in = in;
            out = angle_out;
        end
end

endmodule

// this module use sin to calculate cos
module cal_cos # ( 
    // input angle, 4 diits integer, 8 digits decimal
    parameter WII  = 4,
    parameter WIF  = 8,
    // output sin, 2 digits integer, 12 digits decimal
    parameter WOI  = 2,
    parameter WOF  = 12,
    parameter bit ROUND= 1
)
(
    input  logic [WII+WIF-1:0] in,
    output logic [WOI+WOF-1:0] out
);

// pi = 3.1415926 = 3.243f69a25b094
// pi/2 = 1.921fb4d12d84a
// 1.5pi = 4.b65f1e73888dc
// 2pi=  6.487ed344b6128

// overflow indicator, just ignore them
logic overflow0, overflow1, overflow2, overflow3, overflow4, overflow5;
// input of the state machine, will decide the transformation of the angle
logic [WII+WIF-1:0] angle_in;
// pi/2-angle, angle-pi/2. 3pi/2-angle, angle-3pi/2, intermediate variables used in transformation
logic [WII+WIF-1:0] pi_div_2_sub_in, in_sub_pi_div_2, three_pi_div_2_sub_in, in_sub_3pi_div_2;
// output of the state machine, positive and its negtive, the state machine will decide the output based on the transformation
logic [WOI+WOF-1:0] angle_out, neg_angle_out;

//calculate pi/2-angle
fxp_addsub #(.WIIA(4), .WIFA(8), .WIIB(WII), .WIFB(WIF), .WOI(WII), .WOF(WIF), .ROUND(1)) sub0 (
    .ina(12'h192), 
    .inb(in), 
    .sub(1'b1), 
    .out(pi_div_2_sub_in), 
    .overflow(overflow0)
);

//calculate angle-pi/2
fxp_addsub #(.WIIA(WII), .WIFA(WIF), .WIIB(4), .WIFB(8), .WOI(WII), .WOF(WIF), .ROUND(1)) sub1 (
    .ina(in), 
    .inb(12'h192), 
    .sub(1'b1), 
    .out(in_sub_pi_div_2), 
    .overflow(overflow1)
);

//calculate 3pi/2-angle
fxp_addsub #(.WIIA(4), .WIFA(8), .WIIB(WII), .WIFB(WIF), .WOI(WII), .WOF(WIF), .ROUND(1)) sub2 (
    .ina(12'h4b6), 
    .inb(in), 
    .sub(1'b1), 
    .out(three_pi_div_2_sub_in), 
    .overflow(overflow2)
);

//calculate angle-3pi/2
fxp_addsub #(.WIIA(WII), .WIFA(WIF), .WIIB(4), .WIFB(8), .WOI(WII), .WOF(WIF), .ROUND(1)) sub3 (
    .ina(in), 
    .inb(12'h4b6), 
    .sub(1'b1), 
    .out(in_sub_3pi_div_2), 
    .overflow(overflow3)
);

// calculate the transformed sin(angle), must be in range of [0, pi/2], which can reflcet the value of original cos(angle)
fix_sin sin ( 
    .in(angle_in), 
    .out(angle_out), 
    .i_overflow(overflow4)
);

// take the negative of the cos value
fxp_addsub #(.WIIA(2), .WIFA(12), .WIIB(WOI), .WIFB(WOF), .WOI(WOI), .WOF(WOF), .ROUND(1)) sub4 (
    .ina(14'b00000000000000), 
    .inb(angle_out), 
    .sub(1'b1), 
    .out(neg_angle_out), 
    .overflow(overflow5)
);

always_comb
begin
    // using Induction Formula to extend angle range
    // [3pi/2, 2pi]
    if ( in >= 12'h4b6 )
        begin
            angle_in = in_sub_3pi_div_2;
            out = angle_out;
        end
    // [pi, 3pi/2]
    else if ( in >= 12'h324 )
        begin
            angle_in = three_pi_div_2_sub_in;
            out = neg_angle_out;
        end
    // [pi/2, pi]
    else if ( in >= 12'h192 )
        begin
            angle_in = in_sub_pi_div_2;
            out = neg_angle_out;
        end
    // [0, pi/2]
    else
        begin
            angle_in = pi_div_2_sub_in;
            out = angle_out;
        end
end

endmodule

// this module deal with the boundary condition
module fix_sin(
    // input angle, 4-bit integer, 8-bit decimal
    input  logic [11:0] in,
    // output sin(angle), 2-bit integer, 12-bit decimal
    output logic [13:0] out,
    // overflow indicator
    output logic i_overflow
);

// two output, normal one and abnormal one, the state machine will choose
logic [13:0] orig_out, taylor_out;
// overflow indicator, just ignore them
logic overflow;

// calculate sin(x) if works properly
fxp_sin #(.WII(4), .WIF(8), .WOI(2), .WOF(12), .ROUND(1)) sin ( 
    .in(in), 
    .out(orig_out), 
    .i_overflow(i_overflow)
);

// the Taylor expansion of sin, i.e. sin(x)=x
fxp_zoom #(.WII(4), .WIF(8), .WOI(2), .WOF(12), .ROUND(1)) taylor (
    .in(in),
    .out(taylor_out),
    .overflow(overflow)
);

always_comb
begin
    // we tested that when input angle is smaller than it, sin will not work
    if(in < 12'h014)
        // assign Taylor expansion
        out = taylor_out;
    // we tested that when input angle is larger than it, sin will not work
    else if(in > 12'h17e)
        // assign it with 1
        out = 14'b01000000000000;
    // works normally
    else
        out = orig_out;
end

endmodule