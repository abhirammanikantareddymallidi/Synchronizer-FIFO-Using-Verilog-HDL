`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.11.2026 19:51:04
// Design Name: 
// Module Name: synchronizer_fifo
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


module synchronizer_fifo(
    input clk,
    input rst,
    input wr_en,
    input rd_en,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg full,
    output reg empty
);
    // FIFO memory: 8 locations, each 8 bits
    reg [7:0] memory [0:7];
    // Read and write pointers
    reg [3:0] wr_ptr;
    reg [3:0] rd_ptr;
    integer i;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            data_out <= 0;
            full <= 0;
            empty <= 1;
            for (i = 0; i < 8; i = i + 1)
                memory[i] <= 0;
        end
        else begin
            // Write operation
            if (wr_en && !full) begin
                memory[wr_ptr[2:0]] <= data_in;
                wr_ptr <= wr_ptr + 1;
            end
            // Read operation
            if (rd_en && !empty) begin
                data_out <= memory[rd_ptr[2:0]];
                rd_ptr <= rd_ptr + 1;
            end
            // FIFO status flags
            if ((wr_ptr + (wr_en && !full)) ==
                (rd_ptr + (rd_en && !empty))) begin
                empty <= 1;
            end
            else begin
                empty <= 0;
            end
            if ((wr_ptr[2:0] == rd_ptr[2:0]) &&
                (wr_ptr[3] != rd_ptr[3])) begin
                full <= 1;
            end
            else begin
                full <= 0;
            end
        end
    end
endmodule