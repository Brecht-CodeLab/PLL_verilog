`timescale 1ns/1ps

module ADC_Comp (
    input wire clk,
    input wire nrst,
    input wire swiptAlive,
    input wire [11:0] ADC,
    output reg ADC_comp
);
    always @(posedge clk) begin
        if(~nrst || ~swiptAlive)begin
            ADC_comp <= 0;
        end
        else if (ADC > 12'h7FF) begin
            ADC_comp <= 0;
        end
        else if (ADC < 12'h800) begin
            ADC_comp <= 1;
        end
    end
endmodule
