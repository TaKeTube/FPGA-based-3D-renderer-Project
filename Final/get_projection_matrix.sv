// calculate the projection matrix in mvp transformation

// eye_fov:      field of view
// aspect_ratio: aspect ratio, screen width/height
// zNear:        near z of the frustum
// zFar:         far z of the frustum

// pseudocode: (has been precomputed)
// get_projection_matrix(eye_fov, aspect_ratio, zNear, zFar)
// {
//     zNear = -zNear;
//     zFar  = -zFar;
//      // this variable has been precomputed as a parameter of the function
//     inv_tan = 1 / tan(eye_fov / 180 * MY_PI * 0.5);
//     k = 1 / (zNear - zFar);
//     projection << inv_tan / aspect_ratio, 0      , 0                 , 0                   ,
//                   0                     , inv_tan, 0                 , 0                   ,
//                   0                     , 0      , (zNear + zFar) * k, 2 * zFar * zNear * k,
//                   0                     , 0      , 1                 , 0                   ;
//     return projection;
// }

module get_projection_matrix #(
    // parameter of inv_tan, aspect_ratio, z_near, z_far in the form of fixed-point numbers
    // WII: integer bits
    // WIF: decimal bits
    parameter WII = 8,
    parameter WIF = 8,
    // parameter of output matrix
    // WOI: integer bits
    // WOF: decimal bits
    parameter WOI = 8,
    parameter WOF = 8
) 
(   // inv_tan, aspect_ratio, z_near, z_far in the pseudocode
    input [WII+WIF-1:0] inv_tan, aspect_ratio, z_near, z_far,
    // projection matrix
    output logic [15:0][WOI+WOF-1:0] projection_matrix
);

// 0 and 1 with digits of the parametered fixed-point numbers
logic [WOI+WOF-1:0] one, zero;
// intermediate variables, will be introduced in the following
logic [WOI+WOF-1:0] neg_z_near, neg_z_far, distance, k, n_a_f, n_a_f_mul_k, tmp, f_m_n_m_k, f_m_n_m_k_2, t_d_a;
// overflow indicator, just ignore them
logic overflow, overflow0, overflow1, overflow2, overflow3, overflow4;
logic overflow5, overflow6, overflow7, overflow8, overflow9, overflow10, overflow11;

// pseudocode: zNear = -zNear;
fxp_addsub #(
    .WIIA(8), .WIFA(8),
    .WIIB(WII), .WIFB(WIF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) ads0 (
    .ina(16'h0000),
    .inb(z_near),
    .sub(1'b1),
    .out(neg_z_near),
    .overflow(overflow0)
);

// pseudocode: zFar = -zFar;
fxp_addsub #(
    .WIIA(8), .WIFA(8),
    .WIIB(WII), .WIFB(WIF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) ads1 (
    .ina(16'h0000),
    .inb(z_far),
    .sub(1'b1),
    .out(neg_z_far),
    .overflow(overflow1)
);

// distance = z_near - z_far (already taken negative)
fxp_addsub #(
    .WIIA(WOI), .WIFA(WOF),
    .WIIB(WOI), .WIFB(WOF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) ads2 (
    .ina(neg_z_near),
    .inb(neg_z_far),
    .sub(1'b1),
    .out(distance),
    .overflow(overflow2)
);

// pseudocode: k = 1 / (zNear - zFar) 
fxp_div #(
    .WIIA(8), .WIFA(8),
    .WIIB(WOI), .WIFB(WOF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) div0 (
    .dividend(16'h0100),
    .divisor(distance),
    .out(k),
    .overflow(overflow3)
);

// n_a_f = z_near + z_far (already taken negative)
fxp_add #(
    .WIIA(WOI), .WIFA(WOF),
    .WIIB(WOI), .WIFB(WOF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) add0 (
    .ina(neg_z_near),
    .inb(neg_z_far),
    .out(n_a_f),
    .overflow(overflow4)
);

// n_a_f_mul_k = k * (z_near + z_far) (already taken negative)
fxp_mul #(
    .WIIA(WOI), .WIFA(WOF),
    .WIIB(WOI), .WIFB(WOF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul0 (
    .ina(n_a_f),
    .inb(k), 
    .out(n_a_f_mul_k),
    .overflow(overflow5)
);

// tmp = z_near * z_far (already taken negative)
fxp_mul #(
    .WIIA(WOI), .WIFA(WOF),
    .WIIB(WOI), .WIFB(WOF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul1 (
    .ina(neg_z_far),
    .inb(neg_z_near),
    .out(tmp),
    .overflow(overflow6)
);

// f_m_n_m_k = z_near * z_far * k (already taken negative)
fxp_mul #(
    .WIIA(WOI), .WIFA(WOF),
    .WIIB(WOI), .WIFB(WOF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul2 (
    .ina(tmp),
    .inb(k), 
    .out(f_m_n_m_k),
    .overflow(overflow7)
);

// f_m_n_m_k_2 = 2 * z_near * z_far * k (already taken negative)
fxp_mul #(
    .WIIA(WOI), .WIFA(WOF),
    .WIIB(8), .WIFB(8),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul3 (
    .ina(f_m_n_m_k),
    .inb(16'h0200),
    .out(f_m_n_m_k_2),
    .overflow(overflow8)
);

// t_d_a = inv_tan / aspect_ratio
fxp_div #(
    .WIIA(WII), .WIFA(WIF),
    .WIIB(WII), .WIFB(WIF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) div4 (
    .dividend(inv_tan),
    .divisor(aspect_ratio),
    .out(t_d_a),
    .overflow(overflow9)
);

// convert 0 to 1 to parametered digits
fxp_zoom # (
    .WII(8), .WIF(8),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) zoom0 (
    .in(16'h0000),
    .out(zero),
    .overflow(overflow10)
);
fxp_zoom # (
    .WII(8), .WIF(8),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) zoom1 (
    .in(16'h0100),
    .out(one),
    .overflow(overflow11)
);

// assign values to output matrix
assign projection_matrix[0] = t_d_a;
assign projection_matrix[1] = zero;
assign projection_matrix[2] = zero;
assign projection_matrix[3] = zero;

assign projection_matrix[4] = zero;
assign projection_matrix[5] = inv_tan;
assign projection_matrix[6] = zero;
assign projection_matrix[7] = zero;

assign projection_matrix[8] = zero;
assign projection_matrix[9] = zero;
assign projection_matrix[10] = n_a_f_mul_k;
assign projection_matrix[11] = f_m_n_m_k_2;

assign projection_matrix[12] = zero;
assign projection_matrix[13] = zero;
assign projection_matrix[14] = one;
assign projection_matrix[15] = zero;

endmodule

// some useful constants may be helpful in testbench:
// 3.1415926 = 00000011.00100100 = 0324
// 1.5707963 = 00000001.10010010 = 0192
// 180 * MY_PI * 0.5 = 0000000100011010.1011111001001011
//                   = 011a.be4b
