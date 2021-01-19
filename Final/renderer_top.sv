// Top Level Module For FPGA-based 3D Graphics Renderer
// Render arbitary simple 3D module (approximately less than 100 triangles)
// and control the rotation, translation of the module smoothly using keyboard
// For ECE 385 FINAL PROJECT FA2020
// Team Member: GUAN ZIMU, XIE TIAN
// Date: 2020-12

// ATTENTION: there are 2 ways to load model
//            way1: Write triangles into list then read
//            way2: Initial on-chip memory by txt file while being compiled then read
//                  we have a simple python script to convert .obj files into txt file
//                  which is compatable with this renderer
//            different ways need you to comment/uncomment some lines

module renderer_top(
                input               CLOCK_50,
                input        [3:0]  KEY,
                input        [7:0]  SW,
                output logic [7:0]  LEDR,
                output logic [6:0]  HEX0, HEX1,
                // VGA Interface
                output logic [7:0]  VGA_R,        //VGA Red
                                    VGA_G,        //VGA Green
                                    VGA_B,        //VGA Blue
                output logic        VGA_CLK,      //VGA Clock
                                    VGA_SYNC_N,   //VGA Sync signal
                                    VGA_BLANK_N,  //VGA Blank signal
                                    VGA_VS,       //VGA virtical sync signal
                                    VGA_HS,       //VGA horizontal sync signal
                // CY7C67200 Interface
                inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
                output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
                output logic        OTG_CS_N,     //CY7C67200 Chip Select
                                    OTG_RD_N,     //CY7C67200 Write
                                    OTG_WR_N,     //CY7C67200 Read
                                    OTG_RST_N,    //CY7C67200 Reset
                input               OTG_INT,      //CY7C67200 Interrupt
                // SDRAM Interface for Nios II Software
                output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
                inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
                output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
                output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
                output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
                                    DRAM_CAS_N,   //SDRAM Column Address Strobe
                                    DRAM_CKE,     //SDRAM Clock Enable
                                    DRAM_WE_N,    //SDRAM Write Enable
                                    DRAM_CS_N,    //SDRAM Chip Select
                                    DRAM_CLK      //SDRAM Clock
);

    parameter WIIA = 4; // integer bits for angle
    parameter WIFA = 8; // decimal bits for angle
    parameter WI = 8;   // integer bits for triangle data
    parameter WF = 8;   // decimal bits for triangle data

    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w, hpi_cs, hpi_reset;

    logic Reset, Clk;
    logic frame_clk;
    logic frame_clk_rising_edge;
    logic load_obj, load_done;
    logic draw_start, draw_done, proj_start, proj_done, clear_start, clear_done, frame_done;
    logic draw_data, read_data;
    logic fifo_r, fifo_w, list_r, list_w;
    logic fifo_empty, fifo_full, list_empty, list_full, list_read_done;
    logic [9:0] draw_DrawX, draw_DrawY, clear_DrawX, clear_DrawY;
    logic [9:0] DrawX, DrawY;
    logic [9:0] ReadX, ReadY;
    logic [2:0][1:0][9:0] proj_triangle_out, proj_triangle_in;
    logic [2:0][2:0][(WI+WF)-1:0] orig_triangle_in, orig_triangle_out;

    logic [7:0]           keycode;
    logic [WI+WF-1:0]     x_pos, y_pos, z_pos;
    logic [WIIA+WIFA-1:0] alpha, beta, gamma;


    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        Reset <= ~(KEY[0]);        // The push buttons are active low
    end

    assign frame_clk = VGA_VS;
    assign LEDR = SW;

    // test for keycode
    // assign keycode = SW;

    // generate VGA clk 25MHz
    vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));

    // VGA controller
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

    // map color
    color_mapper color_instance(
                                .is_pixel(read_data),
                                .ReadX(ReadX),
                                .ReadY(ReadY),
                                .VGA_R(VGA_R),
                                .VGA_G(VGA_G),
                                .VGA_B(VGA_B)
    );

    // control the motion of the object and camera
    display #(.WI(WI), .WF(WF)) play(
                    .Clk(Clk),
                    .Reset(Reset),
                    .keycode(keycode),
                    .frame_clk_rising_edge(frame_clk_rising_edge),
                    .alpha(alpha),
                    .beta(beta),
                    .gamma(gamma),
                    .x(x_pos),
                    .y(y_pos),
                    .z(z_pos)
    );

    // control unit for every module
    control_unit cu(
                    .Clk(Clk),
                    .Reset(Reset),
                    .frame_clk(frame_clk),
                    .draw_done(draw_done),
                    .clear_done(clear_done),
                    .load_done(load_done),
                    .draw_DrawX(draw_DrawX),
                    .draw_DrawY(draw_DrawY),
                    .clear_DrawX(clear_DrawX),
                    .clear_DrawY(clear_DrawY),
                    .load_obj(load_obj),
                    .draw_start(draw_start),
                    .clear_start(clear_start),
                    .proj_start(proj_start),
                    .draw_data(draw_data),
                    .DrawX(DrawX),
                    .DrawY(DrawY),
                    .frame_clk_rising_edge(frame_clk_rising_edge),
                    .frame_done(frame_done)
    );

    // module to clear frame
    clear_frame cf(
                    .Clk(Clk),
                    .Reset(Reset),
                    .clear_frame_start(clear_start),
                    .DrawX(clear_DrawX),
                    .DrawY(clear_DrawY),
                    .clear_frame_done(clear_done)
    );

    // module to draw projected triangles in screen space
    draw draw_instance(
                        .Clk(Clk),
                        .Reset(Reset),
                        .draw_start(draw_start),
                        .triangle_data(proj_triangle_out),
                        .fifo_empty(fifo_empty),
                        .fifo_r(fifo_r),
                        .DrawX(draw_DrawX),
                        .DrawY(draw_DrawY),
                        .draw_done(draw_done)
    );

    // module to project original triangle in 3D space into 2D screen space
    project #(.WIIA(WIIA), .WIFA(WIFA), .WI(WI), .WF(WF)) project_instance(
                                                                    .Clk(Clk),
                                                                    .Reset(Reset),
                                                                    .proj_start(proj_start),
                                                                    .orig_triangle(orig_triangle_out),
                                                                    .alpha(alpha),
                                                                    .beta(beta),
                                                                    .gamma(gamma),
                                                                    .x_translate(x_pos),
                                                                    .y_translate(y_pos),
                                                                    .z_translate(z_pos),
                                                                    .list_read_done(list_read_done),
                                                                    .proj_triangle(proj_triangle_in),
                                                                    .list_r(list_r),
                                                                    .fifo_w(fifo_w),
                                                                    .proj_done(proj_done)
    );

    // triangle fifo
    // store projected triangles (in 2D screen space) for every frame
    triangle_fifo #(.Waddr(6), .size(60)) tf(
                                    .Clk(Clk),
                                    .Reset(Reset),
                                    .r_en(fifo_r),
                                    .w_en(fifo_w),
                                    .triangle_in(proj_triangle_in),
                                    .triangle_out(proj_triangle_out),
                                    .is_empty(fifo_empty),
                                    .is_full(fifo_full)
    );

    // test module for triangle fifo
    // write projected triangle (in 2D screen space) into triangle fifo
    // fifo_writer fw(
    //                 .Clk(Clk),
    //                 .Reset(Reset),
    //                 .clear_start(clear_start),
    //                 .fifo_w(fifo_w),
    //                 .proj_triangle_in(proj_triangle_in)
    // );

    triangle_list #(.WI(WI), .WF(WF), .Waddr(6), .size(60)) tl(
                                                                .Clk(Clk),
                                                                .Reset(Reset),
                                                                .r_en(list_r),
                                                                .w_en(list_w),
                                                                .triangle_in(orig_triangle_in),
                                                                .triangle_out(orig_triangle_out),
                                                                .is_empty(list_empty),
                                                                .is_full(list_full),
                                                                .read_done(list_read_done)
    );

    // way1 to load model
    // should be commented when use txt file to load model
    // write original triangle data into triangle list
    list_writer #(.WI(WI), .WF(WF)) lw(
                                        .Clk(Clk),
                                        .Reset(Reset),
                                        .load_obj(load_obj),
                                        .list_w(list_w),
                                        .load_done(load_done),
                                        .orig_triangle_in(orig_triangle_in)
    );

    // On-chip memory frame buffer
    // 2-buffer, ping-pong switch
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

    // Interface between NIOS II and EZ-OTG chip
    hpi_io_intf hpi_io_inst(
                            .Clk(Clk),
                            .Reset(Reset),
                            // signals connected to NIOS II
                            .from_sw_address(hpi_addr),
                            .from_sw_data_in(hpi_data_in),
                            .from_sw_data_out(hpi_data_out),
                            .from_sw_r(hpi_r),
                            .from_sw_w(hpi_w),
                            .from_sw_cs(hpi_cs),
                            .from_sw_reset(hpi_reset),
                            // signals connected to EZ-OTG chip
                            .OTG_DATA(OTG_DATA),
                            .OTG_ADDR(OTG_ADDR),
                            .OTG_RD_N(OTG_RD_N),
                            .OTG_WR_N(OTG_WR_N),
                            .OTG_CS_N(OTG_CS_N),
                            .OTG_RST_N(OTG_RST_N)
    );
    
    // nios II system for USB keyboard control
    nios_system nios_system(
                            .clk_clk(Clk),
                            .reset_reset_n(1'b1),
                            .sdram_wire_addr(DRAM_ADDR),
                            .sdram_wire_ba(DRAM_BA),
                            .sdram_wire_cas_n(DRAM_CAS_N),
                            .sdram_wire_cke(DRAM_CKE),
                            .sdram_wire_cs_n(DRAM_CS_N),
                            .sdram_wire_dq(DRAM_DQ),
                            .sdram_wire_dqm(DRAM_DQM),
                            .sdram_wire_ras_n(DRAM_RAS_N),
                            .sdram_wire_we_n(DRAM_WE_N),
                            .sdram_clk_clk(DRAM_CLK),
                            .keycode_export(keycode),
                            .otg_hpi_address_export(hpi_addr),
                            .otg_hpi_data_in_port(hpi_data_in),
                            .otg_hpi_data_out_port(hpi_data_out),
                            .otg_hpi_cs_export(hpi_cs),
                            .otg_hpi_r_export(hpi_r),
                            .otg_hpi_w_export(hpi_w),
                            .otg_hpi_reset_export(hpi_reset)
    );

    // Display keycode on hex display
    HexDriver hex_inst_0 (keycode[3:0], HEX0);
    HexDriver hex_inst_1 (keycode[7:4], HEX1);

endmodule
