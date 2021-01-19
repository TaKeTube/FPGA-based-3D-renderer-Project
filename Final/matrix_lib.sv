// vector dot product
// vectorA = (a0, a1, a2, a3); vectorB = (b0, b1, b2, b3)
// return vectorA * vectorB

module dot_product # (
    // fixed-point number parameter of the input vector a, b
    parameter WII = 8,
    parameter WIF = 8,
    // fixed-point number parameter of the output vector dot product
    parameter WOI = 8,
    parameter WOF = 8
)
(   // 4x1 vector a, 1x4 vector b
    input           [WII+WIF-1:0] a0, a1, a2, a3, b0, b1, b2, b3,
    // dot product
    output logic    [WOI+WOF-1:0] res
);

// intermediate variables, whose functions are indicated by their  names
logic [WOI+WOF-1:0] mul_res0, mul_res1, mul_res2, mul_res3;
logic [WOI+WOF-1:0] add_tmp0, add_tmp1;

// overflow indicator, just ignore them
logic mul_overflow0, mul_overflow1, mul_overflow2, mul_overflow3;
logic add_overflow0, add_overflow1, add_overflow2;

// a0*b0; a1*b1; a2*b2; a3*b3
fxp_mul #(   
    .WIIA(WII), .WIFA(WIF),
    .WIIB(WII), .WIFB(WIF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul0 (.ina(a0), .inb(b0), .out(mul_res0), .overflow(mul_overflow0));
fxp_mul #(   
    .WIIA(WII), .WIFA(WIF),
    .WIIB(WII), .WIFB(WIF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul1 (.ina(a1), .inb(b1), .out(mul_res1), .overflow(mul_overflow1));
fxp_mul #(   
    .WIIA(WII), .WIFA(WIF),
    .WIIB(WII), .WIFB(WIF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul2 (.ina(a2), .inb(b2), .out(mul_res2), .overflow(mul_overflow2));
fxp_mul #(   
    .WIIA(WII), .WIFA(WIF),
    .WIIB(WII), .WIFB(WIF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul3 (.ina(a3), .inb(b3), .out(mul_res3), .overflow(mul_overflow3));


// a0*b0 + a1*b1 + a2*b2 + a3*b3
fxp_add #(   
    .WIIA(WOI), .WIFA(WOF),
    .WIIB(WOI), .WIFB(WOF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) add0 (.ina(mul_res0), .inb(mul_res1), .out(add_tmp0), .overflow(add_overflow0));
fxp_add #(   
    .WIIA(WOI), .WIFA(WOF),
    .WIIB(WOI), .WIFB(WOF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) add1 (.ina(add_tmp0), .inb(mul_res2), .out(add_tmp1), .overflow(add_overflow1));
fxp_add #(   
    .WIIA(WOI), .WIFA(WOF),
    .WIIB(WOI), .WIFB(WOF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) add2 (.ina(add_tmp1), .inb(mul_res3), .out(res), .overflow(add_overflow2));

endmodule


// 4x4 fixed-point number matrix multiplication
// each fixed-point number is 16-bit
// a matrix 4x4, each 16-bit = 256-bit

// 16 x 16-bit matrix indices
// 0   1   2   3
// 4   5   6   7  
// 8   9   10  11
// 12  13  14  15

module matrix_multiplier # (
    // fixed-point number parameter of the input matrice A, B
    parameter WII = 8,
    parameter WIF = 8,
    // fixed-point number parameter of the output matrix
    parameter WOI = 8,
    parameter WOF = 8
)
(   // matrixA, matrixB
    input           [15:0][WII+WIF-1:0] matA, matB,
    // res_mat = matrixA * matrixB
    output logic    [15:0][WOI+WOF-1:0] res_mat
);

// 16 4x4 dot product in parallel
dot_product #(
    .WII(WII), .WIF(WIF), 
    .WOI(WOI), .WOF(WOF)
) dp0 (.a0(matA[0]), .a1(matA[1]), .a2(matA[2]), .a3(matA[3]), .b0(matB[0]), .b1(matB[4]), .b2(matB[8]), .b3(matB[12]), .res(res_mat[0]));
dot_product  #(
    .WII(WII), .WIF(WIF), 
    .WOI(WOI), .WOF(WOF)
) dp1 (.a0(matA[0]), .a1(matA[1]), .a2(matA[2]), .a3(matA[3]), .b0(matB[1]), .b1(matB[5]), .b2(matB[9]), .b3(matB[13]), .res(res_mat[1]));
dot_product #(
    .WII(WII), .WIF(WIF), 
    .WOI(WOI), .WOF(WOF)
) dp2 (.a0(matA[0]), .a1(matA[1]), .a2(matA[2]), .a3(matA[3]), .b0(matB[2]), .b1(matB[6]), .b2(matB[10]), .b3(matB[14]), .res(res_mat[2]));
dot_product #(
    .WII(WII), .WIF(WIF), 
    .WOI(WOI), .WOF(WOF)
) dp3 (.a0(matA[0]), .a1(matA[1]), .a2(matA[2]), .a3(matA[3]), .b0(matB[3]), .b1(matB[7]), .b2(matB[11]), .b3(matB[15]), .res(res_mat[3]));

