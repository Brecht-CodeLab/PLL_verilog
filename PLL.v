`timescale 1ns/1ps

module PLL #(
    parameter	PHASE_BITS = 32,
    parameter	[0:0] OPT_TRACK_FREQUENCY = 1'b1,
    parameter	[PHASE_BITS-1:0] INITIAL_PHASE_STEP = 0,
    localparam	MSB = PHASE_BITS-1
    ) 
    (
    input wire clk,
    input wire nrst,
    input wire swiptAlive,

    input wire ADC_comp,
    
    input wire load_freq,
    input wire [(MSB-1):0] freq,

    input wire [4:0] lgcoefficient,

    output wire [(PHASE_BITS-1):0] phase,
    output reg [1:0] error
);
    reg agreed_output, lead;
    wire phase_error;
    reg [MSB:0] ctr, phase_correction, freq_correction, freq_step;
    initial begin
        ctr = 0;
        agreed_output = 0;
        error = 2'h0;
        phase_correction = 0;
        freq_correction = 0;
        freq_step = INITIAL_PHASE_STEP;
    end

    if(nrst || swiptAlive)begin
        if((ADC_comp) && (ctr[MSB]))begin
            agreed_output <= 1'b1;
        end
        else if ((!ADC_comp) && (!ctr[MSB]))begin
            agreed_output <= 1'b0;
        end
    end

    always @(posedge clk) begin
        phase_correction <= {1'b1, {(MSB){1'b0}}} >> lgcoefficient;
        freq_correction <= { 3'b001, {(MSB-2){1'b0}} } >> (2*lgcoefficient);

        if(nrst && swiptAlive)begin
            error <= (!phase_error) ? 2'b00 : ((lead) ? 2'b11 : 2'b01);
            if(!phase_error)begin
                ctr <= ctr + freq_step;
            end
            else if (lead)begin
                ctr <= ctr + freq_step - phase_correction;
            end
            else begin
                ctr <= ctr + freq_step + phase_correction;
            end
        end

        if(load_freq)begin
            freq_step <= {1'b0, freq};
        end
        else if((nrst) && (swiptAlive) && (OPT_TRACK_FREQUENCY) && (phase_error))begin
            if(lead)begin
                freq_step <= freq_step - freq_correction;
            end
            else begin
                freq_step <= freq_step + freq_correction;
            end
        end
    end

    always @(*) begin
        if(agreed_output)begin
            lead = (!ctr[MSB]) && (ADC_comp);
        end
        else begin
            lead = (ctr[MSB]) && (!ADC_comp);
        end
    end

    assign phase_error = (ctr[MSB] != ADC_comp);
    assign phase = ctr;

endmodule