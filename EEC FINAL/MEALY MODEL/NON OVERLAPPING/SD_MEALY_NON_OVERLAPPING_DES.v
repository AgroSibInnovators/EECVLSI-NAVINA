// design.v - Mealy Sequence Detector (1011) - Non Overlapping
module seq_detector_mealy (
    input clk,
    input rstn,
    input in,
    output reg detected,
    output reg [2:0] prs_st   // expose state for monitoring
);
    // State encoding
    typedef enum reg [2:0] {
        S0, // initial
        S1, // saw 1
        S2, // saw 10
        S3  // saw 101
    } state_t;

    state_t state, next_state;

    // Next state logic + output (Mealy style)
    always @(*) begin
        next_state = state;
        detected   = 0;   // default
        case (state)
            S0: begin
                if (in) next_state = S1;
                else    next_state = S0;
            end
            S1: begin
                if (in) next_state = S1;
                else    next_state = S2;
            end
            S2: begin
                if (in) next_state = S3;
                else    next_state = S0;
            end
            S3: begin
                if (in) begin
                    detected   = 1;   // Sequence 1011 detected (Mealy → immediate)
                    next_state = S0;  // Non-overlapping: reset to S0
                end
                else begin
                    next_state = S2;
                end
            end
        endcase
    end

    // State update
    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            state <= S0;
        else
            state <= next_state;
    end

    // Mirror FSM state for monitoring
    always @(*) prs_st = state;

endmodule
