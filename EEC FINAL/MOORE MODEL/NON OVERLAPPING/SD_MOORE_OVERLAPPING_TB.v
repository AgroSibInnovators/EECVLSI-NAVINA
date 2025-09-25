`timescale 1ns/1ps

module tb;
    reg clk, rstn, in;
    wire detected;
    wire [2:0] state;

    // Instantiate DUT
    seq_detector dut (.clk(clk), .rstn(rstn), .in(in), .detected(detected), .prs_st(state));

    // Clock generation
    always #5 clk = ~clk;

    // Input sequence to feed
    reg [15:0] seq = 16'b1101_0110_1011_0101; // Example input stream
    integer i;

    initial begin
        // Print sequences before execution
        $display("==============================================");
      $display(" MOORE METHOD : OVERLAPPING");
        
        $display(" Target Sequence to Detect : 1011");
      $display(" Input Sequence Given: %b", seq);
        $display("==============================================");

        // Dump for EPWave
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);

        // Monitor signals live
      $monitor("Time=%0t   | clk=%b | rstn=%b | in=%b | det=%b | state=%0d",
                 $time, clk, rstn, in, detected, state);

        clk = 0; rstn = 0; in = 0;
        #12 rstn = 1;

        // Apply sequence bit by bit
        for (i = 15; i >= 0; i = i - 1) begin
            in = seq[i];
            #10;
            if (detected)
                $display(" Sequence detected at time %0t (index %0d)", $time, i);
        end

        #20;
        $finish;
    end
endmodule
