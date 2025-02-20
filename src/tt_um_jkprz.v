`default_nettype none

module tt_um_jkprz (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

        //parameter int WEIGHT = 1;
        //reg [7:0] junk = 8'b00000000;

        // use bidirectionals as outputs
        assign uio_oe = 8'b11111111;
        //assign uio_out[5:0] = 6'd0;
        assign uio_out[6:0] = 7'd0;

/*
        if(!ena) // error unhappy with not using ena or uio_in
        begin
            junk <= uio_in;
        end
*/


        // instantiate lif neuron
        //lif lif1(.current(ui_in), .clk(clk), .rst_n(rst_n), .spike(uio_out[7]), .state(uo_out));
        lif lif1(.current(ui_in), .clk(clk), .rst_n(rst_n), .beta(8'b00000011), .spike(uio_out[7]), .state(uo_out));

        // Trying to add more, but it's not happy with this.
        //lif lif2(.current(ui_in), .clk(clk), .rst_n(rst_n), .beta(8'b00000011), .spike(uio_out[6]), .state(uo_out));
        // lif lif2(.current({uio_out[7], 7'b0000000}), .clk(clk), .rst_n(rst_n), .spike(uio_out[6]), .state(uo_out));

endmodule
