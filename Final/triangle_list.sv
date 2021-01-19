// custemed Triangle list
// Using On-chip memory
// read traverse the list
//
// ATTENTION: this module has 2 ways to use
//            way1: write triangles into list then read
//            way2: initial on-chip memory by txt file while being compiled then read
//            different ways need you to comment/uncomment some lines
//
// WI:              width of integer of coordinate data
// WF:              width of float of coordinate data
// Waddr:           width of addr
// size:            size of list
// triangle_in/out: packed orignal triangle data (vertexes in 3D space)
//                  [2:0]       --- 3 vertexes
//                  [2:0]       --- x,y,z coordinates of vertex in 3D space
//                  [WI+WF-1:0] --- WI+WF bits one coordinate
// is_empty:        high when list is empty
// is_full:         high when list is full
// read_done:       high when one read is done (all triangle has been read)
module triangle_list # (
    parameter WI = 8,
    parameter WF = 8,
    parameter Waddr = 7,
    parameter size = 100
)
(
    input                                Clk,
    input                                Reset,
    input                                r_en, w_en,
    input [2:0][2:0][(WI+WF)-1:0]        triangle_in,
    output logic [2:0][2:0][(WI+WF)-1:0] triangle_out,
    output logic                         is_empty, is_full, read_done
);

logic [Waddr-1:0] r_addr,w_addr;
logic [Waddr-1:0] num;

parameter max = size;
// way2: initialized triangle number
// parameter triangle_num = 7'd36; // way2

// On-chip memory
triangle_list_ram #(.WI(WI), .WF(WF), .Waddr(Waddr), .size(size)) tlr (
    .Clk(Clk),
    .r_en(r_en), .w_en(w_en),
    .r_addr(r_addr),.w_addr(w_addr),
    .is_empty(is_empty),
    .is_full(is_full),
    .data_in(triangle_in),
    .data_out(triangle_out)
);

assign is_full = (num == max) ? 1'b1 : 1'b0;
assign is_empty = (num == 0) ? 1'b1 : 1'b0;

//generate addr
always @(posedge Clk)
begin
    // generate read addr
    if(Reset)
        r_addr <= 1;
    // when read done, r_addr go to 0 (unused addr to indicate read_done)
    else if(r_en && !is_empty)
        r_addr <= (r_addr == num) ? 0 : r_addr + 1;
    else if(r_addr == 0)
        r_addr <= 1;
    // generate write addr
    if(Reset)
        w_addr <= 1;             // way1
        // w_addr <= triangle_num;  // way2
    else if(w_en && !is_full)
        w_addr <= (w_addr == size) ? 1 : w_addr + 1;
end

// count the number of elements
always @(posedge Clk)
begin
    if(Reset)
        num <= 0;            // way1
        // num <= triangle_num; // way2
    else if(w_en)
    begin
        if(num != max)
            num <= num + 1;
    end
end

// output a signal when read is done
always_comb
begin
    read_done = 1'b0;
    if(r_addr == 0)
        read_done = 1'b1;
end

endmodule