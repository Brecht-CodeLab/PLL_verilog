`timescale 1ps/1ps

module PFD (
    input wire link,
    input wire vco,
    output wire [1:0] setting,
    output wire up,
    output wire dn,
    output wire upb,
    output wire dnb
);
    wire fv_rst, fr_rst, reset;
    reg q0, q1;

    initial begin
        q0 = 0;
        q1 = 0;
    end

    always @(posedge vco or posedge fv_rst)begin
        q0 <= (fv_rst) ? 0 : 1;
    end
    always @(posedge link or posedge fr_rst) begin
        q1 <= (fr_rst) ? 0 : 1;
    end

    assign up = q1;
    assign dn = q0;
    assign setting[0] = q1 | q0;
    assign setting[1] = q0;
    assign upb = ~q0;
    assign dnb = ~q1;
    assign fv_rst = reset | (q0 & q1);
    assign fr_rst = reset | (q0 & q1);
    assign reset = vco & link;
endmodule