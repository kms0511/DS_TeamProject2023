`timescale 1ns / 1ps


module ball(input clk, input rst,input frame_tick,
input [9:0] x, y, 
output reg [9:0] ball_x, ball_y, 
input [4:0] key, key_pulse, input [2:0] turn_st, output ball_on,
input [3:0] vx_in, vy_in, output [3:0] vx_out, vy_out, output [1:0] xdir, ydir,
input [9:0] ball_x_in1, ball_y_in1, input [4:0] vx_in_1, vy_in_1, input [1:0] xdir_1, ydir_1,
input [9:0] ball_x_in2, ball_y_in2, input [4:0] vx_in_2, vy_in_2, input [1:0] xdir_2, ydir_2,
input [9:0] ball_x_in3, ball_y_in3, input [4:0] vx_in_3, vy_in_3, input [1:0] xdir_3, ydir_3,
input [9:0] ball_x_in4, ball_y_in4, input [4:0] vx_in_4, vy_in_4, input [1:0] xdir_4, ydir_4,
input [9:0] ball_x_in5, ball_y_in5, input [4:0] vx_in_5, vy_in_5, input [1:0] xdir_5, ydir_5
);

parameter BALL_RAD = 15;
parameter RD_X = 85;
parameter RD_Y = 150;
parameter ST_X = 319;
parameter ST_Y = 449;

// wall collison detect

parameter FIELD_TOP = 5;   // hdmi cut issue -> change from 1 to 5
parameter FIELD_LEFT = 169;
parameter FIELD_RIGHT = 470;
parameter FIELD_BOTTOM = 448;

wire reach_top, reach_bottom, reach_left, reach_right;

assign reach_top = ((ball_y-BALL_RAD)<= FIELD_TOP)? 1 : 0;
assign reach_bottom = ((ball_y+BALL_RAD)>= FIELD_BOTTOM)? 1 : 0;
assign reach_left = ((ball_x-BALL_RAD)<= FIELD_LEFT)? 1 : 0;
assign reach_right = ((ball_x+BALL_RAD)>= FIELD_RIGHT)? 1 : 0;


// other ball collision detect (not ready)

//input is ball_x_in1,2,3...
wire [19:0] meet_ball1_sqr, meet_ball2_sqr,meet_ball3_sqr,meet_ball4_sqr,meet_ball5_sqr,ball_rad_sqr;
wire meet_ball1,meet_ball2,meet_ball3,meet_ball4,meet_ball5;
reg [3:0] vx_c, vy_c;

assign ball_rad_sqr = ((BALL_RAD+BALL_RAD)*(BALL_RAD+BALL_RAD));

assign meet_ball1_sqr = (((ball_x - ball_x_in1)*(ball_x - ball_x_in1)) + ((ball_y - ball_y_in1)*(ball_y - ball_y_in1)));  // 조건을 같은경우로 수정해보기.
assign meet_ball1 = (meet_ball1_sqr <= ball_rad_sqr)? 1:0;

assign meet_ball2_sqr = (((ball_x - ball_x_in2)*(ball_x - ball_x_in2)) + ((ball_y - ball_y_in2)*(ball_y - ball_y_in2)));
assign meet_ball2 = (meet_ball2_sqr <= ball_rad_sqr)? 1:0;

assign meet_ball3_sqr = (((ball_x - ball_x_in3)*(ball_x - ball_x_in3)) + ((ball_y - ball_y_in3)*(ball_y - ball_y_in3)));
assign meet_ball3 = (meet_ball3_sqr <= ball_rad_sqr)? 1:0;

assign meet_ball4_sqr = (((ball_x - ball_x_in4)*(ball_x - ball_x_in4)) + ((ball_y - ball_y_in4)*(ball_y - ball_y_in4)));
assign meet_ball4 = (meet_ball4_sqr <= ball_rad_sqr)? 1:0;

assign meet_ball5_sqr = (((ball_x - ball_x_in5)*(ball_x - ball_x_in5)) + ((ball_y - ball_y_in5)*(ball_y - ball_y_in5)));
assign meet_ball5 = (meet_ball5_sqr <= ball_rad_sqr)? 1:0;


//for direction

reg [1:0] xdir;    // 0 for stop,  2 for left, 1 for right
reg [1:0] ydir;  // 0 for stop, 2 for up, 1 for down
reg [9:0] dx, dy; // 변화량


reg [31:0] so2;
wire checkclk;

always @ (posedge clk or posedge rst) begin
if(rst) so2<=0;
else
    if (so2==403000-1) so2<=0;
    else so2<=so2+1;
end
assign checkclk = (so2==403000-1)?1'b1 : 1'b0;  //0.016sec

always @(posedge clk or posedge rst) begin
    if(rst) xdir <= 0;
    else if(turn_st==1) xdir <= 1;
    else if(turn_st==5) xdir <= 0;
    //else if (reach_left) xdir <= 1;
    //else if (reach_right) xdir <= 2;
    else if (turn_st==3) begin
    if (reach_left) xdir <= 1;
    else if (reach_right) xdir <= 2;
    else if (meet_ball1) xdir <= xdir_1;
    else if (meet_ball2) xdir <= xdir_2;
    else if (meet_ball3) xdir <= xdir_3;
    else if (meet_ball4) xdir <= xdir_4;
    else if (meet_ball5) xdir <= xdir_5;
    end
    else if (turn_st==0) begin
    if (reach_left) xdir <= 1;
    else if (reach_right) xdir <= 2;
    else if (meet_ball1 | meet_ball2 | meet_ball3 | meet_ball4 | meet_ball5) begin if(xdir==2) xdir <= 1; else if(xdir==1) xdir <= 2; else if(xdir==0) xdir<=0; end
    end
    else if (turn_st==4) begin
    if (reach_left) xdir <= 1;
    else if (reach_right) xdir <= 2;
    end
    else xdir<=xdir;
    end
    /*
        else if ((meet_ball1)&(turn_st==3)) xdir <= xdir_1;
        else if ((meet_ball2)&(turn_st==3)) xdir <= xdir_2;
        else if ((meet_ball3)&(turn_st==3)) xdir <= xdir_3;
        else if ((meet_ball4)&(turn_st==3)) xdir <= xdir_4;
        else if ((meet_ball5)&(turn_st==3)) xdir <= xdir_5;
        
        else if ((meet_ball1 | meet_ball2 | meet_ball3 | meet_ball4 | meet_ball5)&(turn_st==0)) begin if(xdir==2) xdir <= 1; else if(xdir==1) xdir <= 2; else if(xdir==0) xdir<=0; end
        else xdir<=xdir;
        end
*/

always @(posedge clk or posedge rst) begin
    if(rst) ydir <= 2;
    else if(turn_st==1) ydir <= 2;
   // else if(reach_top) ydir <= 1;
   // else if (reach_bottom) ydir <= 2;
    else if (turn_st==3) begin
    if(reach_top) ydir <= 1;
    else if (reach_bottom) ydir <= 2;
    else if (meet_ball1) ydir <= ydir_1;
    else if (meet_ball2) ydir <= ydir_2;
    else if (meet_ball3) ydir <= ydir_3;
    else if (meet_ball4) ydir <= ydir_4;
    else if (meet_ball5) ydir <= ydir_5;
    end
    else if (turn_st==0) begin
    if(reach_top) ydir <= 1;
    else if (reach_bottom) ydir <= 2;
    else if (meet_ball1 | meet_ball2 | meet_ball3 | meet_ball4 | meet_ball5) begin if(ydir==2) ydir <= 1; else if(ydir==1) ydir <= 2; else if(ydir==0) ydir<=0; end
    end
    else ydir<=ydir;
    end   
       
        
   /*     else if ((meet_ball1)&(turn_st==3)) ydir <= ydir_1;
        else if ((meet_ball2)&(turn_st==3)) ydir <= ydir_2;
        else if ((meet_ball3)&(turn_st==3)) ydir <= ydir_3;
        else if ((meet_ball4)&(turn_st==3)) ydir <= ydir_4;
        else if ((meet_ball5)&(turn_st==3)) ydir <= ydir_5;
        
        else if ((meet_ball1 | meet_ball2 | meet_ball3 | meet_ball4 | meet_ball5)&(turn_st==0)) begin if(ydir==2) ydir <= 1; else if(ydir==1) ydir <= 2; else if(ydir==0) ydir<=0; end
        else ydir<=ydir;
        end
        */

always @(*) begin  //test를 위해 in뒤의 /2 전부 날림.
    if(rst) vx_c <= 0;
    else if(turn_st==0) begin
        if (meet_ball1) vx_c <= vx-1; 
        else if (meet_ball2) vx_c <= vx-1;
        else if (meet_ball3) vx_c <= vx-1;
        else if (meet_ball4) vx_c <= vx-1;
        else if (meet_ball5) vx_c <= vx-1;
        else vx_c <= vx_c;
        end
    else if(turn_st==3) begin
        if (meet_ball1) vx_c <= vx_in_1; 
        else if (meet_ball2) vx_c <= vx_in_2;
        else if (meet_ball3) vx_c <= vx_in_3;
        else if (meet_ball4) vx_c <= vx_in_4;
        else if (meet_ball5) vx_c <= vx_in_5;   
        else vx_c <= vx_c; 
        end
        else vx_c <= vx_c;
end

always @(*) begin
    if(rst) vy_c <= 0;
    else if(turn_st==0) begin
        if (meet_ball1) vy_c <= vy-1;
        else if (meet_ball2) vy_c <= vy-1;
        else if (meet_ball3) vy_c <= vy-1;
        else if (meet_ball4) vy_c <= vy-1;
        else if (meet_ball5) vy_c <= vy-1;
        else vy_c <= vy_c;
        end
    else if(turn_st==3) begin
        if (meet_ball1) vy_c <= vy_in_1;
        else if (meet_ball2) vy_c <= vy_in_2;
        else if (meet_ball3) vy_c <= vy_in_3;
        else if (meet_ball4) vy_c <= vy_in_4;
        else if (meet_ball5) vy_c <= vy_in_5;
        else vy_c <= vy_c;
        end
        else  vy_c <= vy_c;
end

wire meetballs;
assign meetballs = (meet_ball1 | meet_ball2 | meet_ball3 | meet_ball4 | meet_ball5)? 1 : 0;

//for speed auto reduce

reg [31:0] so;
wire speeddown;
reg [3:0] vx, vy;

always @ (posedge clk or posedge rst) begin
if(rst) so<=0;
else
    if (so==15000000-1) so<=0;
    else so<=so+1;
end
assign speeddown = (so==15000000-1)?1'b1 : 1'b0;  //0.6sec

//for speed

always @ (posedge clk or posedge rst) begin
if(rst) begin vx<=0; vy<=0; end
else if ((turn_st==0)&(key_pulse==5'h14)) begin vx <= vx_in; vy <= vy_in; end
// else if ((meet_ball1 | meet_ball2 | meet_ball3 | meet_ball4 | meet_ball5)&(turn_st==3)) begin vx<=vx_c; vy<=vy_c; end
else if (meetballs) begin vx<=vx_c; vy<=vy_c; end
else if((meetballs==0)&(speeddown)&((turn_st==0) | (turn_st==3))) begin if (vx<1) vx <=0; else if(vx > 0) vx <= vx/2;
                         if (vy<1) vy <=0; else if(vy > 0) vy <= vy/2;
end
else begin vx <= vx; vy <= vy; end
end


// movement

/*
always @(posedge clk or posedge rst) begin
    if(rst) begin
        dx <= 0;
        dy <= 0;
    end
    else begin
        dx <= xdir*vx;
        dy <= ydir*vy;
    end
end
*/

// ball coordinate

always @(posedge clk or posedge rst) begin    //ball_x
    if(rst | turn_st==2) begin // if not your turn, stay at waiting area
        ball_x <= RD_X;
    end
    else if(turn_st==1) begin // if your turn, teleport to start area
        ball_x <= ST_X;
    end
    else if((turn_st==4)&(frame_tick)) begin // if in dir select mode
       if(xdir==1) ball_x <= ball_x+3;
       else if(xdir==2) ball_x <= ball_x-3;
    end
    
    else if(((turn_st==0) | (turn_st==3))&(meetballs==1))  // if your turn, move | after your turn, keep react.
         begin
         if(xdir==1) ball_x <= ball_x + vx;
         else if(xdir==2) ball_x <= ball_x - vx;
         end
         
         
    else if(((turn_st==0) | (turn_st==3))&(frame_tick)&(meetballs==0))  // if your turn, move | after your turn, keep react.
         begin
         if(xdir==1) ball_x <= ball_x + vx;
         else if(xdir==2) ball_x <= ball_x - vx;
         end
    else if(turn_st==5) ball_x <=ball_x;
    end
    
    
always @(posedge clk or posedge rst) begin //ball_y
    if(rst | turn_st==2) begin // if not your turn, stay at waiting area
        ball_y <= RD_Y;
    end
    else if(turn_st==1) begin // if your turn, teleport to start area
        ball_y <= ST_Y;
    end
    
        else if(((turn_st==0) | (turn_st==3))&(meetballs==1))  // if your turn, move | after your turn, keep react.
         begin 
         if(ydir==1) ball_y <= ball_y + vy;
         else if(ydir==2) ball_y <= ball_y - vy; 
         end
         
        
    else if(((turn_st==0) | (turn_st==3))&(frame_tick)&(meetballs==0))  // if your turn, move | after your turn, keep react.
         begin 
         if(ydir==1) ball_y <= ball_y + vy;
         else if(ydir==2) ball_y <= ball_y - vy; 
         end
    else if(turn_st==5) ball_y<=ball_y;
    end



//draw ball shape

wire [19:0] distance;

assign distance = (((ball_x-x)*(ball_x-x)) + ((ball_y-y)*(ball_y-y)));
assign ball_on = (BALL_RAD*BALL_RAD >= distance)? 1 : 0;


endmodule

