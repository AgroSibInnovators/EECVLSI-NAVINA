// tb.v - Testbench for Mealy Overlapping Sequence Detector
`timescale 1ns/1ps

module tb;
    reg clk, rstn, in;
    wire detected;
    wire [2:0] state;

    // Instantiate DUT
    seq_detector_mealy dut (
        .clk(clk),
        .rstn(rstn),
        .in(in),
        .detected(detected),
        .prs_st(state)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Example input stream
    reg [15:0] seq = 16'b1101_0110_1011_0111;  // includes overlapping cases
    integer i;

    initial begin
        // Print banner
        $display("==============================================");
        $display(" MEALY METHOD : OVERLAPPING");
        $display(" Target Sequence to Detect : 1011");
        $display(" Input Sequence to be Given: %b", seq);
        $display("==============================================");

        // Dump for EPWave
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);

        // Monitor live signals
        $monitor("Time=%0t | clk=%b | rstn=%b | in=%b | det=%b | state=%0d",
                  $time, clk, rstn, in, detected, state);

        // Init
        clk = 0; rstn = 0; in = 0;
        #12 rstn = 1;

        // Apply input sequence bit-by-bit
        for (i = 15; i >= 0; i = i - 1) begin
            in = seq[i];
            #10;
            if (detected)
                $display(" Sequence 1011 detected at time %0t (bit index %0d)", $time, i);
        end

        #20 $finish;
    end
endmodule
