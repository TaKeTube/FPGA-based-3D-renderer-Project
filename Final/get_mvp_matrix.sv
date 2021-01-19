// get the MVP matrix by matrix multiplications
module get_mvp_matrix # (
    // parameter of input matrix
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
(
    // three models needed: model matrix, view matrix and projection matrix
    input           [15:0][WII+WIF-1:0] model_matrix, view_matrix, projection_matrix,
    // mvp transformation finished, mvp matrix
    output logic    [15:0][WOI+WOF-1:0] mvp_matrix
);

// intermediate matrix, which equals projection_matrix * view_matrix
logic [15:0][WOI+WOF-1:0]   tmp_mvp;

// calculate projection_matrix * view_matrix
matrix_multiplier # (
    .WII(WII), 
    .WIF(WIF),
    .WOI(WOI), 
    .WOF(WOF)
) mm0 (
    .matA(projection_matrix),
    .matB(view_matrix),
    .res_mat(tmp_mvp)
);

// then calculate projection_matrix * view_matrix * model_matrix
matrix_multiplier # (
    .WII(WII), 
    .WIF(WIF),
    .WOI(WOI), 
    .WOF(WOF)
) mm1 (
    .matA(tmp_mvp),
    .matB(model_matrix),
    .res_mat(mvp_matrix)
);

endmodule