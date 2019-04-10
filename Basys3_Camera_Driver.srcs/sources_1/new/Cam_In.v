`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SDSU
// Engineer: Colton Beery
// 
// Design Name: Basys3_Camera_Driver
// Module Name: Cam_In
// Project Name: Basys3 Camera Driver
// Target Devices: Basys 3 FPGA, with Raspberry Pi NoIR 2.1 Camera
// Description: Outputs the Pi NoIR camera picture and passes back to top module
// 
// Dependencies: Basys3_Master_Customized.xdc
// 
// Revision time: 4/10/2019 12:09 PM
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Cam_In(
    input clk,
    input [7:0] JA, //Input from Pi Camera on JA port
    output [7:0] Cam_Data //passes data from camera back to top module to be saved in RAM
    );
    //No progress here yet, I've been trying to follow the tutorial to get the display working first
endmodule
