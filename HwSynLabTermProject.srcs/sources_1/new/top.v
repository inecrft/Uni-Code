`timescale 1ns / 1ps

module top(
    input clk,              // 100MHz Basys 3
    input RsRx,
    output RsTx,
    input btnC,              // btnC
    input btnU,               // btnU
    input btnD,             // btnD
    input btnL,             // btnL
    input btnR,            // btnR
    input [15:0] sw,         // sw[6:0] sets ASCII value
    output Hsync, Vsync,    // VGA connector
    output [3:0] vgaRed,
    output [3:0] vgaGreen,
    output [3:0] vgaBlue      // DAC, VGA connector
    );
    
    // UART --------------------------------------------
    wire dataValid;
    wire [7:0] data;
    wire active, done;
    
    debounce_chu db_send(.clk(clk), .reset(sw[15]), .sw(btnC), .db_level(), .db_tick(btnC_tick));
    
    uartRX rx(clk, RsRx, dataValid, data);
    uartTX tx(clk, btnC_tick, sw[7:0], active, RsTx, done);
    // UART --------------------------------------------
   
    // signals
    wire [10:0] w_x;
    wire [9:0] w_y;
    wire w_vid_on, w_p_tick;
    reg [11:0] rgb_reg;
    wire [11:0] rgb_next;
    
    // instantiate vga controller
    vga_controller vga(.clk_100MHz(clk), .reset(sw[15]), .video_on(w_vid_on),
                       .hsync(Hsync), .vsync(Vsync), .p_tick(w_p_tick), 
                       .x(w_x), .y(w_y));
    
    // instantiate text generation circuit
    text_screen_gen tsg(.clk(clk), .reset(sw[15]), .video_on(w_vid_on), .set(dataValid),
                        .up(btnU), .down(btnD), .left(btnL), .right(dataValid),
                        .sw(data[6:0]), .x(w_x), .y(w_y), .rgb(rgb_next));
    
    // rgb buffer
    always @(posedge clk)
        if(w_p_tick)
            rgb_reg <= rgb_next;
            
    // output
    assign {vgaRed, vgaGreen, vgaBlue} = rgb_reg;
    
endmodule