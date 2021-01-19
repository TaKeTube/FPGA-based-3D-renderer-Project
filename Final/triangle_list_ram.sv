// On-chip memeory list
// ATTENTION: this module has 2 ways to use
//            way1: write triangles into list then read
//            way2: initial on-chip memory by txt file while compiled then read
//            different ways need you to comment/uncomment some lines
// WI:          width of integer of coordinate data
// WF:          width of float of coordinate data
// Waddr:       width of addr
// size:        size of list
// data_in/out: packed orignal triangle data (vertexes in 3D space)
//              [2:0]       --- 3 vertexes
//              [2:0]       --- x,y,z coordinates of vertex in 3D space
//              [WI+WF-1:0] --- WI+WF bits one coordinate
module triangle_list_ram # (
    parameter WI = 8,
    parameter WF = 8,
    parameter Waddr = 7,
    parameter size = 100
)
(
    input                        Clk,
    input                        r_en, w_en,
    input [Waddr-1:0]            r_addr,w_addr,
    input                        is_empty, is_full,
    input [(WI+WF)*9-1:0]        data_in,
    output logic [(WI+WF)*9-1:0] data_out
);

    reg [(WI+WF)*9-1:0] list [size:0];
    
    // way2: initialize list using txt file
    // initial
    // begin
    //     // file path
    //     $readmemh("./dodecahedron.txt", list);
    // end

    always @(posedge Clk)
    begin
        if(r_en && !is_empty)
            data_out<=list[r_addr];
    end
    always @(posedge Clk)
    begin
        if(w_en && !is_full)
            list[w_addr]<=data_in;
    end

endmodule