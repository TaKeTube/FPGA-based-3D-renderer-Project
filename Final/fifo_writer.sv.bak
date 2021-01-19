module fifo_writer(
                    input Clk, Reset,
                    input clear_start,
                    output logic fifo_w,
                    output logic [2:0][1:0][9:0] proj_triangle_in
);

    enum logic [2:0] {Wait, Write1, Write2, Write3, Done} curr_state, next_state;

    logic [1:0][9:0] V1, V2, V3, new_V1, new_V2, new_V3;

    always_ff @(posedge Clk)
    begin
        if (Reset)
        begin
            curr_state <= Wait;
            V1 <= 0;
            V2 <= 0;
            V3 <= 0;
        end
        else
        begin
            curr_state <= next_state;
            V1 <= new_V1;
            V2 <= new_V2;
            V3 <= new_V3;
        end
    end

    always_comb
    begin
        next_state = curr_state;
        fifo_w = 1'b0;
        new_V1 = V1;
        new_V2 = V2;
        new_V3 = V3;
        proj_triangle_in = {V1, V2, V3};
        
        unique case (curr_state)
        Wait:
        begin
            if(clear_start)
                next_state = Write1;
        end
        Write1:
        begin
            next_state = Write2;
        end
        Write2:
        begin
            next_state = Write3;
        end
        Write3:
        begin
            next_state = Done;
        end
        Done:
        begin
            if(clear_start == 0)
                next_state = Wait;
        end
        endcase

        case (curr_state)
        Wait:
        begin
            new_V1[0] = 10'd30;
            new_V1[1] = 10'd40;
            new_V2[0] = 10'd40;
            new_V2[1] = 10'd20;
            new_V3[0] = 10'd20;
            new_V3[1] = 10'd60;
        end
        Write1:
        begin
            fifo_w = 1'b1;
            new_V1[0] = 10'd100;
            new_V1[1] = 10'd140;
            new_V2[0] = 10'd140;
            new_V2[1] = 10'd120;
            new_V3[0] = 10'd120;
            new_V3[1] = 10'd160;
        end
        Write2:
        begin
            fifo_w = 1'b1;
            new_V1[0] = 10'd200;
            new_V1[1] = 10'd240;
            new_V2[0] = 10'd240;
            new_V2[1] = 10'd220;
            new_V3[0] = 10'd220;
            new_V3[1] = 10'd260;
        end
        Write3:
        begin
            fifo_w = 1'b1;
        end
        Done:
        begin
        end
        endcase
    end

endmodule