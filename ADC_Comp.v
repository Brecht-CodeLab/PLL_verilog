`timescale 1ns/1ps

module ADC_Comp (
    input wire clk,
    input wire nrst,
    input wire swiptAlive,
    input wire [11:0] ADC,
    output reg ADC_comp
);
    reg [11:0] ADC_reg = 0;
    reg [8:0] counter = 9'hC8;
    reg [8:0] counter_default = 9'hC8;
    reg measure_ADC = 0;

    always @(posedge clk) begin
        if(~nrst || ~swiptAlive)begin
            ADC_reg <= 0;
            ADC_comp <= 0;
        end
        if(ADC >= 0)begin
            ADC_reg <= ADC;
        end
        
        if(~nrst || ~swiptAlive)begin
            counter <= counter_default;
            measure_ADC <= 0;
        end
        else if(counter == 0)begin
            counter <= counter_default;
            measure_ADC <= 1;
            if (ADC_reg > 12'h7FF) begin
                ADC_comp <= 0;
            end
            else if (ADC_reg < 12'h800) begin
                ADC_comp <= 1;
            end
        end
        else begin
            counter <= counter - 1;
            measure_ADC <= 0;
        end
    end
endmodule
