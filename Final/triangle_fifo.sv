// custemed Triangle fifo
// Using On-chip memory
// Waddr:           width of addr
// size:            size of fifo
// triangle_in/out: packed triangle data (projected vertexes on the screen space)
//                  [2:0] --- 3 vertexes
//                  [1:0] --- x, y coordinates in screen space
//                  [9:0] --- 10 bits for each coordinates
module triangle_fifo # (
    parameter Waddr = 7,
    parameter size = 100
)
(
    input                        Clk,
    input                        Reset,
    input                        r_en, w_en,
    input        [2:0][1:0][9:0] triangle_in,
    output logic [2:0][1:0][9:0] triangle_out,
    output logic                 is_empty, is_full
);

logic [Waddr-1:0] r_addr,w_addr;
logic [Waddr-1:0] num;

parameter max = size;

// On-chip memory
triangle_fifo_ram #(.Waddr(Waddr), .size(size)) tfr (
    .Clk(Clk),
    .r_en(r_en), .w_en(w_en),
    .r_addr(r_addr),.w_addr(w_addr),
    .is_empty(is_empty),
    .is_full(is_full),
    .data_in(triangle_in),
    .data_out(triangle_out)
);

// use num instead of addr to indicate whether fifo is full/empty
assign is_full = (num == max) ? 1'b1 : 1'b0;
assign is_empty = (num == 0) ? 1'b1 : 1'b0;

//generate addr
always @(posedge Clk)
begin
    // generate read addr
    if (Reset)
        r_addr <= 0;
    else if(r_en && !is_empty)
        r_addr <= (r_addr + 1 == size) ? 0 : r_addr + 1;
    // generate write addr
    if (Reset)
        w_addr <= 0;
    else if(w_en && !is_full)
        w_addr <= (w_addr + 1 == size) ? 0 : w_addr + 1;
end

// count the number of elements
always @(posedge Clk)
begin
    if(Reset)
        num <= 0;
    else
    begin
        case({r_en,w_en})
            2'b00: num <= num;
            2'b01: if(num != max) num <= num + 1;
            2'b10: if(num != 0)   num <= num - 1;
            2'b11: num <= num;
            default: num <= num;
        endcase
    end
end

endmodule