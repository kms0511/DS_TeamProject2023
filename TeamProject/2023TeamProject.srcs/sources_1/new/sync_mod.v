`timescale 1ns / 1ps

module sync_mod(rst, clk, x, y, video_on, vsync, hsync);
input rst, clk;
output [9:0] x, y;
output video_on, vsync, hsync; 
     
reg [9:0] c_v, c_h; 
wire trig; 
    
always @ (posedge clk, posedge rst) begin 
    if (rst) c_h <= 0; 
    else if (c_h == 799) c_h <= 0;
    else c_h <= c_h + 1;
end

assign trig = (c_h == 799)? 1 : 0; 

always @ (posedge clk, posedge rst) begin 
    if (rst) c_v <= 0;
    else if (trig) begin
        if (c_v == 523) c_v <= 0;
        else c_v <= c_v + 1;
    end
end

assign hsync = (c_h>=656 && c_h<752)? 0 : 1;
assign vsync = (c_v>=491 && c_v<493)? 0 : 1;

assign x = (c_h<640)? c_h : 0; //640x480 화면 구역 내의 x 좌표
assign y = (c_v<480)? c_v : 0; //640x480 화면 구역 내의 y 좌표
assign video_on = (c_h<640 && c_v<480)? 1 : 0;

endmodule
