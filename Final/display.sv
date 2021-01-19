// control the motion of the object and camera
// keycode:             keycode input by the use
// alpha, beta, gamma:  angles in euler angle matrix
// x, y, z:             translate of the object in model matrix
module  display #(
                    parameter WI = 8,
                    parameter WF = 8
)
(                   input                    Clk, Reset, frame_clk_rising_edge,
                    input        [7:0]       keycode,
                    // fixed-point number 4+8=12-bit
                    output logic [11:0]      alpha, beta, gamma,
                    output logic [WI+WF-1:0] x, y, z
);

    parameter [WI+WF-1:0] x_step = {{(WI){1'b0}},4'h2,{(WF-4){1'b0}}};
    parameter [WI+WF-1:0] y_step = {{(WI){1'b0}},4'h2,{(WF-4){1'b0}}};
    parameter [WI+WF-1:0] z_step = {{(WI){1'b0}},4'h2,{(WF-4){1'b0}}};
    parameter [11:0]      angle_v_max = 12'h020;
    parameter [11:0]      angle_friction = 12'h001;
    parameter [11:0]      angle_a = 12'h002;

    // angle along x/y/z-axis (in local coordinate of the object)
    logic [WI+WF-1:0] x_pos, y_pos, z_pos, x_pos_in, y_pos_in, z_pos_in;
    logic [11:0] x_angle, x_angle_in, x_angle_v, x_angle_v_in;
    logic [11:0] y_angle, y_angle_in, y_angle_v, y_angle_v_in;
    logic [11:0] z_angle, z_angle_in, z_angle_v, z_angle_v_in;
    
    // assign output signal
    assign x = x_pos;
    assign y = y_pos;
    assign z = z_pos;
    assign alpha = x_angle;
    assign beta = y_angle;
    assign gamma = z_angle;

    // Update registers
    always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
            x_angle <= 12'h000;
            y_angle <= 12'h000;
            z_angle <= 12'h000;
            x_angle_v <= 0;
            y_angle_v <= 0;
            z_angle_v <= 0;
            x_pos <= 0;
            y_pos <= 0;
            z_pos <= {{(WI-4){1'b1}},4'h8,{(WF){1'b0}}};
        end
        else
        begin
            x_angle <= x_angle_in;
            y_angle <= y_angle_in;
            z_angle <= z_angle_in;
            x_angle_v <= x_angle_v_in;
            y_angle_v <= y_angle_v_in;
            z_angle_v <= z_angle_v_in;
            x_pos <= x_pos_in;
            y_pos <= y_pos_in;
            z_pos <= z_pos_in;
        end
    end

    always_comb
    begin
        // By default, keep motion and position unchanged
        x_angle_in = x_angle;
        y_angle_in = y_angle;
        z_angle_in = z_angle;
        x_angle_v_in = x_angle_v;
        y_angle_v_in = y_angle_v;
        z_angle_v_in = z_angle_v;
        x_pos_in = x_pos;
        y_pos_in = y_pos;
        z_pos_in = z_pos;

        // Update angle only at rising edge of frame clock
        if (frame_clk_rising_edge)
        begin
            // 2*pi = 6.2831852 = 6.487ed344b6128
            // x-axis angle logic
            if ( $signed(x_angle + x_angle_v) >= $signed(12'h648) )
                x_angle_in = x_angle + x_angle_v - 12'h648;
            else if ( $signed(x_angle + x_angle_v) <= 0)
                x_angle_in = x_angle + x_angle_v + 12'h648;
            else
                x_angle_in = x_angle + x_angle_v;

            // y-axis-angle logic
            if ( $signed(y_angle + y_angle_v) >= $signed(12'h648) )
                y_angle_in = y_angle + y_angle_v - 12'h648;
            else if ( $signed(y_angle + y_angle_v) <= 0)
                y_angle_in = y_angle + y_angle_v + 12'h648;
            else
                y_angle_in = y_angle + y_angle_v;

            // z-axis-angle logic
            if ( $signed(z_angle + z_angle_v) >= $signed(12'h648) )
                z_angle_in = z_angle + z_angle_v - 12'h648;
            else if ( $signed(z_angle + z_angle_v) <= 0)
                z_angle_in = z_angle + z_angle_v + 12'h648;
            else
                z_angle_in = z_angle + z_angle_v;

            unique case(keycode)
            // rotate the object
            // w
            8'h1A:
            begin
                if ( y_angle_v + angle_a > angle_v_max )
                    y_angle_v_in = angle_v_max;
                else
                    y_angle_v_in = y_angle_v + angle_a;
            end
            // s
            8'h16:
            begin
                if ($signed(y_angle_v - angle_a) < $signed(-angle_v_max))
                    y_angle_v_in = -angle_v_max;
                else
                    y_angle_v_in = y_angle_v - angle_a;
            end
            // a
            8'h04:
            begin
                if ( z_angle_v + angle_a > angle_v_max )
                    z_angle_v_in = angle_v_max;
                else
                    z_angle_v_in = z_angle_v + angle_a;
            end
            // d
            8'h07:
            begin
                if ($signed(z_angle_v + angle_v_max) < $signed(angle_a))
                    z_angle_v_in = -angle_v_max;
                else
                    z_angle_v_in = z_angle_v - angle_a;
            end
            // q
            8'h14:
            begin
                if ( x_angle_v + angle_a > angle_v_max )
                    x_angle_v_in = angle_v_max;
                else
                    x_angle_v_in = x_angle_v + angle_a;
            end
            // e
            8'h08:
            begin
                if ($signed(x_angle_v + angle_v_max) < $signed(angle_a))
                    x_angle_v_in = -angle_v_max;
                else
                    x_angle_v_in = x_angle_v - angle_a;
            end
            // move the camera
            // up
            // go ahead
            8'h52:
            begin
                z_pos_in = z_pos + z_step;
            end
            // down
            // go back
            8'h51:
            begin
                z_pos_in = z_pos - z_step;
            end
            // left
            // go left
            8'h50:
            begin
                x_pos_in = x_pos - x_step;
            end
            // right
            // go right
            8'h4f:
            begin
                x_pos_in = x_pos + x_step;
            end
            // z
            // descend
            8'h1d:
            begin
                y_pos_in = y_pos + y_step;
            end
            // x
            // rise up
            8'h1b:
            begin
                y_pos_in = y_pos - y_step;
            end
            default:
            begin
                // x friction
                if (x_angle_v < angle_friction && $signed(x_angle_v) > $signed(-angle_friction))
                    x_angle_v_in = 0;
                else
                    x_angle_v_in = ($signed(x_angle_v) > 0) ? (x_angle_v - angle_friction) : (x_angle_v + angle_friction);
                // y friction
                if (y_angle_v < angle_friction && $signed(y_angle_v) > $signed(-angle_friction))
                    y_angle_v_in = 0;
                else
                    y_angle_v_in = ($signed(y_angle_v) > 0) ? (y_angle_v - angle_friction) : (y_angle_v + angle_friction);
                // z friction
                if (z_angle_v < angle_friction && $signed(z_angle_v) > $signed(-angle_friction))
                    z_angle_v_in = 0;
                else
                    z_angle_v_in = ($signed(z_angle_v) > 0) ? (z_angle_v - angle_friction) : (z_angle_v + angle_friction);
            end
            endcase
        end
    end
    
endmodule
