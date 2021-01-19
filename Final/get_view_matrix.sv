// calculate the view matrix in mvp transformation

// pseudocode in cpp:
// Eigen::Matrix4f get_view_matrix(Eigen::Vector3f eye_pos)
// {
//     Eigen::Matrix4f view = Eigen::Matrix4f::Identity();

//     Eigen::Matrix4f translate;
//     translate << 1, 0, 0, -eye_pos[0],
//                  0, 1, 0, -eye_pos[1],
//                  0, 0, 1, -eye_pos[2],
//                  0, 0, 0, 1          ;

//     view = translate * view;

//     return view;
// }

module get_view_matrix # (
    // parameter of the input fixed-point number
    // WII: integer bits
    // WIF: decimal bits
    parameter WII = 8,
    parameter WIF = 8,
    // parameter of the output fixed-point number
    // WOI: integer bits
    // WOF: decimal bits
    parameter WOI = 8,
    parameter WOF = 8
)
(   // the offset position in x, y, z -axises
    input           [WII+WIF-1:0]       x_pos, y_pos, z_pos,
    // view matrix
    output logic    [15:0][WOI+WOF-1:0] view_matrix
);

// overflow indicator, just ignore them
logic overflow0, overflow1, overflow2, overflow3, overflow4;
// intermediate variables, will be introduced in the following
logic [WOI+WOF-1:0] neg_x_pos, neg_y_pos, neg_z_pos;
// 0 and 1 with digits of the parametered fixed-point numbers
logic [WOI+WOF-1:0] zero, one;

// neg_x_pos = 0 - x_pos = -x_pos
fxp_addsub #(   
    .WIIA(8), .WIFA(8),
    .WIIB(WII), .WIFB(WIF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) ads0 (
    .ina(16'h0000), 
    .inb(x_pos), 
    .sub(1'b1), 
    .out(neg_x_pos), 
    .overflow(overflow0)
);

// neg_y_pos = 0 - y_pos = -y_pos
fxp_addsub #(   
    .WIIA(8), .WIFA(8),
    .WIIB(WII), .WIFB(WIF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) ads1 (
    .ina(16'h0000), 
    .inb(y_pos), 
    .sub(1'b1), 
    .out(neg_y_pos), 
    .overflow(overflow1)
);

// neg_z_pos = 0 - z_pos = -z_pos
fxp_addsub #(   
    .WIIA(8), .WIFA(8),
    .WIIB(WII), .WIFB(WIF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) ads2 (
    .ina(16'h0000), 
    .inb(z_pos), 
    .sub(1'b1), 
    .out(neg_z_pos), 
    .overflow(overflow2)
);

// convert 0 to 1 to parametered digits
fxp_zoom # (
    .WII(8), .WIF(8),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) zoom0 (
    .in(16'h0000),
    .out(zero),
    .overflow(overflow3)
);
fxp_zoom # (
    .WII(8), .WIF(8),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) zoom1 (
    .in(16'h0100),
    .out(one),
    .overflow(overflow4)
);

// assign values to output matrix
assign view_matrix[0] = one;
assign view_matrix[1] = zero;
assign view_matrix[2] = zero;
assign view_matrix[3] = neg_x_pos;

assign view_matrix[4] = zero;
assign view_matrix[5] = one;
assign view_matrix[6] = zero;
assign view_matrix[7] = neg_y_pos;

assign view_matrix[8] = zero;
assign view_matrix[9] = zero;
assign view_matrix[10] = one;
assign view_matrix[11] = neg_z_pos;

assign view_matrix[12] = zero;
assign view_matrix[13] = zero;
assign view_matrix[14] = zero;
assign view_matrix[15] = one;

endmodule
