`timescale 1ps/1ps

module divider(
    input wire in,
    output reg out
);
    parameter divide_ratio = 4;
    integer i = 0;
    
    always @(posedge in) begin
      if (i < (divide_ratio/2)-1)begin
        out = 0;
        i = i + 1;
      end
      else if (i == (divide_ratio/2)-1)begin
        out = 1;
        i = i + 1;
      end
      else if (i < (divide_ratio)-1)begin
        out = 1;
        i = i + 1;
      end
      else if (i == (divide_ratio)-1)begin
        out = 0;
        i = 0;
      end
    end
endmodule