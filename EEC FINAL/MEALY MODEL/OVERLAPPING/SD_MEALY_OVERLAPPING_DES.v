// design.v - Sequence Detector for "1011" (Mealy, Overlapping)
module seq_detector_mealy (
    input  wire clk,
    input  wire rstn,      // active-low reset
    input  wire in,
    output reg  detected,
    output reg [2:0] prs_st  // expose state for monitoring
);

    // State encoding
    typedef enum reg [2:0] {
        S0, // idle
        S1, // saw '1'
        S2, // saw '10'
        S3  // saw '101'
    } state_t;

    state_t state, next_state;

    // Next state & output logic (Mealy)
    always @(*) begin
        next_state = state;
        detected   = 0;   // default

        case (state)
            S0: begin
                next_state = in ? S1 : S0;
            end

            S1: begin
                next_state = in ? S1 : S2;
            end

            S2: begin
                next_state = in ? S3 : S0;
            end

            S3: begin
                if (in) begin
                    detected   = 1;   // ✅ Detect sequence "1011" here
                    next_state = S1;  // overlap allowed (reuse trailing '1')
                end else begin
                    next_state = S2;
                end
            end

            default: next_state = S0;
        endcase
    end

    // State register update
    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            state <= S0;
        else
            state <= next_state;
    end

    // Expose state for testbench
    always @(*) begin
        prs_st = state;
    end
endmodule
