module project_cal_testbench();

timeunit 10ns;
timeprecision 1ns;

parameter WI = 8;
parameter WF = 8;
parameter WIIA = 4;
parameter WIFA = 8;

logic Clk;
logic [2:0][2:0][WI+WF-1:0]  orig_triangle;
logic [WIIA+WIFA-1:0]        angle;
logic [2:0][1:0][9:0] 		proj_triangle;
logic [2:0][WI+WF-1:0]      P1, P2, P3, P4, P5, P6, P7, P8;
logic [15:0][WIIA+WIFA-1:0]   mvp;
logic [15:0][WI+WF-1:0] m, v, p, pv;

project_cal#(.WIIA(WIIA), .WIFA(WIFA), .WI(WI), .WF(WF)) pc (
                                                                .orig_triangle(orig_triangle),
                                                                .angle(angle),
                                                                .proj_triangle(proj_triangle)
);

assign mvp = pc.mvp.mvp_matrix;
assign m = pc.mvp.model_matrix;
assign v = pc.mvp.view_matrix;
assign p = pc.mvp.projection_matrix;
assign pv = pc.mvp.tmp_mvp;
assign angle = 12'h086;
assign P1 = 60'h000000000000;
assign P2 = 60'h000000000100;
assign P3 = 60'h000001000000;
assign P4 = 60'h000001000100;
assign P5 = 60'h010000000000;
assign P6 = 60'h010000000100;
assign P7 = 60'h010001000000;
assign P8 = 60'h010001000100;

always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end 

initial begin: TEST_VECTORS

#2

#2 orig_triangle = {P1, P2, P3};

    $display("mvp_matrix");
    $display($signed(mvp[0])*1.0/(1<<8));
    $display($signed(mvp[1])*1.0/(1<<8));
    $display($signed(mvp[2])*1.0/(1<<8));
    $display($signed(mvp[3])*1.0/(1<<8));
    $display($signed(mvp[4])*1.0/(1<<8));
    $display($signed(mvp[5])*1.0/(1<<8));
    $display($signed(mvp[6])*1.0/(1<<8));
    $display($signed(mvp[7])*1.0/(1<<8));
    $display($signed(mvp[8])*1.0/(1<<8));
    $display($signed(mvp[9])*1.0/(1<<8));
    $display($signed(mvp[10])*1.0/(1<<8));
    $display($signed(mvp[11])*1.0/(1<<8));
    $display($signed(mvp[12])*1.0/(1<<8));
    $display($signed(mvp[13])*1.0/(1<<8));
    $display($signed(mvp[14])*1.0/(1<<8));
    $display($signed(mvp[15])*1.0/(1<<8));

    $display("m_matrix");
    $display($signed(m[0])*1.0/(1<<8));
    $display($signed(m[1])*1.0/(1<<8));
    $display($signed(m[2])*1.0/(1<<8));
    $display($signed(m[3])*1.0/(1<<8));
    $display($signed(m[4])*1.0/(1<<8));
    $display($signed(m[5])*1.0/(1<<8));
    $display($signed(m[6])*1.0/(1<<8));
    $display($signed(m[7])*1.0/(1<<8));
    $display($signed(m[8])*1.0/(1<<8));
    $display($signed(m[9])*1.0/(1<<8));
    $display($signed(m[10])*1.0/(1<<8));
    $display($signed(m[11])*1.0/(1<<8));
    $display($signed(m[12])*1.0/(1<<8));
    $display($signed(m[13])*1.0/(1<<8));
    $display($signed(m[14])*1.0/(1<<8));
    $display($signed(m[15])*1.0/(1<<8));

    $display("v_matrix");
    $display($signed(v[0])*1.0/(1<<8));
    $display($signed(v[1])*1.0/(1<<8));
    $display($signed(v[2])*1.0/(1<<8));
    $display($signed(v[3])*1.0/(1<<8));
    $display($signed(v[4])*1.0/(1<<8));
    $display($signed(v[5])*1.0/(1<<8));
    $display($signed(v[6])*1.0/(1<<8));
    $display($signed(v[7])*1.0/(1<<8));
    $display($signed(v[8])*1.0/(1<<8));
    $display($signed(v[9])*1.0/(1<<8));
    $display($signed(v[10])*1.0/(1<<8));
    $display($signed(v[11])*1.0/(1<<8));
    $display($signed(v[12])*1.0/(1<<8));
    $display($signed(v[13])*1.0/(1<<8));
    $display($signed(v[14])*1.0/(1<<8));
    $display($signed(v[15])*1.0/(1<<8));

    $display("p_matrix");
    $display($signed(p[0])*1.0/(1<<8));
    $display($signed(p[1])*1.0/(1<<8));
    $display($signed(p[2])*1.0/(1<<8));
    $display($signed(p[3])*1.0/(1<<8));
    $display($signed(p[4])*1.0/(1<<8));
    $display($signed(p[5])*1.0/(1<<8));
    $display($signed(p[6])*1.0/(1<<8));
    $display($signed(p[7])*1.0/(1<<8));
    $display($signed(p[8])*1.0/(1<<8));
    $display($signed(p[9])*1.0/(1<<8));
    $display($signed(p[10])*1.0/(1<<8));
    $display($signed(p[11])*1.0/(1<<8));
    $display($signed(p[12])*1.0/(1<<8));
    $display($signed(p[13])*1.0/(1<<8));
    $display($signed(p[14])*1.0/(1<<8));
    $display($signed(p[15])*1.0/(1<<8));

    $display("pv_matrix");
    $display($signed(pv[0])*1.0/(1<<8));
    $display($signed(pv[1])*1.0/(1<<8));
    $display($signed(pv[2])*1.0/(1<<8));
    $display($signed(pv[3])*1.0/(1<<8));
    $display($signed(pv[4])*1.0/(1<<8));
    $display($signed(pv[5])*1.0/(1<<8));
    $display($signed(pv[6])*1.0/(1<<8));
    $display($signed(pv[7])*1.0/(1<<8));
    $display($signed(pv[8])*1.0/(1<<8));
    $display($signed(pv[9])*1.0/(1<<8));
    $display($signed(pv[10])*1.0/(1<<8));
    $display($signed(pv[11])*1.0/(1<<8));
    $display($signed(pv[12])*1.0/(1<<8));
    $display($signed(pv[13])*1.0/(1<<8));
    $display($signed(pv[14])*1.0/(1<<8));
    $display($signed(pv[15])*1.0/(1<<8));

end
endmodule