module seq_detector (
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
        S3, // saw 101
        S4  // saw 1011
    } state_t;

    state_t state, next_state;

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S1 : S2;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S2;
            S4: next_state = in ? S1 : S2;
        endcase
    end

    // State update
    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            state <= S0;
        else
            state <= next_state;
    end

    // Output logic
    always @(*) begin
        detected = (state == S4);
        prs_st   = state;   // mirror FSM state for testbench
    end
endmodule
