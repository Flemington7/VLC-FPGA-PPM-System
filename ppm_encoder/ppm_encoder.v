//////////////////////////////////////////////////////////////////////////////////
// Company: Tsinghua University
// Engineer: Wentao Ye
// 
// Create Date: 2024/06/22 13:50:00
// Design Name: VLC system
// Module Name: ppm_encoder
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

// convert the serial data to parallel data

`timescale 1ns / 1ps

module shift_register (
    input wire clk,
    input wire rst,
    input wire serial_in,
    input wire data_ready_rst,
    output reg [7:0] parallel_out,
    output reg data_ready
);

reg [7:0] shift_reg;
reg [3:0] count;
reg data_flag;

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        shift_reg <= 8'b0;
        count <= 4'd0;
        data_flag <= 0;
        data_ready <= 0;
    end else begin 
        if (!data_ready_rst) begin
            data_ready <= 0;
        end else begin
            if (serial_in == 1'b0 && data_flag == 1'b0) begin // detect the start bit: 0, after which is the data bits
                data_flag <= 1;
            end else if (data_flag == 1'b1) begin
                shift_reg <= {shift_reg[6:0], serial_in};
                count <= count + 1;
                if (count == 4'd7) begin
                    parallel_out <= shift_reg;
                    data_ready <= 1;
                    data_flag <= 0;
                    count <= 4'd0;
                end
            end
        end
    end
end

endmodule

module ppm_memory(
    input wire clk,
    input wire rst,
    input wire [7:0] M_in,
    input wire control, //0: read; 1: write
    input wire [3:0] address,
    output reg [7:0] M_out 
);

// Buffer for storing data, parameterized for flexibility
parameter BUFFER_DEPTH = 16;
reg [7:0] data_buffer [BUFFER_DEPTH - 1:0];

integer i;

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        // Reset logic
        for (i = 0; i < 16; i = i + 1) begin
            data_buffer[i] <= 8'b00000000;
        end
        M_out <= 0;
    end else begin
        case (control)                          
        1'b1:  data_buffer[address] <= M_in;
        1'b0:  M_out <= data_buffer[address];
        default: ; 
        endcase
    end
end

endmodule 

// PPM encoder and transmitter
module ppm_encoder_tx(
    input wire clk,
    input wire rst,
    input wire [7:0] in_ppm,
    input wire [1:0] order, // 00: null; 01: SOF; 10: data; 11: EOF
    input wire [9:0] clk_count_ppm,
    input wire [1:0] bit_count_ppm,
    output reg Dout
);

parameter IDLE = 2'b00;
parameter SOF = 2'b01;
parameter DATA = 2'b10;
parameter EOF = 2'b11;

wire [7:0] data_0;
wire [7:0] data_1;

// PPM encode
// Calculate the first pulse position (data_0) based on the input PPM data (in_ppm)
// bit_count_ppm is a 2-bit counter used to select which 2-bit segment of in_ppm to process
// 1. Right shift in_ppm by (bit_count_ppm * 2) to select the relevant 2-bit segment
// 2. Mask the shifted value with 8'b00000011 to isolate the 2-bit segment
// 3. Multiply the isolated 2-bit value by 2 and add 1 to determine the pulse position (ensures it's an odd number)
// 4. Multiply by 16 to scale the pulse position to the appropriate time window, so transmit 2-bit cost 128 clk cycle
assign data_0 = 16 * (((in_ppm >> (bit_count_ppm * 2)) & 8'b00000011) * 2 + 1);

// Calculate the second pulse position (data_1) based on the same 2-bit segment
// This follows the same steps as data_0, but adds an additional 16 to shift the pulse position
// This provides a second time point in the same time window for the pulse
assign data_1 = 16 * (((in_ppm >> (bit_count_ppm * 2)) & 8'b00000011) * 2 + 1) + 16;

               
always @(posedge clk or negedge rst) begin
    if (!rst) begin
        Dout <= 1;
    end else begin
        case (order)
            IDLE: begin 
                Dout <= 1;
            end
            SOF: begin 
                if(clk_count_ppm == 0) begin
                    Dout <= 0;
                end else if(clk_count_ppm == 9'd15) begin
                    Dout <= 1;
                end else if(clk_count_ppm == 9'd79) begin
                    Dout <= 0;
                end else if(clk_count_ppm == 9'd95) begin
                    Dout <= 1;
                end else if(clk_count_ppm == 9'd127) begin
                    Dout <= 1; // default value
                end
            end
            DATA: begin // generate the data signal
                if(clk_count_ppm == 0) begin
                    Dout <= 1;
                end else if(clk_count_ppm == data_0) begin
                    Dout <= 0; // high level is effective
                end else if(clk_count_ppm == data_1) begin
                    Dout <= 1;
                end               
            end
            EOF: begin
                if(clk_count_ppm == 0) begin
                    Dout <= 1;
                end else if(clk_count_ppm == 9'd31) begin
                    Dout <= 0;
                end else if(clk_count_ppm == 9'd47) begin
                    Dout <= 1;
                end
            end
        endcase
    end
end

endmodule

// top module
module ppm_encoder(
    input wire clk,
    input wire rst,
    input wire Din,
    output wire Dout
);

parameter state_IDLE = 2'd0;
parameter state_memory = 2'd1;
parameter state_send = 2'd2;
parameter state_end = 2'd3;

parameter IDLE = 2'b00;
parameter SOF = 2'b01;
parameter DATA = 2'b10;
parameter EOF = 2'b11;

// shift_register
wire [7:0] parallel_data;
wire data_ready;
reg data_ready_rst;

reg [1:0] state;
reg [3:0] data_length;
reg [4:0] data_count;
reg [7:0] data_temp;

wire [7:0] data_line1;
reg [9:0] clk_count;
reg [1:0] bit_count;

reg control;
reg [3:0] address;
reg [1:0] order;

// module instantiation
ppm_memory ppm_memory_dut1(
    .clk(clk),
    .rst(rst),
    .M_in(data_temp),
    .control(control),
    .address(address),
    .M_out(data_line1)
);

ppm_encoder_tx ppm_encoder_tx_dut1(
    .clk(clk),
    .rst(rst),                 
    .in_ppm(data_line1),
    .order(order),
    .clk_count_ppm(clk_count),
    .bit_count_ppm(bit_count),
    .Dout(Dout)
);

shift_register u_shift_register (
    .clk(clk),
    .rst(rst),
    .serial_in(serial_in),
    .parallel_out(parallel_data),
    .data_ready(data_ready),
    .data_ready_rst(data_ready_rst)
);

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        state <= state_IDLE;
        data_length <= 4'd1;
        data_count <= 5'd0;
        data_temp <= 8'd0;
        bit_count <= 2'd0;
        
        clk_count <= 9'd0;
        
        control <= 0;
        address <= 4'd0;
        order <= IDLE;

        data_ready_rst <= 1;
    end else begin
        case (state)
            state_IDLE: begin 
                state <= state_IDLE;
                data_length <= 4'd1;
                data_count <= 5'd0;
                data_temp <= 8'd0;       
                clk_count <= 9'd0;
                bit_count <= 2'd0;
            
                control <= 0;
                address <= 4'd0;
                order <= IDLE;

                if (data_ready) begin
                    data_temp <= parallel_data; // load the data from 8-bit shift register
                    data_ready_rst <= 0; // reset the data ready signal

                    state <= state_memory;
                    data_length <= 4'd1; // set the maximum data length to 1 byte

                    data_count <= data_count + 1; // load 1 byte data
                    control <= 1;
                    address <= data_count;

                    order <= SOF; // start generate SOF signal
                end
            end
            state_memory: begin
                clk_count <= clk_count + 1;
                if (clk_count == 9'd127) begin // delay 128 clock cycles, wait for the generation of SOF signal, after that
                    state <= state_send; 
                    control <= 0;
                    address <= 0;
                    order <= DATA; // start to send data
                    clk_count <= 0;
                    bit_count <= 2'd0;
                end  
            end
            state_send: begin
                clk_count <= clk_count + 1;
                if (clk_count == 9'd127) begin
                    clk_count <= 0; 
                    bit_count <= bit_count + 1;
                    if (bit_count == 2'd3) begin
                        bit_count <= 0;
                        address <= address + 1;
                        if (address == data_length) begin // send all the data
                            control <= 0;
                            address <= 4'd0;
                            state <= state_end; 
                            //EOF
                            order <= EOF;   
                        end
                    end
                end
            end
            state_end: begin 
                clk_count <= clk_count + 1;
                if (clk_count == 9'd63) begin
                    state <= state_IDLE; 
                    order <= IDLE;   
                end
            end
        endcase
    end
end

endmodule
