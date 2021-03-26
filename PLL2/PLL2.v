`timescale 1ns/1ps

module PLL2 (
    input wire clk,
    input wire nrst,
    input wire swiptAlive,
    input wire link,
    output reg [31:0] f
);
    wire up, dn, upb, dnb;
    reg counter_rst, prev_counter_rst, vco, clk_go;
    wire [1:0] setting;
    reg [31:0] period;
    reg [31:0] phase_error, pulse_length;
    reg [31:0] f0 = 32'h9C40; //40kHz
    reg [31:0] delf = 32'h1388;
    initial begin
        vco =  0;
        f = f0;
        counter_rst = 0;
        prev_counter_rst = 0;
        phase_error = 0;
        period = 0;
        pulse_length = 0;
    end

    always @(posedge setting[0])begin
        clk_go <= 1;
        counter_rst <= ~counter_rst;
        if(nrst && swiptAlive && setting[1])begin
            f <= f0 - delf * phase_error/pulse_length;
            period <= 1000000000/(f0 - (delf*phase_error/pulse_length));
        end
        else if(nrst && swiptAlive && ~setting[1])begin
            f <= f0 + delf * phase_error/pulse_length;
            period <= 1000000000/(f0 + (delf*phase_error/pulse_length));
        end
        vco <= 1;
        #(period/2) vco <= ~vco;
    end

    always @(negedge setting[0]) begin
        phase_error <= pulse_length;
    end

    always @(posedge clk)begin
        if(~nrst || ~swiptAlive || ~clk_go)begin
            pulse_length <= 0;
        end
        else if(prev_counter_rst == counter_rst)begin
            pulse_length <= pulse_length + 1;
        end
        else begin
            prev_counter_rst <= counter_rst;
            pulse_length <= 1;
        end
    end


    PFD inst_pfd(
            .link (link),
            .vco (vco),
            .setting (setting),
            .up (up),
            .dn (dn),
            .upb (upb),
            .dnb (dnb)
    );
endmodule