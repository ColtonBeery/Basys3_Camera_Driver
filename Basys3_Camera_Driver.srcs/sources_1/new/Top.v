`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SDSU
// Engineer: Colton Beery
// 
// Design Name: Basys3_Camera_Driver
// Module Name: Top
// Project Name: Basys3 Camera Driver
// Target Devices: Basys 3 FPGA, with Raspberry Pi NoIR 2.1 Camera
// Description: Outputs the Pi NoIR camera picture on a VGA display in real time
// 
// Dependencies: Basys3_Master_Customized.xdc, vga640x480.v, sram.v
// 
// Revision time: 4/10/2019 12:09 PM
// Additional Comments: Thanks to Will Green for his great VGA graphics tutorial https://timetoexplore.net/blog/arty-fpga-vga-verilog-01
// 
//////////////////////////////////////////////////////////////////////////////////


module Top(
    input wire CLK,              // board clock: 100 MHz on Arty/Basys3/Nexys
    input wire IO_BTN_C,         // reset button
    input wire [7:0] JA,         // JA port for camera input 
    output wire VGA_Hsync,       // horizontal sync output
    output wire VGA_Vsync,       // vertical sync output
    output wire [3:0] vgaRed,    // 4-bit VGA red output
    output wire [3:0] vgaBlue,   // 4-bit VGA green output
    output wire [3:0] vgaGreen   // 4-bit VGA blue output
    );
    
/* VGA Display */
//Generate 25.175 MHz pixel strobe clock
reg [15:0] cnt;
reg pix_stb; 
always @(posedge CLK) begin
    {pix_stb, cnt} <= cnt + 16'h4073;  // divide 100 MHz clock by 3.972 to get 25.175 MHz: (2^16)/3.972 = 0x4073
end
//Instantiate VGA Module. Used under MIT License from Will Green's VGA graphics tutorial.
wire rst = IO_BTN_C;  // reset is active high on Basys3 (BTNC)
wire [9:0] x;  // current pixel x position: 10-bit value: 0-1023
wire [8:0] y;  // current pixel y position:  9-bit value: 0-511
wire animate;  // high when we're ready to animate at end of drawing
vga640x480 display (
        .i_clk(CLK),
        .i_pix_stb(pix_stb),
        .i_rst(rst),
        .o_hs(VGA_Hsync), 
        .o_vs(VGA_Vsync), 
        .o_x(x), 
        .o_y(y)
    );

// VRAM frame buffers (read-write). Used under MIT License from Will Green's VGA graphics tutorial.
    localparam SCREEN_WIDTH = 640;
    localparam SCREEN_HEIGHT = 360;
    localparam VRAM_DEPTH = SCREEN_WIDTH * SCREEN_HEIGHT; 
    localparam VRAM_A_WIDTH = 18;  // 2^18 > 640 x 360
    localparam VRAM_D_WIDTH = 6;   // colour bits per pixel

    reg [VRAM_A_WIDTH-1:0] address;
    reg [VRAM_D_WIDTH-1:0] datain;
    wire [VRAM_D_WIDTH-1:0] dataout;
    reg we = 0;  // write enable bit

    // frame buffer A VRAM
    sram #(
        .ADDR_WIDTH(VRAM_A_WIDTH), 
        .DATA_WIDTH(VRAM_D_WIDTH), 
        .DEPTH(VRAM_DEPTH), 
        .MEMFILE("")) 
        vram (
        .i_addr(address), 
        .i_clk(CLK), 
        .i_write(we),
        .i_data(datain), 
        .o_data(dataout)
    );
 //Instantiate Camera In module
 reg [7:0] Cam_Data;
 Cam_In camera (
        .JA(JA), // JA port for camera input 
        .Cam_Data(Cam_Data) //data read from camera
    );
//Store data from Camera into memory. TBD. 
//Read data from memory onto display.  TBD. 
endmodule
