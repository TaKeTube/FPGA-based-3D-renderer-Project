// On-chip memory frame buffer
// using 2-buffer (ping-pong method)
// keep the frame if drawing does not finished
module frame_buffer
(
    input Clk,
    input Reset,
    input frame_clk_rising_edge,
    input [9:0] DrawX, DrawY,       // coordinates of drawing
    input draw_data,
    input frame_done,               // high when drawing for a frame is finished
    input [9:0] ReadX, ReadY,       // coordinates of reading
    output logic read_data
);

    logic rw, new_rw;               // read/write switch
    logic w_en1, w_en2;             // write enable
    logic [9:0] rx,ry;              // valid ReadX, ReadY (less than 639/479)
    logic [18:0] w_addr, r_addr;    // write/read addr
    logic [18:0] addr1, addr2;      // buffer addr
    logic read_data1, read_data2;   // buffer read data
    
    ram buffer1(.address(addr1),
                .clock(Clk),
                .data(draw_data),
                .wren(w_en1),
                .q(read_data1)
    );
    
    ram buffer2(.address(addr2),
                .clock(Clk),
                .data(draw_data),
                .wren(w_en2),
                .q(read_data2)
    );
    
    // switch frame
    always_ff @ (posedge Clk)
    begin
        if (Reset) 
            rw <= 1'b0;
        else
            rw <= new_rw;
    end

    always_ff @ (posedge Clk)
    begin
        if (rw)
            // write buffer 1, read buffer 2
            begin
            addr2 <= r_addr;
            read_data <= read_data2;
            addr1 <= w_addr;
            end
        else
            // write buffer 2, read buffer 1
            begin
            addr1 <= r_addr;
            read_data <= read_data1;
            addr2 <= w_addr;
            end
    end
    
    always_comb
    begin
        new_rw = rw;
        w_en1 = 1'b0;
        w_en2 = 1'b0;
        ry = (ReadY > 10'd479) ? 10'd479 : ReadY;
        rx = (ReadX > 10'd639) ? 10'd639 : ReadX;
        w_addr = DrawX + DrawY * 10'd640;
        r_addr = rx + ry * 10'd640;
        
        if(rw)
            w_en1 = 1'b1;
        else
            w_en2 = 1'b1;

        // keep the same frame if drawing does not finish
        if(frame_clk_rising_edge && frame_done)
            new_rw = !rw;
    end

endmodule
