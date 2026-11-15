`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.11.2026 19:58:04
// Design Name: 
// Module Name: tb_synchronizer_fifo
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



module tb_synchronizer_fifo;
    reg clk;
    reg rst;
    reg wr_en;
    reg rd_en;
    reg [7:0] data_in;
    wire [7:0] data_out;
    wire full;
    wire empty;
    // Instantiate the FIFO
    synchronizer_fifo uut (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );
    // Generate clock: 10 ns period
    always #5 clk = ~clk;
    initial begin
        // Initialize inputs
        clk = 0;
        rst = 1;
        wr_en = 0;
        rd_en = 0;
        data_in = 0;
        // Reset
        #20;
        rst = 0;
        // Write data
        repeat (5) begin
            @(negedge clk);
            wr_en = 1;
            data_in = data_in + 1;
        end
        @(negedge clk);
        wr_en = 0;
        data_in = 0;
        // Read data
        repeat (5) begin
            @(negedge clk);
            rd_en = 1;
            @(posedge clk);
            #1;
            $display("Time=%0t, Data Out=%0d, Empty=%b",
                     $time, data_out, empty);
        end
        @(negedge clk);
        rd_en = 0;
        #20;
        $finish;
    end
endmodule

