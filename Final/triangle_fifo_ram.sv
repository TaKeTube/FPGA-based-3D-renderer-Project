// On-chip memeory fifo
// Waddr: width of addr
module triangle_fifo_ram # (
    parameter Waddr = 7,
    parameter size = 100
)
(
    input                   Clk,
    input                   r_en, w_en,
    input [Waddr-1:0]       r_addr,w_addr,
    input                   is_empty, is_full,
    input [6*10-1:0]        data_in,
    output logic [6*10-1:0] data_out
);

    reg [6*10-1:0] fifo [size-1:0];
    
    always @(posedge Clk)
    begin
        if(r_en && !is_empty)
            data_out<=fifo[r_addr];
    end
    always @(posedge Clk)
    begin
        if(w_en && !is_full)
            fifo[w_addr]<=data_in;
    end

endmodule