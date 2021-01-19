// calculate the model matrix in mvp transformation

// pseudocode:
// get_model_matrix(alpha, beta, gamma, scale, x_translate, y_translate, z_translate)
// {
//     rotation_m << euler_angle(alpha, beta, gamma);
//
//     scale_m << scale, 0    , 0    , 0,
//                0    , scale, 0    , 0,
//                0    , 0    , scale, 0,
//                0    , 0    , 0    , 1;
//
//     translate_m << 1, 0, 0, x_translate,
//                    0, 1, 0, y_translate,
//                    0, 0, 1, z_translate,
//                    0, 0, 0, 1          ;
//
//     return translate_m * rotation_m * scale_m;
// }

module get_model_matrix # (
    // I: integer bits
    // F: decimal bits
    // angle
    parameter WIIA = 4,
    parameter WIFA = 8,
    // scale, x_translate, y_translate, z_translate
    parameter WIIB = 8,
    parameter WIFB = 8,
    // output of sin, cos
    parameter WOIA = 2,
    parameter WOFA = 12,
    // output matrix
    parameter WOI = 8,
    parameter WOF = 8
)
(   // Euler angles
    input [WIIA+WIFA-1:0] alpha, beta, gamma,
    // scale && x, y, z -axis offsets
    input [WIIB+WIFB-1:0] scale, x_translate, y_translate, z_translate,
    // model matrix
    output logic [15:0][WOI+WOF-1:0] model_matrix
);

// 0 and 1 with digits of the parametered fixed-point numbers
logic [WOI+WOF-1:0] zero, one;
// Euler angle <-> rotation matrix
logic [15:0][WOIA+WOFA-1:0] R;
// values of the model matrix indexed with 0, 1, 2, 4, 5, 6, 8, 9, 10
logic [WOI+WOF-1:0] index0, index1, index2, index4, index5, index6, index8, index9, index10;
// overflow indicator, just ignore them
logic o0, o1, o2, o3, o4, o5, o6, o7, o8, o9, o10;

// convert 0 to 1 to parametered digits
fxp_zoom # (
    .WII(8), .WIF(8),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) zoom0 (
    .in(16'h0000),
    .out(zero),
    .overflow(o0)
);
fxp_zoom # (
    .WII(8), .WIF(8),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) zoom1 (
    .in(16'h0100),
    .out(one),
    .overflow(o1)
);

// get Euler angle matrix
get_euler_angle_matrix #(.WII(WIIA), .WIF(WIFA), .WOI(WOIA), .WOF(WOFA)) euler (
    .alpha(alpha), 
    .beta(beta),
    .gamma(gamma),
    .euler_angle_matrix(R)
);


// apply precompute strategy to eliminate FPGA resources
// ans =
// [a1*scale, a2*scale, a3*scale, x]
// [a4*scale, a5*scale, a6*scale, y]
// [a7*scale, a8*scale, a9*scale, z]
// [       0,        0,        0, 1] 

fxp_mul #(
    .WIIA(WIIB), .WIFA(WIFB),
    .WIIB(WOIA), .WIFB(WOFA),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul0 (.ina(scale), .inb(R[0]), .out(index0), .overflow(o2));
fxp_mul #(
    .WIIA(WIIB), .WIFA(WIFB),
    .WIIB(WOIA), .WIFB(WOFA),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul1 (.ina(scale), .inb(R[1]), .out(index1), .overflow(o3));
fxp_mul #(
    .WIIA(WIIB), .WIFA(WIFB),
    .WIIB(WOIA), .WIFB(WOFA),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul2 (.ina(scale), .inb(R[2]), .out(index2), .overflow(o4));
fxp_mul #(
    .WIIA(WIIB), .WIFA(WIFB),
    .WIIB(WOIA), .WIFB(WOFA),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul3 (.ina(scale), .inb(R[4]), .out(index4), .overflow(o5));
fxp_mul #(
    .WIIA(WIIB), .WIFA(WIFB),
    .WIIB(WOIA), .WIFB(WOFA),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul4 (.ina(scale), .inb(R[5]), .out(index5), .overflow(o6));
fxp_mul #(
    .WIIA(WIIB), .WIFA(WIFB),
    .WIIB(WOIA), .WIFB(WOFA),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul5 (.ina(scale), .inb(R[6]), .out(index6), .overflow(o7));
fxp_mul #(
    .WIIA(WIIB), .WIFA(WIFB),
    .WIIB(WOIA), .WIFB(WOFA),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul6 (.ina(scale), .inb(R[8]), .out(index8), .overflow(o8));
fxp_mul #(
    .WIIA(WIIB), .WIFA(WIFB),
    .WIIB(WOIA), .WIFB(WOFA),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul7 (.ina(scale), .inb(R[9]), .out(index9), .overflow(o9));
fxp_mul #(
    .WIIA(WIIB), .WIFA(WIFB),
    .WIIB(WOIA), .WIFB(WOFA),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul8 (.ina(scale), .inb(R[10]), .out(index10), .overflow(o10));

// assign values to output matrix
assign model_matrix[0] = index0;
assign model_matrix[1] = index1;
assign model_matrix[2] = index2;
assign model_matrix[3] = x_translate;
assign model_matrix[4] = index4;
assign model_matrix[5] = index5;
assign model_matrix[6] = index6;
assign model_matrix[7] = y_translate;
assign model_matrix[8] = index8;
assign model_matrix[9] = index9;
assign model_matrix[10] = index10;
assign model_matrix[11] = z_translate;
assign model_matrix[12] = zero;
assign model_matrix[13] = zero;
assign model_matrix[14] = zero;
assign model_matrix[15] = one;

endmodule
