// projecting calculation
// calculate mvp matrix, then project triangles
// WIIA:               angle's integer bits
// WIFA:               angle's decimal bits
// WI:                 integer bits
// WF:                 decimal bits
// orig_triangle:      packed orignal triangle data (vertexes in 3D space)
//                     [2:0]       --- 3 vertexes
//                     [2:0]       --- x,y,z coordinates of vertex in 3D space
//                     [WI+WF-1:0] --- WI+WF bits one coordinate
// alpha, beta, gamma: angles in euler angle matrix
// x/y/z_translate:    translate of the object in model matrix
// proj_triangle:      packed projected triangle data (projected vertexes in screen space)
//                     [2:0] --- 3 vertexes
//                     [1:0] --- x, y coordinates in screen space
//                     [9:0] --- 10 bits for each coordinates
// clip:               indicator of whether a point is out of the boundary of the screen
module project_cal#(
                    parameter WIIA = 4,
                    parameter WIFA = 8,
                    parameter WI = 8,
                    parameter WF = 8
)
(
                    input [2:0][2:0][WI+WF-1:0]  orig_triangle,
                    input [WIIA+WIFA-1:0]        alpha, beta, gamma,
                    input [WI+WF-1:0]            x_translate, y_translate, z_translate,
                    output logic [2:0][1:0][9:0] proj_triangle,
                    output logic                 clip
);

// model matrix
logic [15:0][WI+WF-1:0] model_matrix;
// view matrix
logic [15:0][WI+WF-1:0] view_matrix;
// projection matrix
logic [15:0][WI+WF-1:0] projection_matrix;
// mvp matrix
logic [15:0][WI+WF-1:0] mvp_matrix;

// vertexes with digits of the parametered fixed-point numbers
logic [3:0][WI+WF-1:0]  vertex_a, vertex_b, vertex_c;
// output projected vertexes
logic [1:0][11:0]       V1, V2, V3;

// height, width of the screen
logic [11:0]            width, height;
// other parameters used in get_model_matrix
logic [WI+WF-1:0]       scale;
// other parameters used in get_view_matrix.sv
logic [WI+WF-1:0]       x_pos, y_pos, z_pos;
// other parameters used in get_projection_matrix
logic [WI+WF-1:0]       inv_tan, aspect_ratio, z_near, z_far;

// convert original vertexes in 3D coordinates to homogeneous coordinates 
// with digits of the parametered fixed-point numbers
assign vertex_a = {{{(WI-1){1'b0}},1'b1,{WF{1'b0}}}, orig_triangle[0]};
assign vertex_b = {{{(WI-1){1'b0}},1'b1,{WF{1'b0}}}, orig_triangle[1]};
assign vertex_c = {{{(WI-1){1'b0}},1'b1,{WF{1'b0}}}, orig_triangle[2]};

assign proj_triangle = {{V1[1][9:0],V1[0][9:0]}, {V2[1][9:0],V2[0][9:0]}, {V3[1][9:0],V3[0][9:0]}};

// parameter setted for 16 bits data (8 integer/8 decimal)
assign width = 12'd640;         // width of screen
assign height = 12'd480;        // height of screen
assign scale = 16'h0180;        // scale of object (in model matrix)
assign x_pos = 16'h0000;        // x position of camera
assign y_pos = 16'h0000;        // y position of camera
assign z_pos = 16'h0a00;        // z position of camera
assign inv_tan = 16'h026a;      // 1 / tan(eye_fov / 180 * pi * 0.5), eye_fov is field of view
assign aspect_ratio = 16'h0155; // aspect ratio, screen width/height
assign z_near = 16'h001a;       // near z of the frustum
assign z_far = 16'h3200;        // far z of the frustum

// parameter setted for 24 bits data (16 integer/8 decimal)
// assign width = 12'd640;
// assign height = 12'd480;
// //assign scale = 20'h00180;
// assign scale = 24'h000100;
// assign x_pos = 24'h000000;
// assign y_pos = 24'h000000;
// assign z_pos = 24'h000a00;
// assign inv_tan = 24'h00026a;
// assign aspect_ratio = 24'h000100;
// assign z_near = 24'h00001a;
// assign z_far = 24'h003200;

// parameter setted for 28 bits data (20 integer/8 decimal)
// assign width = 12'd640;
// assign height = 12'd480;
// assign scale = 28'h0000180;
// assign x_pos = 28'h0000000;
// assign y_pos = 28'h0000000;
// assign z_pos = 28'h0000a00;
// assign inv_tan = 28'h000026a;
// assign aspect_ratio = 28'h0000100;
// assign z_near = 28'h000001a;
// assign z_far = 28'h0003200;

// calculate model matrix
get_model_matrix #(
                    .WIIA(WIIA), .WIFA(WIFA),
                    .WIIB(WI), .WIFB(WF),
                    .WOIA(2), .WOFA(12),
                    .WOI(WI), .WOF(WF)
) get_model (
            .alpha(alpha),
            .beta(beta),
            .gamma(gamma),
            .scale(scale),
            .x_translate(x_translate),
            .y_translate(y_translate),
            .z_translate(z_translate),
            .model_matrix(model_matrix)
);

// calculate view matrix
get_view_matrix #(
                    .WII(WI),
                    .WIF(WF),
                    .WOI(WI),
                    .WOF(WF)
) get_view (
            .x_pos(x_pos),
            .y_pos(y_pos),
            .z_pos(z_pos),
            .view_matrix(view_matrix)
);

// calculate projection matrix
get_projection_matrix #(
                        .WII(WI),
                        .WIF(WF),
                        .WOI(WI),
                        .WOF(WF)
) get_proj (
            .inv_tan(inv_tan),
            .aspect_ratio(aspect_ratio),
            .z_near(z_near),
            .z_far(z_far),
            .projection_matrix(projection_matrix)
);

// then multiply them all to obtain mvp matrix
get_mvp_matrix #(
                    .WII(WI),
                    .WIF(WF),
                    .WOI(WI),
                    .WOF(WF)
) mvp (
        .model_matrix(model_matrix),
        .view_matrix(view_matrix),
        .projection_matrix(projection_matrix),
        .mvp_matrix(mvp_matrix)
);

// start projecting !
project_triangle #(
            .WIIA(WI),
            .WIFA(WF),
            .WIIB(12),
            .WIFB(0),
            .WOI(12),
            .WOF(0)
) proj (
        .vertex_a(vertex_a),
        .vertex_b(vertex_b),
        .vertex_c(vertex_c),
        .mvp(mvp_matrix),
        .width(width),
        .height(height),
        .V1(V1),
        .V2(V2),
        .V3(V3),
        .clip(clip)
);

endmodule
