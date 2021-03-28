`timescale 1ns/1ps

module PLL2 (
    input wire clk,
    input wire nrst,
    input wire swiptAlive,
    input wire freq_rdy,
    input wire link,
    output reg [31:0] f
);
    wire up, dn, upb, dnb;
    reg counter_rst, prev_counter_rst, vco, clk_go;
    wire [1:0] setting;
    reg [31:0] period, half_period, cnt;
    reg [31:0] phase_error, pulse_length;
    reg [31:0] f0 = 32'h8CA0; //41kHz
    reg [31:0] delf = 32'h2EE0; //15kHz
    initial begin
        vco =  0;
        f = f0;
        counter_rst = 0;
        prev_counter_rst = 0;
        phase_error = 0;
        period = 0;
        half_period = 0;
        pulse_length = 0;
        clk_go = 0;
        cnt <= 32'h4E2;
    end

    always @(posedge setting[0])begin
        clk_go <= 1;
        counter_rst <= ~counter_rst;
        if(nrst && swiptAlive && setting[1])begin
            f <= f + delf * phase_error/pulse_length;
            period <= 100000000/(f0 - (delf*phase_error/pulse_length));
        end
        else if(nrst && swiptAlive && ~setting[1])begin
            f <= f - delf * phase_error/pulse_length;
            period <= 100000000/(f0 + (delf*phase_error/pulse_length));
            //half_period <= 500000000/(f0 + (delf*phase_error/pulse_length));
        end
    end

    always @(negedge setting[0]) begin
        phase_error <= pulse_length;
    end

    always @(posedge clk)begin
        if (freq_rdy && nrst && swiptAlive) begin
            if(cnt == 0)begin
                vco <= ~vco;
                cnt <= 100000000/f0;
            end
            else begin
                cnt <= cnt - 1;
            end
        end
        else if(half_period == 0)begin
            vco <= ~vco;
            half_period <= period/2;
        end
        else begin
            half_period <= half_period - 1;
        end


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