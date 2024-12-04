`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/10/2024 01:40:27 PM
// Design Name: 
// Module Name: SinglePulser
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


module singlePulser(
    input in,
    input clk,
    output out
    );
    
    reg [1:0] state;
    reg out;
    initial 
    begin
        state = 2'b00;
        out = 0;
    end
    
    always @(posedge clk)
    begin
        case(state)
            2'b00 : begin
                if (in == 1) begin
                    state = 2'b01;
                    out = 1;
                end
            end
            2'b01 : begin
                out = 0;
                if (in == 1) begin
                    state = 2'b10;
                end else begin
                    state = 2'b00;
                end
            end
            2'b10 : begin
                if (in == 0)
                    state = 2'b00;
            end
        endcase
    end
    
endmodule
