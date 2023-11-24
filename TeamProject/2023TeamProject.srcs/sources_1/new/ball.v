`timescale 1ns / 1ps


module ball(input clk, input rst,
input  [9:0] x, input [9:0] y, 
output reg [9:0] ball_x, output reg [9:0] ball_y, 
input [4:0] key, input [4:0] key_pulse, input [1:0] turn_st, output [11:0] ball_color, output ball_on);
parameter BALL_RAD = 10;
parameter RD_X = 85;
parameter RD_Y = 150;
parameter ST_X = 319;
parameter ST_Y = 449;

parameter FIELD_TOP = 1; 
parameter FIELD_LEFT = 169;
parameter FIELD_RIGHT = 470;
parameter FIELD_BOTTOM = 448;

wire [9:0] current_ball_x,current_ball_y;

assign x = current_ball_x; //ball의 x
assign y = current_ball_y; //ball의 y

assign ball_on = (BALL_RAD*BALL_RAD >= (x-ball_x)*(x-ball_x) + (y-ball_y)*(y-ball_y))? 1 : 0; //ball이 있는 영역

wire reach_top, reach_bottom, reach_left, reach_right;

assign reach_top = ((ball_x-BALL_RAD)<= FIELD_TOP) ? 1 : 0;
assign reach_bottom = ((ball_x+BALL_RAD)>= FIELD_TOP) ? 1 : 0;
assign reach_left = ((ball_y-BALL_RAD)<= FIELD_LEFT) ? 1 : 0;
assign reach_right = ((ball_y+BALL_RAD)>= FIELD_RIGHT) ? 1 : 0;

reg [1:0] xdir;    // 0 for stop, 1 for left, 2 for right
reg [1:0] ydir;  // 0 for stop, 1 for fwd, 2 for bwd

always @(posedge clk or posedge rst) begin  // 벽 충돌로 방향 전환
    if(rst) begin
        xdir <= 0;
        ydir <= 1;
    end
    else begin
        if(reach_top) ydir <= 2;
        else if (reach_left) xdir <= 2;
        else if (reach_right) xdir <= 1;
        end
end

always @(posedge clk or posedge rst) begin // 공 좌표 이동
    if(rst | turn_st==2) begin // 공의 차례가 아닐 때, 대기장소에 대기.
        ball_x <= RD_X;
        ball_y <= RD_Y;
    end
    else if(turn_st) begin //이 공의 차례가 오면 텔레포트
        ball_x <= ST_X;
        ball_y <= ST_Y;
    end
    else begin
        ball_x <= ball_x + dx;
        ball_y <= ball_y + dy;
    end
end


endmodule
