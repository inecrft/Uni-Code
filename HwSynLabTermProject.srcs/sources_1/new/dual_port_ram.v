`timescale 1ns / 1ps

module dual_port_ram
    #(
        parameter DATA_SIZE = 7,
        parameter ADDR_SIZE = 12
    )
    (
    input clk,
    input we,
    input reset,
    input [ADDR_SIZE-1:0] addr_a, addr_b,
    input [DATA_SIZE-1:0] din_a,
    output [DATA_SIZE-1:0] dout_a, dout_b
    );
    
    // Infer the RAM as block ram
    (* ram_style = "block" *) reg [DATA_SIZE-1:0] ram [2**ADDR_SIZE-1:0];
    
    reg [ADDR_SIZE-1:0] addr_a_reg, addr_b_reg;
    reg state;
    singlePulser sp(reset, clk, reset_sp);
    
    integer i;
    integer j;
    // body
    always @(posedge clk) begin
//        if (reset_sp)
//            state <= ~state;
//        else 
        if(we)      // write operation
            ram[addr_a] <= din_a;
//            ram[addr_a] <= {state, din_a};
            
        addr_a_reg <= addr_a;
        addr_b_reg <= addr_b;
    end
    
    // two read operations        
//    assign dout_a = (ram[addr_a_reg][DATA_SIZE] == state) ? ram[addr_a_reg] : 0;
    assign dout_a = ram[addr_a_reg];
    assign dout_b = ram[addr_b_reg];
//    assign dout_b = (ram[addr_b_reg][DATA_SIZE] == state) ? ram[addr_b_reg] : 0;
    
endmodule