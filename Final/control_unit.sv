// control unit for the renderer
// ATTENTION: this module has 2 ways to use
//            way1: write triangles into list then read
//            way2: initial on-chip memory by txt file while being compiled then read
//            different ways need you to comment/uncomment some lines
module control_unit(input Clk,
                    input Reset,
                    input frame_clk,
                    input draw_done,
                    input clear_done,
                    input load_done,
                    input [9:0] draw_DrawX, draw_DrawY,
                    input [9:0] clear_DrawX, clear_DrawY,
                    output logic load_obj,
                    output logic draw_start,
                    output logic clear_start,
                    output logic proj_start,
                    output logic draw_data,
                    output logic [9:0] DrawX, DrawY,
                    output logic frame_clk_rising_edge,
                    output logic frame_done
);

    // Three States
    // Init: load the object (write triangles into triangle lists)
    // Clear: first clear the frame
    //        meanwhile, start project original triangles and write them into triangle fifo
    // Draw: then draw triangles
    // Done: wait until next frame is begin
    enum logic [1:0] {Init, Clear, Draw, Done} curr_state, next_state;

    logic frame_clk_delayed;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end

    always_ff @(posedge Clk)
    begin
        if (Reset)
            curr_state <= Init;
        else
            curr_state <= next_state;
    end

    always_comb
    begin
        next_state = curr_state;
        draw_start = 1'b0;
        clear_start = 1'b0;
        proj_start = 1'b0;
        draw_data = 1'b0;
        frame_done = 1'b0;
        DrawX = 10'b0;
        DrawY = 10'b0;
        load_obj = 1'b0;
        
        unique case (curr_state)
        Init:
        begin
            if(load_done) // way 1, comment this line when using txt to load model
                next_state = Done;
        end
        Clear:
        begin
            if(clear_done)
                next_state = Draw;
        end
        Draw:
        begin
            if(draw_done)
                next_state = Done;
        end
        // wait until next frame is coming
        Done:
        begin
            if(frame_clk_rising_edge)
                next_state = Clear;
        end
        endcase

        case (curr_state)
        Init:
        begin
            load_obj = 1'b1;
        end
        Clear:
        begin
            clear_start = 1'b1;
            proj_start = 1'b1;
            DrawX = clear_DrawX;
            DrawY = clear_DrawY;
        end
        Draw:
        begin
            draw_start = 1'b1;
            draw_data = 1'b1;
            DrawX = draw_DrawX;
            DrawY = draw_DrawY;
        end
        Done:
        begin
            frame_done = 1'b1;
        end
        endcase
    end

endmodule