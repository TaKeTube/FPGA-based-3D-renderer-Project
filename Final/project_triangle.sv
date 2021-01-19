// project triangle
// vertex_a/b/c: original x, y, z homogeneous coordinates of triangle vertexes
// V1/2/3:       coordinates of the triangle after transformation, only x, y matters
module project_triangle #(
    // vertex_a, vertex_b, vertex_c, mvp_matrix
    parameter WIIA = 8,
    parameter WIFA = 8,
    // width, height
    parameter WIIB = 12,
    parameter WIFB = 0,
    // intermediate v1, v2, v3
    parameter WI = 12,
    parameter WF = 8,
    // output V1, V2, V3
    parameter WOI = 12,
    parameter WOF = 0
)
(       // original 3 vertexes
        input           [3:0][WIIA+WIFA-1:0]    vertex_a, vertex_b, vertex_c,
        // mvp matrix
        input           [15:0][WIIA+WIFA-1:0]   mvp,
        // width, height of the screen
        input           [WIIB+WIFB-1:0]         width, height,
        // vertexes of the projected triangle
        output logic    [1:0][WOI+WOF-1:0]      V1, V2, V3,
        // indicator of whether a point is out of the boundary of the screen
        output logic                            clip
);

// projected vertexes
logic [WIIA+WIFA-1:0] x1, y1, w1, x2, y2, w2, x3, y3, w3;
// normalized projected vertexes
logic [WIIA+WIFA-1:0] x1_normalized, y1_normalized, x2_normalized, y2_normalized, x3_normalized, y3_normalized;

// intermediate variables, which will be introduced later
logic [WIIA+WIFA-1:0] x1_add_1, x2_add_1, x3_add_1, y1_add_1, y2_add_1, y3_add_1;
logic [WI+WF-1:0] w_mul_x1_add_1, w_mul_x2_add_1, w_mul_x3_add_1, h_mul_y1_add_1, h_mul_y2_add_1, h_mul_y3_add_1;

// useless wire since this project contains no shading and thus z-coordinates ain't important
logic [WIIA+WIFA-1:0] trash0, trash1, trash2;
// overflow indicator, just ignore them
logic overflow0, overflow1, overflow2, overflow3, overflow4, overflow5, overflow6, overflow7;
logic overflow8, overflow9, overflow10, overflow11, overflow12, overflow13, overflow14, overflow15;
logic overflow16, overflow17, overflow18, overflow19, overflow20, overflow21, overflow22, overflow23;

// when a point is out of the screen, clip the triangle containing this point
assign clip =   (V1[0] > width) || (V1[0] < 0) || (V1[1] > height) || (V1[1] < 0) ||
                (V2[0] > width) || (V2[0] < 0) || (V2[1] > height) || (V2[1] < 0) ||
                (V3[0] > width) || (V3[0] < 0) || (V3[1] > height) || (V3[1] < 0);

// 3 matrix multiplication 4x4 matrix * 4x1 vector
dot_product #(.WII(WIIA), .WIF(WIFA), .WOI(WIIA), .WOF(WIIA)) dp00(.a0(mvp[0]), .a1(mvp[1]), .a2(mvp[2]), .a3(mvp[3]), .b0(vertex_a[0]), .b1(vertex_a[1]), .b2(vertex_a[2]), .b3(vertex_a[3]), .res(x1));
dot_product #(.WII(WIIA), .WIF(WIFA), .WOI(WIIA), .WOF(WIIA)) dp01(.a0(mvp[4]), .a1(mvp[5]), .a2(mvp[6]), .a3(mvp[7]), .b0(vertex_a[0]), .b1(vertex_a[1]), .b2(vertex_a[2]), .b3(vertex_a[3]), .res(y1));
dot_product #(.WII(WIIA), .WIF(WIFA), .WOI(WIIA), .WOF(WIIA)) dp02(.a0(mvp[8]), .a1(mvp[9]), .a2(mvp[10]), .a3(mvp[11]), .b0(vertex_a[0]), .b1(vertex_a[1]), .b2(vertex_a[2]), .b3(vertex_a[3]), .res(trash0));
dot_product #(.WII(WIIA), .WIF(WIFA), .WOI(WIIA), .WOF(WIIA)) dp03(.a0(mvp[12]), .a1(mvp[13]), .a2(mvp[14]), .a3(mvp[15]), .b0(vertex_a[0]), .b1(vertex_a[1]), .b2(vertex_a[2]), .b3(vertex_a[3]), .res(w1));