dot_product #(
    .WII(WII), .WIF(WIF), 
    .WOI(WOI), .WOF(WOF)
) dp4 (.a0(matA[4]), .a1(matA[5]), .a2(matA[6]), .a3(matA[7]), .b0(matB[0]), .b1(matB[4]), .b2(matB[8]), .b3(matB[12]), .res(res_mat[4]));
dot_product #(
    .WII(WII), .WIF(WIF), 
    .WOI(WOI), .WOF(WOF)
) dp5 (.a0(matA[4]), .a1(matA[5]), .a2(matA[6]), .a3(matA[7]), .b0(matB[1]), .b1(matB[5]), .b2(matB[9]), .b3(matB[13]), .res(res_mat[5]));
dot_product #(
    .WII(WII), .WIF(WIF), 
    .WOI(WOI), .WOF(WOF)
) dp6 (.a0(matA[4]), .a1(matA[5]), .a2(matA[6]), .a3(matA[7]), .b0(matB[2]), .b1(matB[6]), .b2(matB[10]), .b3(matB[14]), .res(res_mat[6]));
dot_product #(
    .WII(WII), .WIF(WIF), 
    .WOI(WOI), .WOF(WOF)
) dp7 (.a0(matA[4]), .a1(matA[5]), .a2(matA[6]), .a3(matA[7]), .b0(matB[3]), .b1(matB[7]), .b2(matB[11]), .b3(matB[15]), .res(res_mat[7]));

dot_product #(
    .WII(WII), .WIF(WIF), 
    .WOI(WOI), .WOF(WOF)
) dp8 (.a0(matA[8]), .a1(matA[9]), .a2(matA[10]), .a3(matA[11]), .b0(matB[0]), .b1(matB[4]), .b2(matB[8]), .b3(matB[12]), .res(res_mat[8]));
dot_product #(
    .WII(WII), .WIF(WIF), 
    .WOI(WOI), .WOF(WOF)
) dp9 (.a0(matA[8]), .a1(matA[9]), .a2(matA[10]), .a3(matA[11]), .b0(matB[1]), .b1(matB[5]), .b2(matB[9]), .b3(matB[13]), .res(res_mat[9]));
dot_product #(
    .WII(WII), .WIF(WIF), 
    .WOI(WOI), .WOF(WOF)
) dp10 (.a0(matA[8]), .a1(matA[9]), .a2(matA[10]), .a3(matA[11]), .b0(matB[2]), .b1(matB[6]), .b2(matB[10]), .b3(matB[14]), .res(res_mat[10]));
dot_product #(
    .WII(WII), .WIF(WIF), 
    .WOI(WOI), .WOF(WOF)
) dp11 (.a0(matA[8]), .a1(matA[9]), .a2(matA[10]), .a3(matA[11]), .b0(matB[3]), .b1(matB[7]), .b2(matB[11]), .b3(matB[15]), .res(res_mat[11]));

dot_product #(
    .WII(WII), .WIF(WIF), 
    .WOI(WOI), .WOF(WOF)
) dp12 (.a0(matA[12]), .a1(matA[13]), .a2(matA[14]), .a3(matA[15]), .b0(matB[0]), .b1(matB[4]), .b2(matB[8]), .b3(matB[12]), .res(res_mat[12]));
dot_product #(
    .WII(WII), .WIF(WIF), 
    .WOI(WOI), .WOF(WOF)
) dp13 (.a0(matA[12]), .a1(matA[13]), .a2(matA[14]), .a3(matA[15]), .b0(matB[1]), .b1(matB[5]), .b2(matB[9]), .b3(matB[13]), .res(res_mat[13]));
dot_product #(
    .WII(WII), .WIF(WIF), 
    .WOI(WOI), .WOF(WOF)
) dp14 (.a0(matA[12]), .a1(matA[13]), .a2(matA[14]), .a3(matA[15]), .b0(matB[2]), .b1(matB[6]), .b2(matB[10]), .b3(matB[14]), .res(res_mat[14]));
dot_product #(
    .WII(WII), .WIF(WIF), 
    .WOI(WOI), .WOF(WOF)
) dp15 (.a0(matA[12]), .a1(matA[13]), .a2(matA[14]), .a3(matA[15]), .b0(matB[3]), .b1(matB[7]), .b2(matB[11]), .b3(matB[15]), .res(res_mat[15]));

endmodule

