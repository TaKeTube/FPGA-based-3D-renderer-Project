// generating signal to clear a frame
// by traversing every pixel in a frame
module clear_frame( input Clk, Reset, clear_frame_start,
                    output logic [9:0] DrawX, DrawY,
                    output logic clear_frame_done
);

    parameter [9:0] H_TOTAL = 10'd640;
    parameter [9:0] V_TOTAL = 10'd480;

    logic [9:0] h_counter, v_counter;
    logic [9:0] h_counter_in, v_counter_in;

    // Three states
    // Wait: wait to clear
    // Clear: clear the frame (generating signal traversing every pixel in a frame)
    // Done: clear done
    enum logic [1:0] {Wait, Clear, Done} curr_state, next_state;

    assign DrawX = h_counter;
    assign DrawY = v_counter;

    always_ff @(posedge Clk)
    begin
        if (Reset)
        begin
            curr_state <= Wait;
            h_counter <= 10'd0;
            v_counter <= 10'd0;
        end
        else
        begin
            curr_state <= next_state;
            h_counter <= h_counter_in;
            v_counter <= v_counter_in;
        end
    end

    always_comb
    begin
        next_state = curr_state;
        clear_frame_done = 1'b0;
        h_counter_in = h_counter;
        v_counter_in = v_counter;

        unique case (curr_state)
        Wait:
        begin
            if(clear_frame_start)
                next_state = Clear;
        end
        Clear:
        begin
            if(v_counter + 10'd1 == V_TOTAL && h_counter + 10'd1 == H_TOTAL)
                next_state = Done;
        end
        Done:
        begin
            if(clear_frame_start == 0)
                next_state = Wait;
        end
        endcase

        case (curr_state)
        Wait:
        begin
            h_counter_in = 10'd0;
            v_counter_in = 10'd0;
        end
        Clear:
        begin
            h_counter_in = h_counter + 10'd1;
            v_counter_in = v_counter;
            if(h_counter + 10'd1 == H_TOTAL)
            begin
                h_counter_in = 10'd0;
                if(v_counter + 10'd1 == V_TOTAL)
                    v_counter_in = 10'd0;
                else
                    v_counter_in = v_counter + 10'd1;
            end
        end
        Done:
        begin
            clear_frame_done = 1'b1;
        end
        endcase
    end

endmodule