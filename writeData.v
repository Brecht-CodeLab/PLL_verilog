`timescale 1ns/1ps

module Data (
	input wire clk,
	input wire nrst,
	input wire swiptAlive,
	input wire data_start,
    input wire write,
	input wire [39:0] data_stream,
    output reg done,
	output wire dout,
	);
    reg done;
    reg [19:0] write_timer_default = 20'h30D40; //2ms
	reg [19:0] write_timer = 20'h30D40;
	reg [7:0] stream_counter = 8'h27;
    
    initial begin
        done = 0;
    end

    always @(posedge write) begin
        done <= 0;
    end

    always @(posedge clk) begin
        if(~nrst || ~swiptAlive)begin
            write_timer <= write_timer_default;
            stream_counter <= 8'h27;
        end
        else if(write && write_timer == 0)begin
            if (stream_counter == 0)begin
                stream_counter <= 8'h27;
                done <= 1;
            end
            else begin
                stream_counter <= stream_counter - 1;
            end
            dout_reg <= datastream[stream_counter];
            write_timer <= write_timer_default;
        end
        else if(write)begin
            write_timer <= write_timer - 1;
        end
    end
endmodule