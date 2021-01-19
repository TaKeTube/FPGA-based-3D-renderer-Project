// draw a triangle (only edges)
// draw_triangle_start:  trigger the drawing
// V1, V2, V3         :  coordinates of vertexes of the triangle. V[0] is x value, V[1] is y value
// DrawX, DrawY       :  coordinates of edge pixels in screen space
// draw_triangle_done :  high when drawing is done
module draw_triangle(   input Clk, Reset, draw_triangle_start,
                        input [1:0][9:0] V1, V2, V3,
                        output logic [9:0] DrawX, DrawY,
                        output logic draw_triangle_done
);

logic draw_line_start, draw_line_done;
logic [9:0] x0,x1,y0,y1;

// Five states
// Wait: wait to start
// Trigger1/2/3 : Trigger the drawing of one edge
// Draw1/2/3 : Drawing edges of the triangle using draw_line module
// Done: done, output done signal
enum logic [2:0] {Wait, Trigger1, Draw1, Trigger2, Draw2, Trigger3, Draw3, Done} curr_state, next_state;

// Drawing edges of the triangle using draw_line module
draw_line dl(.*);

always_ff @(posedge Clk)
begin
    if (Reset)
        curr_state <= Wait;
    else
        curr_state <= next_state;
end

always_comb
begin
    // default setting
    next_state = curr_state;
    draw_line_start = 1'b0;
    draw_triangle_done = 1'b0;
    x0 = 10'b0;
    x1 = 10'b0;
    y0 = 10'b0;
    y1 = 10'b0;
    
    // change state
    unique case (curr_state)
    Wait:
    begin
        if(draw_triangle_start)
            next_state = Trigger1;
    end
    Trigger1:
        next_state = Draw1;
    Draw1:
    begin
        if(draw_line_done)
            next_state = Trigger2;
    end
    Trigger2:
        next_state = Draw2;
    Draw2:
    begin
        if(draw_line_done)
            next_state = Trigger3;
    end
    Trigger3:
        next_state = Draw3;
    Draw3:
    begin
        if(draw_line_done)
            next_state = Done;
    end
    Done:
    begin
        if(draw_triangle_start == 0)
            next_state = Wait;
    end
    endcase
    
    // output logic
    case (curr_state)
    Wait:
    begin
    end
    Trigger1:
    begin
        draw_line_start = 1'b1;
        x0 = V1[0];
        x1 = V2[0];
        y0 = V1[1];
        y1 = V2[1];
    end
    Draw1:
    begin
        x0 = V1[0];
        x1 = V2[0];
        y0 = V1[1];
        y1 = V2[1];
    end
    Trigger2:
    begin
        draw_line_start = 1'b1;
        x0 = V2[0];
        x1 = V3[0];
        y0 = V2[1];
        y1 = V3[1];
    end
    Draw2:
    begin
        x0 = V2[0];
        x1 = V3[0];
        y0 = V2[1];
        y1 = V3[1];
    end
    Trigger3:
    begin
        draw_line_start = 1'b1;
        x0 = V3[0];
        x1 = V1[0];
        y0 = V3[1];
        y1 = V1[1];
    end
    Draw3:
    begin
        x0 = V3[0];
        x1 = V1[0];
        y0 = V3[1];
        y1 = V1[1];
    end
    Done:
        draw_triangle_done = 1'b1;
    endcase
end
endmodule