dot_product #(.WII(WIIA), .WIF(WIFA), .WOI(WIIA), .WOF(WIIA)) dp10(.a0(mvp[0]), .a1(mvp[1]), .a2(mvp[2]), .a3(mvp[3]), .b0(vertex_b[0]), .b1(vertex_b[1]), .b2(vertex_b[2]), .b3(vertex_b[3]), .res(x2));
dot_product #(.WII(WIIA), .WIF(WIFA), .WOI(WIIA), .WOF(WIIA)) dp11(.a0(mvp[4]), .a1(mvp[5]), .a2(mvp[6]), .a3(mvp[7]), .b0(vertex_b[0]), .b1(vertex_b[1]), .b2(vertex_b[2]), .b3(vertex_b[3]), .res(y2));
dot_product #(.WII(WIIA), .WIF(WIFA), .WOI(WIIA), .WOF(WIIA)) dp12(.a0(mvp[8]), .a1(mvp[9]), .a2(mvp[10]), .a3(mvp[11]), .b0(vertex_b[0]), .b1(vertex_b[1]), .b2(vertex_b[2]), .b3(vertex_b[3]), .res(trash1));
dot_product #(.WII(WIIA), .WIF(WIFA), .WOI(WIIA), .WOF(WIIA)) dp13(.a0(mvp[12]), .a1(mvp[13]), .a2(mvp[14]), .a3(mvp[15]), .b0(vertex_b[0]), .b1(vertex_b[1]), .b2(vertex_b[2]), .b3(vertex_b[3]), .res(w2));

dot_product #(.WII(WIIA), .WIF(WIFA), .WOI(WIIA), .WOF(WIIA)) dp20(.a0(mvp[0]), .a1(mvp[1]), .a2(mvp[2]), .a3(mvp[3]), .b0(vertex_c[0]), .b1(vertex_c[1]), .b2(vertex_c[2]), .b3(vertex_c[3]), .res(x3));
dot_product #(.WII(WIIA), .WIF(WIFA), .WOI(WIIA), .WOF(WIIA)) dp21(.a0(mvp[4]), .a1(mvp[5]), .a2(mvp[6]), .a3(mvp[7]), .b0(vertex_c[0]), .b1(vertex_c[1]), .b2(vertex_c[2]), .b3(vertex_c[3]), .res(y3));
dot_product #(.WII(WIIA), .WIF(WIFA), .WOI(WIIA), .WOF(WIIA)) dp22(.a0(mvp[8]), .a1(mvp[9]), .a2(mvp[10]), .a3(mvp[11]), .b0(vertex_c[0]), .b1(vertex_c[1]), .b2(vertex_c[2]), .b3(vertex_c[3]), .res(trash2));
dot_product #(.WII(WIIA), .WIF(WIFA), .WOI(WIIA), .WOF(WIIA)) dp23(.a0(mvp[12]), .a1(mvp[13]), .a2(mvp[14]), .a3(mvp[15]), .b0(vertex_c[0]), .b1(vertex_c[1]), .b2(vertex_c[2]), .b3(vertex_c[3]), .res(w3));

// normalization after projection, devide x,y,z,w by w (set w=1)
fxp_div #(
    .WIIA(WIIA), .WIFA(WIFA),
    .WIIB(WIIA), .WIFB(WIFA),
    .WOI(WIIA), .WOF(WIFA), .ROUND(1)
) div0 (.dividend(x1), .divisor(w1), .out(x1_normalized), .overflow(overflow0));
fxp_div #(
    .WIIA(WIIA), .WIFA(WIFA),
    .WIIB(WIIA), .WIFB(WIFA),
    .WOI(WIIA), .WOF(WIFA), .ROUND(1)
) div1 (.dividend(y1), .divisor(w1), .out(y1_normalized), .overflow(overflow1));
fxp_div #(
    .WIIA(WIIA), .WIFA(WIFA),
    .WIIB(WIIA), .WIFB(WIFA),
    .WOI(WIIA), .WOF(WIFA), .ROUND(1)
) div2 (.dividend(x2), .divisor(w2), .out(x2_normalized), .overflow(overflow2));
fxp_div #(
    .WIIA(WIIA), .WIFA(WIFA),
    .WIIB(WIIA), .WIFB(WIFA),
    .WOI(WIIA), .WOF(WIFA), .ROUND(1)
) div3 (.dividend(y2), .divisor(w2), .out(y2_normalized), .overflow(overflow3));
fxp_div #(
    .WIIA(WIIA), .WIFA(WIFA),
    .WIIB(WIIA), .WIFB(WIFA),
    .WOI(WIIA), .WOF(WIFA), .ROUND(1)
) div4 (.dividend(x3), .divisor(w3), .out(x3_normalized), .overflow(overflow4));
fxp_div #(
    .WIIA(WIIA), .WIFA(WIFA),
    .WIIB(WIIA), .WIFB(WIFA),
    .WOI(WIIA), .WOF(WIFA), .ROUND(1)
) div5 (.dividend(y3), .divisor(w3), .out(y3_normalized), .overflow(overflow5));

