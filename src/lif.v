`default_nettype none

module lif (
    input wire [7:0] current,
    input wire       clk,
    input wire       rst_n,
    input reg beta, // weighting not in original code
    output wire      spike,
    output reg [7:0] state
);

    reg [7:0] threshold;
    wire [7:0] next_state;

    always @(posedge clk) begin
        if (!rst_n) begin
            state <= 0;
            threshold <= 230;
            //beta <= 0;
        end else begin
            state <= next_state;
        end
    end

    // U[t] = BU[t-1] + WX[t] - Sout[t-1]*theta
    // Sout[t] = 1 if U[t]>theta; else 0

    // adaptive threshold
    // theta[t] = theta0 + b[t]
    // b[t+1] = alpha*b[t] + (1-alpha)*Sout[t]

    // Update weight for STDP
    // if tpost > tpre then dW = A * exp(dt/tau); else A * exp(-dt/tau)

    // next_state logic and spiking logic
    assign spike = (state >= threshold);

    // next state = Ut+1, and state = Ut.  This equation is Ut+1 = I + Ut * beta where beta is the weighting
    // Example code he shift uses (state >> 1)+(state >> 2)+(state >> 3) which gives 0.5+0.25+0.125=0.875 but I will change the weights for STDP
    //[OLD] assign next_state = (spike ? 0 : current) + (spike ? 0 : (state >> 1)+(state >> 2)+(state >> 3));
    if (beta == 1'b1) // beta controls the weights
        begin
            assign next_state = (spike ? 0 : current) + (spike ? 0 : (state >> 1)); // big weight
        end
    else
        begin
            assign next_state = (spike ? 0 : current) + (spike ? 0 : (state >>3)); // small weight
        end
    //assign next_state = (spike ? 0 : current) + (spike ? 0 : (state >> 1)+(state >> 2)+(state >> 3));

endmodule
