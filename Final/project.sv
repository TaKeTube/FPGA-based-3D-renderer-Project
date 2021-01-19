// project original triangles (vertexes) in 3D space into 2D screen space
// WIIA:               angle's integer bits
// WIFA:               angle's decimal bits
// WI:                 integer bits
// WF:                 decimal bits
// proj_start:         high when start to project
// orig_triangle:      packed orignal triangle data (vertexes in 3D space)
//                     [2:0]       --- 3 vertexes
//                     [2:0]       --- x,y,z coordinates of vertex in 3D space
//                     [WI+WF-1:0] --- WI+WF bits one coordinate
// alpha, beta, gamma: angles in euler angle matrix
// x/y/z_translate:    translate of the object in model matrix
// list_read_done:     indicate whether all original triangles in triangle list has been read,
//                     high when done
// proj_triangle:      packed projected triangle data (projected vertexes in screen space)
//                     [2:0] --- 3 vertexes
//                     [1:0] --- x, y coordinates in screen space
//                     [9:0] --- 10 bits for each coordinates
// list_r:             read enable signal for triangle list
// fifo_w:             write enable signal for triangle fifo
// proj_done:          high when projection is done
module project #(
                parameter WIIA = 4,
                parameter WIFA = 8,
                parameter WI = 8,
                parameter WF = 8
)
(
                input                        Clk, Reset,
                input                        proj_start,
                input [2:0][2:0][WI+WF-1:0]  orig_triangle,
                input [WIIA+WIFA-1:0]        alpha, beta, gamma,
                input [WI+WF-1:0]            x_translate, y_translate, z_translate,
                input                        list_read_done,
                output logic [2:0][1:0][9:0] proj_triangle,
                output logic                 list_r,
                output logic                 fifo_w,
                output logic                 proj_done
);

    logic [2:0][2:0][WI+WF-1:0] orig_triangle_data, new_orig_triangle_data;
    logic [3:0]                 cal_time, count, new_count; // calculate period
    logic                       clip;                       // high when a triangle is clippped

    // 6 states
    // Wait:  Wait to project triangles
    // Take1: trigger to take original triangles from triangle list
    // Take2: take original triangles from triangle list
    // Proj:  calculate projection (project vertexes), cycles depend on cal_time
    // Write: write the projected triangle into triangle fifo
    // Done:  done
    enum logic [2:0] {Wait, Take1, Take2, Proj, Write, Done} curr_state, next_state;

    // calculate period (cycles needed when calculate projection)
    assign cal_time = 3'd4;

    project_cal #(.WIIA(WIIA), .WIFA(WIFA), .WI(WI), .WF(WF)) pc (
                                                            .orig_triangle(orig_triangle_data),
                                                            .alpha(alpha),
                                                            .beta(beta),
                                                            .gamma(gamma),
                                                            .x_translate(x_translate),
                                                            .y_translate(y_translate),
                                                            .z_translate(z_translate),
                                                            .proj_triangle(proj_triangle),
                                                            .clip(clip)
    );

    always_ff @(posedge Clk)
    begin
        if (Reset)
        begin
            curr_state <= Wait;
            orig_triangle_data <= 0;
            count <= 0;
        end
        else
        begin
            curr_state <= next_state;
            orig_triangle_data <= new_orig_triangle_data;
            count <= new_count;
        end
    end

    always_comb
    begin
        next_state = curr_state;
        proj_done = 1'b0;
        list_r = 1'b0;
        fifo_w = 1'b0;
        new_orig_triangle_data = orig_triangle_data;
        new_count = 0;
        
        unique case (curr_state)
        Wait:
        begin
            if(proj_start)
                next_state = Take1;
        end
        Take1:
        begin
            // when all original triangles has been read, done
            // otherwise keep projection
            if(list_read_done)
                next_state = Done;
            else
                next_state = Take2;
        end
        Take2:
        begin
            if(list_read_done)
                next_state = Done;
            else
                next_state = Proj;
        end
        Proj:
        begin
            // wait for [cal_time] cycles for projection
            if(count == cal_time)
                next_state = Write;
            else
            begin
                next_state = Proj;
                new_count = count + 3'b1;
            end
        end
        Write:
        begin
            next_state = Take1;
        end
        Done:
        begin
            if(!proj_start)
                next_state = Wait;
        end
        endcase

        case (curr_state)
        Wait:
        begin
        end
        Take1:
        begin
            list_r = 1'b1;
            new_orig_triangle_data = orig_triangle;
        end
        Take2:
        begin
            new_orig_triangle_data = orig_triangle;
        end
        Proj:
        begin
        end
        Write:
        begin
            // if the triangle is clipped, skip
            if(!clip)
                fifo_w = 1'b1;
        end
        Done:
        begin
            proj_done = 1'b1;
        end
        endcase
    end

endmodule