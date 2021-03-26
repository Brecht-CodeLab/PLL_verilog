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
    wire fv_rst, reset;
    reg q0, q1;

    always @(posedge vco or posedge fv_rst)begin
        q0 <= (fv_rst) ? 0 : 1;
    end
    always @(posedge link or posedge fv_rst) begin
        q1 <= (fv_rst) ? 0 : 1;
    end

    assign up = q1;
    assign dn = q0;
    assign setting[0] = dn | up;
    assign setting[1] = dn;
    assign upb = ~q0;
    assign dnb = ~q1;
    assign fv_rst = reset | (q0 & q1);
    assign reset = vco & link;
endmodule