// for each x, y-coordinates of each vertex
// fit the screen
// pseudocode in cpp:
// vert.x() = 0.5*width*(vert.x()+1.0);
// vert.y() = 0.5*height*(vert.y()+1.0);
fxp_add #(
    .WIIA(WIIA), .WIFA(WIFA),
    .WIIB(8), .WIFB(8),
    .WOI(WIIA), .WOF(WIFA), .ROUND(1)
) add0 (.ina(x1_normalized), .inb(16'h0100), .out(x1_add_1), .overflow(overflow6));
fxp_mul #(
    .WIIA(WIIB), .WIFA(WIFB),
    .WIIB(WIIA), .WIFB(WIFA),
    .WOI(WI), .WOF(WF), .ROUND(1)
) mul0 (.ina(width), .inb(x1_add_1), .out(w_mul_x1_add_1), .overflow(overflow7));
fxp_div #(
    .WIIA(WI), .WIFA(WF),
    .WIIB(8), .WIFB(8),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) div6 (.dividend(w_mul_x1_add_1), .divisor(16'h0200), .out(V1[0]), .overflow(overflow8));


fxp_add #(
    .WIIA(WIIA), .WIFA(WIFA),
    .WIIB(8), .WIFB(8),
    .WOI(WIIA), .WOF(WIFA), .ROUND(1)
) add1 (.ina(y1_normalized), .inb(16'h0100), .out(y1_add_1), .overflow(overflow9));
fxp_mul #(
    .WIIA(WIIB), .WIFA(WIFB),
    .WIIB(WIIA), .WIFB(WIFA),
    .WOI(WI), .WOF(WF), .ROUND(1)
) mul2 (.ina(height), .inb(y1_add_1), .out(h_mul_y1_add_1), .overflow(overflow10));
fxp_div #(
    .WIIA(WI), .WIFA(WF),
    .WIIB(8), .WIFB(8),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) div7 (.dividend(h_mul_y1_add_1), .divisor(16'h0200), .out(V1[1]), .overflow(overflow11));

fxp_add #(
    .WIIA(WIIA), .WIFA(WIFA),
    .WIIB(8), .WIFB(8),
    .WOI(WIIA), .WOF(WIFA), .ROUND(1)
) add2 (.ina(x2_normalized), .inb(16'h0100), .out(x2_add_1), .overflow(overflow12));
fxp_mul #(
    .WIIA(WIIB), .WIFA(WIFB),
    .WIIB(WIIA), .WIFB(WIFA),
    .WOI(WI), .WOF(WF), .ROUND(1)
) mul4 (.ina(width), .inb(x2_add_1), .out(w_mul_x2_add_1), .overflow(overflow13));
fxp_div #(
    .WIIA(WI), .WIFA(WF),
    .WIIB(8), .WIFB(8),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) div8 (.dividend(w_mul_x2_add_1), .divisor(16'h0200), .out(V2[0]), .overflow(overflow14));


fxp_add #(
    .WIIA(WIIA), .WIFA(WIFA),
    .WIIB(8), .WIFB(8),
    .WOI(WIIA), .WOF(WIFA), .ROUND(1)
) add3 (.ina(y2_normalized), .inb(16'h0100), .out(y2_add_1), .overflow(overflow15));
fxp_mul #(
    .WIIA(WIIB), .WIFA(WIFB),
    .WIIB(WIIA), .WIFB(WIFA),
    .WOI(WI), .WOF(WF), .ROUND(1)
) mul6 (.ina(height), .inb(y2_add_1), .out(h_mul_y2_add_1), .overflow(overflow16));
fxp_div #(
    .WIIA(WI), .WIFA(WF),
    .WIIB(8), .WIFB(8),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) div9 (.dividend(h_mul_y2_add_1), .divisor(16'h0200), .out(V2[1]), .overflow(overflow17));


fxp_add #(
    .WIIA(WIIA), .WIFA(WIFA),
    .WIIB(8), .WIFB(8),
    .WOI(WIIA), .WOF(WIFA), .ROUND(1)
) add4 (.ina(x3_normalized), .inb(16'h0100), .out(x3_add_1), .overflow(overflow18));
fxp_mul #(
    .WIIA(WIIB), .WIFA(WIFB),
    .WIIB(WIIA), .WIFB(WIFA),
    .WOI(WI), .WOF(WF), .ROUND(1)
) mul8 (.ina(width), .inb(x3_add_1), .out(w_mul_x3_add_1), .overflow(overflow19));
fxp_div #(
    .WIIA(WI), .WIFA(WF),
    .WIIB(8), .WIFB(8),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) div10 (.dividend(w_mul_x3_add_1), .divisor(16'h0200), .out(V3[0]), .overflow(overflow20));


fxp_add #(
    .WIIA(WIIA), .WIFA(WIFA),
    .WIIB(8), .WIFB(8),
    .WOI(WIIA), .WOF(WIFA), .ROUND(1)
) add5 (.ina(y3_normalized), .inb(16'h0100), .out(y3_add_1), .overflow(overflow21));
fxp_mul #(
    .WIIA(WIIB), .WIFA(WIFB),
    .WIIB(WIIA), .WIFB(WIFA),
    .WOI(WI), .WOF(WF), .ROUND(1)
) mul10 (.ina(height), .inb(y3_add_1), .out(h_mul_y3_add_1), .overflow(overflow22));
fxp_div #(
    .WIIA(WI), .WIFA(WF),
    .WIIB(8), .WIFB(8),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) div11 (.dividend(h_mul_y3_add_1),.divisor(16'h0200), .out(V3[1]), .overflow(overflow23));

endmodule