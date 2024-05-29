`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/21 11:42:14
// Design Name: 
// Module Name: ppm_encoder_tb
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

module ppm_encoder_tb;

    reg clk;
    reg rst;
    reg Din;
    wire Dout;

    initial $sdf_annotate("ppm_encoder.sdf", uut);

    ppm_encoder uut (
    .clk(clk),
    .rst(rst),
    .Din(Din),
    .Dout(Dout)
    );

    initial begin
        clk = 0;
        forever #(590 / 2) clk = ~clk;
    end

    initial begin
    // Initialize Inputs
    rst = 1;
    Din = 0;

    // 重置
    #10 rst = 0;
    #10 rst = 1;

    // 应用测试数据
    #20;

    //signal1****************************************
    Din = 0; // flag
    #590;
    Din = 0;
    #590;
    Din = 0;
    #590;
    Din = 0;
    #590;
    Din = 0;
    #590;
    Din = 0;
    #590;
    Din = 0;
    #590;
    Din = 0;
    #590;
    Din = 1; // end
    #590;

    Din = 0;

    // delay ppm_decode
    #800000

    //signal2****************************************
    Din = 0; // flag
    #590;
    Din = 0;
    #590;
    Din = 1;
    #590;
    Din = 0;
    #590;
    Din = 0;
    #590;
    Din = 0;
    #590;
    Din = 0;
    #590;
    Din = 0;
    #590;
    Din = 1; // end
    #590;

    Din = 0;

    // delay ppm_decode
    #800000

    //signal3****************************************
    Din = 0; // flag
    #590;
    Din = 0;
    #590;
    Din = 1;
    #590;
    Din = 0;
    #590;
    Din = 0;
    #590;
    Din = 0;
    #590;
    Din = 1;
    #590;
    Din = 0;
    #590;
    Din = 1; // end
    #590;

    Din = 0;
    // delay ppm_decode
    #800000

    //signal4****************************************
    Din = 0; // flag
    #590;
    Din = 1;
    #590;
    Din = 1;
    #590;
    Din = 1;
    #590;
    Din = 1;
    #590;
    Din = 1;
    #590;
    Din = 1;
    #590;
    Din = 1;
    #590;
    Din = 1; // end
    #590;

    Din = 0;

    // delay ppm_decode
    #800000

    //signal5****************************************
    Din = 0; // flag
    #590;
    Din = 1;
    #590;
    Din = 1;
    #590;
    Din = 0;
    #590;
    Din = 0;
    #590;
    Din = 1;
    #590;
    Din = 0;
    #590;
    Din = 0;
    #590;
    Din = 1; // end
    #590;

    Din = 0;

    // delay ppm_decode
    #800000

    //signal6****************************************
    Din = 0; // flag
    #590;
    Din = 0;
    #590;
    Din = 0;
    #590;
    Din = 0;
    #590;
    Din = 0;
    #590;
    Din = 0;
    #590;
    Din = 0;
    #590;
    Din = 0;
    #590;
    Din = 1; // end
    #590;

    Din = 0;
    #5900;

    Din = 0; // flag
    #590;
    Din = 0;
    #590;
    Din = 0;
    #590;
    Din = 0;
    #590;
    Din = 0;
    #590;
    Din = 0;
    #590;
    Din = 0;
    #590;
    Din = 0;
    #590;
    Din = 1; // end
    #590;

    Din = 0;
    #5900;

    Din = 0; // flag
    #590;
    Din = 0;
    #590;
    Din = 0;
    #590;
    Din = 0;
    #590;
    Din = 0;
    #590;
    Din = 0;
    #590;
    Din = 0;
    #590;
    Din = 0;
    #590;
    Din = 1; // end
    #590;

    Din = 0;

    // delay ppm_decode
    #800000

    // 
    #1000 $finish;
    end

endmodule