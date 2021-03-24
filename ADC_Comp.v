`timescale 1ns/1ps

module ADC_Comp (
    input wire clk,
    input wire nrst,
    input wire swiptAlive,
    input wire [11:0] ADC,
    output reg ADC_comp
);
    reg [11:0] ADC_reg = 0;
    reg [8:0] counter = 9'h190;

    always @(posedge clk) begin
        if(~nrst || ~swiptAlive)begin
            ADC_reg <= 0;
            ADC_comp <= 0;
        end
        if(ADC >= 0)begin
            ADC_reg <= ADC;
        end
        
        if(counter == 0)begin
            counter <= 9'h190;
            if (ADC_reg > 12'h7FF) begin
                ADC_comp <= 0;
            end
            else if (ADC_reg < 12'h800) begin
                ADC_comp <= 1;
            end
        end
        else begin
            counter <= counter - 1;
        end
    end
endmodule
