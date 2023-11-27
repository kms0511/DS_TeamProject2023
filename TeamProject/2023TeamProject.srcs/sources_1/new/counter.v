`timescale 1ns / 1ps


module counter(input clk, input rst, output cnt_en);
parameter SIZE = 25175000;
reg [25:0] o;

always @ (posedge clk or posedge rst) begin
if(rst) o<=0;
else
    if (o==SIZE-1) o<=0;
    else o<=o+1;
end
assign cnt_en = (o==SIZE-1)?1'b1 : 1'b0;
endmodule


