`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/23 19:12:00
// Design Name: 
// Module Name: ppm_decoder_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module ppm_decoder_tb;

// Inputs
reg clk;
reg rst;
reg Din;

// Outputs
wire [7:0] Dout;
wire D_en;
wire F_en;

integer clk_period = 590;   //0.59us

//sdf
initial $sdf_annotate("ppm_decoder.sdf", uut);

// Instantiate the Unit Under Test (UUT)
ppm_decoder uut (
    .clk(clk),
    .rst(rst),
    .Din(Din),
    .Dout(Dout),
    .D_en(D_en),
    .F_en(F_en)
);

// Clock generation
always #(clk_period / 2) clk = ~clk; // Clock with period 1ns

// Stimulus here
initial begin
    // Initialize Inputs
    clk = 0;
    rst = 1;
    Din = 1;

    // Reset the UUT
    #(0.45 * clk_period);
    rst = 0;
    #(1* clk_period);
    rst = 1;
    #(2* clk_period);

    // Start sending PPM signals
    // Add your test signals here
    //signal1****************************************************
    // SOF
    Din = 0;
    #(16* clk_period); // Simulate a frame start
    Din = 1;
    #(64* clk_period);  // Simulate data bits
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(32* clk_period);  // Simulate data bits

    //data1************************************************     ppm: 11 10 01 00  data: 0001 1011
    Din = 1;
    #(112* clk_period); // Simulate a frame start
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;

    Din = 1;
    #(80* clk_period);  // Simulate data bits
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(32* clk_period);  // Simulate data bits

    Din = 1;
    #(48* clk_period);  // Simulate data bits
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(64* clk_period);  // Simulate data bits

    Din = 1;
    #(16* clk_period);  // Simulate data bits
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(96* clk_period);  // Simulate data bits

    //EOF
    Din = 1;
    #(32* clk_period); // Simulate a frame start
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(16* clk_period);  // Simulate data bits

    // delay
    #(30* clk_period);


    //signal2****************************************************
    // SOF
    Din = 0;
    #(16* clk_period); // Simulate a frame start
    Din = 1;
    #(64* clk_period);  // Simulate data bits
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(32* clk_period);  // Simulate data bits

    //data1********************************************     ppm: 11 10 01 00  data: 0001 1011
    Din = 1;
    #(112* clk_period); // Simulate a frame start
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;

    Din = 1;
    #(80* clk_period);  // Simulate data bits
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(32* clk_period);  // Simulate data bits

    Din = 1;
    #(48* clk_period);  // Simulate data bits
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(64* clk_period);  // Simulate data bits

    Din = 1;
    #(16* clk_period);  // Simulate data bits
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(96* clk_period);  // Simulate data bits

    //data2*********************************************     ppm: 11 10 01 00  data: 0001 1011
    Din = 1;
    #(112* clk_period); // Simulate a frame start
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;

    Din = 1;
    #(80* clk_period);  // Simulate data bits
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(32* clk_period);  // Simulate data bits

    Din = 1;
    #(48* clk_period);  // Simulate data bits
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(64* clk_period);  // Simulate data bits

    Din = 1;
    #(16* clk_period);  // Simulate data bits
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(96* clk_period);  // Simulate data bits

    //EOF
    Din = 1;
    #(32* clk_period); // Simulate a frame start
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(16* clk_period);  // Simulate data bits

    // delay
    #(30* clk_period);


    //signal3****************************************************
    // SOF
    Din = 0;
    #(16* clk_period); // Simulate a frame start
    Din = 1;
    #(64* clk_period);  // Simulate data bits
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(32* clk_period);  // Simulate data bits

    //data1********************************************     ppm: 00 01 10 11  data: 1110 0100
    Din = 1;
    #(16* clk_period);  // Simulate data bits
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(96* clk_period);  // Simulate data bits

    Din = 1;
    #(48* clk_period);  // Simulate data bits
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(64* clk_period);  // Simulate data bits    

    Din = 1;
    #(80* clk_period);  // Simulate data bits
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(32* clk_period);  // Simulate data bits

    Din = 1;
    #(112* clk_period); // Simulate a frame start
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;

    //EOF
    Din = 1;
    #(32* clk_period); // Simulate a frame start
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(16* clk_period);  // Simulate data bits

    // delay
    #(30* clk_period);


    //signal4****************************************************
    // SOF
    Din = 0;
    #(16* clk_period); // Simulate a frame start
    Din = 1;
    #(64* clk_period);  // Simulate data bits
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(32* clk_period);  // Simulate data bits

    //data1********************************************     ppm: 00 01 10 11  data: 1110 0100
    Din = 1;
    #(16* clk_period);  // Simulate data bits
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(96* clk_period);  // Simulate data bits

    Din = 1;
    #(48* clk_period);  // Simulate data bits
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(64* clk_period);  // Simulate data bits    

    Din = 1;
    #(80* clk_period);  // Simulate data bits
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(32* clk_period);  // Simulate data bits

    Din = 1;
    #(112* clk_period); // Simulate a frame start
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;

    //data2********************************************     ppm: 00 01 10 11  data: 1110 0100
    Din = 1;
    #(16* clk_period);  // Simulate data bits
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(96* clk_period);  // Simulate data bits

    Din = 1;
    #(48* clk_period);  // Simulate data bits
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(64* clk_period);  // Simulate data bits    

    Din = 1;
    #(80* clk_period);  // Simulate data bits
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(32* clk_period);  // Simulate data bits

    Din = 1;
    #(112* clk_period); // Simulate a frame start
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;

    //EOF
    Din = 1;
    #(32* clk_period); // Simulate a frame start
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(16* clk_period);  // Simulate data bits

    // delay
    #(30* clk_period);


    //signal5****************************************************
    // SOF
    Din = 0;
    #(16* clk_period); // Simulate a frame start
    Din = 1;
    #(64* clk_period);  // Simulate data bits
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(32* clk_period);  // Simulate data bits

    //data1************************************************     ppm: 11 10 01 00  data: 0001 1011
    Din = 1;
    #(112* clk_period); // Simulate a frame start
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;

    Din = 1;
    #(80* clk_period);  // Simulate data bits
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(32* clk_period);  // Simulate data bits

    Din = 1;
    #(48* clk_period);  // Simulate data bits
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(64* clk_period);  // Simulate data bits

    Din = 1;
    #(16* clk_period);  // Simulate data bits
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(96* clk_period);  // Simulate data bits

    //data2********************************************     ppm: 00 01 10 11  data: 1110 0100
    Din = 1;
    Din = 1;
    #(16* clk_period);  // Simulate data bits
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(96* clk_period);  // Simulate data bits

    Din = 1;
    #(48* clk_period);  // Simulate data bits
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(64* clk_period);  // Simulate data bits    

    Din = 1;
    #(80* clk_period);  // Simulate data bits
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(32* clk_period);  // Simulate data bits

    Din = 1;
    #(112* clk_period); // Simulate a frame start
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;

    //EOF
    Din = 1;
    #(32* clk_period); // Simulate a frame start
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(16* clk_period);  // Simulate data bits

    // delay
    #(30* clk_period);


    //signal6****************************************************
    // SOF
    Din = 0;
    #(16* clk_period); // Simulate a frame start
    Din = 1;
    #(64* clk_period);  // Simulate data bits
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(32* clk_period);  // Simulate data bits

    //data1************************************************     ppm: 11 10 01 00  data: 0001 1011
    Din = 1;
    #(112* clk_period); // Simulate a frame start
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;

    Din = 1;
    #(80* clk_period);  // Simulate data bits
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(32* clk_period);  // Simulate data bits

    Din = 1;
    #(48* clk_period);  // Simulate data bits
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(64* clk_period);  // Simulate data bits

    Din = 1;
    #(16* clk_period);  // Simulate data bits
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(96* clk_period);  // Simulate data bits

    //data2********************************************     ppm: 00 01 10 11  data: 1110 0100
    Din = 1;
    #(16* clk_period);  // Simulate data bits
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(96* clk_period);  // Simulate data bits

    Din = 1;
    #(48* clk_period);  // Simulate data bits
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(64* clk_period);  // Simulate data bits    

    Din = 1;
    #(80* clk_period);  // Simulate data bits
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(32* clk_period);  // Simulate data bits

    Din = 1;
    #(112* clk_period); // Simulate a frame start
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;

    //data3************************************************     ppm: 11 10 01 00  data: 0001 1011
    Din = 1;
    #(112* clk_period); // Simulate a frame start
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;

    Din = 1;
    #(80* clk_period);  // Simulate data bits
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(32* clk_period);  // Simulate data bits

    Din = 1;
    #(48* clk_period);  // Simulate data bits
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(64* clk_period);  // Simulate data bits

    Din = 1;
    #(16* clk_period);  // Simulate data bits
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(96* clk_period);  // Simulate data bits

    //data4********************************************     ppm: 00 01 10 11  data: 1110 0100
    Din = 1;
    #(16* clk_period);  // Simulate data bits
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(96* clk_period);  // Simulate data bits

    Din = 1;
    #(48* clk_period);  // Simulate data bits
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(64* clk_period);  // Simulate data bits    

    Din = 1;
    #(80* clk_period);  // Simulate data bits
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(32* clk_period);  // Simulate data bits

    Din = 1;
    #(112* clk_period); // Simulate a frame start
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;

    //data5************************************************     ppm: 11 10 01 00  data: 0001 1011
    Din = 1;
    #(112* clk_period); // Simulate a frame start
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;

    Din = 1;
    #(80* clk_period);  // Simulate data bits
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(32* clk_period);  // Simulate data bits

    Din = 1;
    #(48* clk_period);  // Simulate data bits
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(64* clk_period);  // Simulate data bits

    Din = 1;
    #(16* clk_period);  // Simulate data bits
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(96* clk_period);  // Simulate data bits

    //data6********************************************     ppm: 00 01 10 11  data: 1110 0100
    Din = 1;
    #(16* clk_period);  // Simulate data bits
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(96* clk_period);  // Simulate data bits

    Din = 1;
    #(48* clk_period);  // Simulate data bits
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(64* clk_period);  // Simulate data bits    

    Din = 1;
    #(80* clk_period);  // Simulate data bits
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(32* clk_period);  // Simulate data bits

    Din = 1;
    #(112* clk_period); // Simulate a frame start
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;

    //EOF
    Din = 1;
    #(32* clk_period); // Simulate a frame start
    Din = 0;
    #(16* clk_period);  // Simulate data bits
    Din = 1;
    #(16* clk_period);  // Simulate data bits


    // Finish the simulation
    #(30* clk_period);
    $finish;
end

// Add additional tasks or functions if needed for more complex testing

endmodule

