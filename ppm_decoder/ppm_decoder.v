//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/22 13:50:00
// Design Name: 
// Module Name: ppm_decoder
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

module ppm_decoder(
    input wire clk,
    input wire rst,
    input wire Din,
    output reg [7:0] Dout,
    output reg D_en, // data enable
    output reg F_en // frame enable
);

parameter state_IDLE = 2'd0;
parameter state_WAIT = 2'd1;
parameter state_DECODE = 2'd2;

reg [2:0] state;
reg [7:0] clk_count;
reg [2:0] bit_count;
reg [1:0] data_bit;
reg [7:0] data_byte;
reg [1:0] frame_check_stage;

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        state <= state_IDLE;
        clk_count <= 8'd0;
        bit_count <= 3'd0;
        data_bit <= 2'd0;
        data_byte <= 8'd0;
        D_en <= 1'b0;
        F_en <= 1'b0;
        frame_check_stage <= 0;
        Dout <= 0;
    end else begin
        case (state)
            state_IDLE: begin
                clk_count <= 8'd0;
                bit_count <= 3'd0;
                data_bit <= 2'd0;
                data_byte <= 8'd0;
                D_en <= 1'b0;
                F_en <= 1'b0;
                frame_check_stage <= 0;
                Dout <= 0;
                if (Din == 1'b0) begin
                    clk_count <= clk_count + 1;
                    state <= state_WAIT; 
                end
            end
            state_WAIT: begin // detect SOF
                if(clk_count < 8'd128) begin
                    clk_count <= clk_count + 1;
                    case (frame_check_stage)
                        2'd0: begin
                            if (Din == 1'b1)
                                state <= state_IDLE;
                            else begin
                                if (clk_count == 8'd15)
                                    frame_check_stage <= 2'd1;
                            end
                        end
                        2'd1: begin
                            if (Din == 1'b0)
                                state <= state_IDLE;
                            else begin
                                if (clk_count == 8'd79)
                                    frame_check_stage <= 2'd2;
                            end
                        end
                        2'd2: begin
                            if (Din == 1'b1)
                                state <= state_IDLE;
                            else begin
                                if (clk_count == 8'd95)
                                        frame_check_stage <= 2'd3;
                            end
                        end
                        2'd3: begin
                            if (Din == 1'b0)
                                state <= state_IDLE;
                            else begin 
                                if (clk_count == 8'd127) begin
                                    state <= state_DECODE;
                                    clk_count <= 8'd0;
                                    frame_check_stage <= 0;                                  
                                    bit_count <= 3'd0;
                                    data_bit <= 2'd0;
                                    data_byte <= 8'd0;                        
                                    D_en <= 1'b0;
                                    F_en <= 1'b1; // SOF detected
                                end
                            end
                        end
                    endcase
                end
            end
            state_DECODE: begin
                D_en <= 1'b0;
                F_en <= 1'b0;
                if (clk_count < 9'd128) begin
                    clk_count <= clk_count + 1;
                    if (bit_count < 3'd4) begin
                        if (clk_count == 9'd127) begin // shift the 2-bit decoded data
                            clk_count <= 0;
                            bit_count <= bit_count + 1;
                            Dout <= {data_byte[1:0], Dout[7:2]}; // MSB first
                        end else begin
                            if (Din == 1'b0) begin
                                if (clk_count != 9'd32) begin
                                    data_bit <= ((clk_count + 1) / 16 - 1) / 2; // map the clock count to the bit position
                                    data_byte <= {data_bit, data_byte[7:2]};
                                end else begin // detect EOF
                                    state <= state_IDLE;
                                    clk_count <= 8'd0;
                                    bit_count <= 3'd0;
                                    data_bit <= 2'd0;
                                    data_byte <= 8'd0;
                                    Dout <= 8'd0; 
                                end
                            end
                        end
                    end else begin // end of 1-byte data
                        bit_count <= 0;
                        clk_count <= 0;
                        data_bit <= 0;
                        data_byte <= 0;
                        D_en <= 1'b1;
                    end        
                end
            end
        endcase
    end
end

endmodule
