// using Bresenham line drawing algorithm to draw a line
// draw_line_start:  trigger the drawing
// x0,x1,y0,y1    :  coordinates of end points in screen space
// DrawX, DrawY   :  coordinates of line pixels in screen space
// draw_line_done :  high when drawing is done
module draw_line(   input Clk, draw_line_start, Reset,
                    input [9:0] x0,x1,y0,y1,
                    output logic [9:0] DrawX, DrawY,
                    output logic draw_line_done
);

logic [9:0] dx,dy,sx,sy,x,y,new_x,new_y;
logic signed [9:0] temp_err,err,new_err;

assign dx = (x1 > x0) ? (x1 - x0) : (x0 - x1);
assign dy = (y1 > y0) ? (y1 - y0) : (y0 - y1);
assign sx = (x0 < x1) ? 10'b1 : 10'b1111111111;
assign sy = (y0 < y1) ? 10'b1 : 10'b1111111111;
assign temp_err = (dx > dy ? dx : -dy);

// Three states
// Wait: wait to start
// Draw: draw pixel one by one, output the coordinate of the pixel
// Done: done, output done signal
enum logic [1:0] {Wait, Draw, Done} curr_state, next_state;

always_ff @(posedge Clk)
begin
    if (Reset) 
    begin
        curr_state <= Wait;
        err <= 10'b0;
        x <= 10'b0;
        y <= 10'b0;
    end
    else
    begin
        curr_state <= next_state;
        err <= new_err;
        x <= new_x;
        y <= new_y;
    end
end

always_comb
begin
    // default setting
    next_state = curr_state;
    new_err = err;
    new_x = x;
    new_y = y;
    DrawX = x;
    DrawY = y;
    draw_line_done = 1'b0;
    
    // change state
    unique case (curr_state)
    Wait:
    begin
        if(draw_line_start)
            next_state = Draw;
    end
    Draw:
    begin
        if((x != x1) || (y != y1))
            next_state = Draw;
        else
            next_state = Done;
    end
    Done:
    begin
        if(draw_line_start == 0)
            next_state = Wait;
    end
    endcase
    
    // output logic
    case (curr_state)
    Wait:
    begin
        new_x = x0;
        new_y = y0;
        new_err = temp_err >>> 1;
    end
    Draw:
    begin
        if(err >= $signed(dy))
        begin
            new_err = err - dy;
            new_x = x + sx;
        end
        else if(err <= -$signed(dx))
        begin
            new_err = err + dx;
            new_y = y + sy;
        end
        else
        begin
            new_err = err + dx - dy;
            new_x = x + sx;
            new_y = y + sy;
        end
    end
    Done:
    begin
        draw_line_done = 1'b1;
        DrawX = x1;
        DrawY = y1;
        new_x = x1;
        new_y = y1;
    end
    endcase
end
endmodule
