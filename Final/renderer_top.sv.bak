module test_top(
                input               CLOCK_50,
                input        [3:0]  KEY,
                // VGA Interface
                output logic [7:0]  VGA_R,        //VGA Red
                                    VGA_G,        //VGA Green
                                    VGA_B,        //VGA Blue
                output logic        VGA_CLK,      //VGA Clock
                                    VGA_SYNC_N,   //VGA Sync signal
                                    VGA_BLANK_N,  //VGA Blank signal
                                    VGA_VS,       //VGA virtical sync signal
                                    VGA_HS        //VGA horizontal sync signal
);

    logic Reset, Clk;
    logic frame_clk;
    logic frame_clk_rising_edge;
    logic draw_start, draw_done, clear_start, clear_done, frame_done;
    logic draw_data, read_data;
    logic [9:0] draw_DrawX, draw_DrawY, clear_DrawX, clear_DrawY;
    logic [9:0] DrawX, DrawY;
    logic [9:0] ReadX, ReadY;

    logic [1:0][9:0] V1, V2, V3;

    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        Reset <= ~(KEY[0]);        // The push buttons are active low
    end

    assign frame_clk = VGA_VS;
    assign V1[0] = 10'd30;
    assign V1[1] = 10'd450;
    assign V2[0] = 10'd400;
    assign V2[1] = 10'd200;
    assign V3[0] = 10'd20;
    assign V3[1] = 10'd400;

    vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));

    VGA_controller vga_controller_instance( 
                                            .Clk(Clk), 
                                            .Reset(Reset), 
                                            .VGA_HS(VGA_HS),
                                            .VGA_VS(VGA_VS),
                                            .VGA_CLK(VGA_CLK),
                                            .VGA_BLANK_N(VGA_BLANK_N),
                                            .VGA_SYNC_N(VGA_SYNC_N), 
                                            .ReadX(ReadX),
                                            .ReadY(ReadY)
    );

    color_mapper color_instance(
                                .is_pixel(read_data),
                                .ReadX(ReadX),
                                .ReadY(ReadY),
                                .VGA_R(VGA_R),
                                .VGA_G(VGA_G),
                                .VGA_B(VGA_B)
    );
    
    control_unit cu(
                    .Clk(Clk),
                    .Reset(Reset),
                    .frame_clk(frame_clk),
                    .draw_done(draw_done),
                    .clear_done(clear_done),
                    .draw_DrawX(draw_DrawX),
                    .draw_DrawY(draw_DrawY),
                    .clear_DrawX(clear_DrawX),
                    .clear_DrawY(clear_DrawY),
                    .draw_start(draw_start),
                    .clear_start(clear_start),
                    .draw_data(draw_data),
                    .DrawX(DrawX),
                    .DrawY(DrawY),
                    .frame_clk_rising_edge(frame_clk_rising_edge),
                    .frame_done(frame_done)
    );

    clear_frame cf(
                    .Clk(Clk),
                    .Reset(Reset),
                    .clear_frame_start(clear_start),
                    .DrawX(clear_DrawX),
                    .DrawY(clear_DrawY),
                    .clear_frame_done(clear_done)
    );

    draw_triangle dl(
                    .Clk(Clk),
                    .Reset(Reset),
                    .draw_triangle_start(draw_start),
                    .V1(V1),
                    .V2(V2),
                    .V3(V3),
                    .DrawX(draw_DrawX),
                    .DrawY(draw_DrawY),
                    .draw_triangle_done(draw_done)
    );

    frame_buffer fb(
                    .Clk(Clk),
                    .Reset(Reset),
                    .frame_clk_rising_edge(frame_clk_rising_edge),
                    .DrawX(DrawX),
                    .DrawY(DrawY),
                    .draw_data(draw_data),
                    .frame_done(frame_done),
                    .ReadX(ReadX),
                    .ReadY(ReadY),
                    .read_data(read_data)
    );



endmodule
