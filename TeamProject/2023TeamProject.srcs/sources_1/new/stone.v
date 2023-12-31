`timescale 1ns / 1ps

module stone(input clk, input rst,input frame_tick, input [9:0] x, y, output reg [9:0] stone_x, stone_y,  //클럭, 리셋, 프레임갱신신호, 현재 출력중인 x,y좌표, 이 모듈의 Stone의 현x,y좌표
input [4:0] key, key_pulse, input [2:0] turn_st, output stone_on, stone_edge, hand_on, real_edge, //키패드입력, 키패드펄스입력 , 턴 상태 입력, Stone 구성요소 표시를 위한 출력4개 
input [3:0] sx_in, sy_in, output [3:0] sx, sy, output [1:0] xdir, ydir, // x속력입력,y속력입력,현재x속력,현재y속력,현재x방향,현재y방향
input [9:0] stone_x_in1, stone_y_in1, input [3:0] sx_in_1, sy_in_1, input [1:0] xdir_1, ydir_1, // 이 Stone 외의 다른stone들의 현재 x,y 좌표, 현재 x,y 속력, 현재 x,y 방향값입력. 
input [9:0] stone_x_in2, stone_y_in2, input [3:0] sx_in_2, sy_in_2, input [1:0] xdir_2, ydir_2,
input [9:0] stone_x_in3, stone_y_in3, input [3:0] sx_in_3, sy_in_3, input [1:0] xdir_3, ydir_3,
input [9:0] stone_x_in4, stone_y_in4, input [3:0] sx_in_4, sy_in_4, input [1:0] xdir_4, ydir_4,
input [9:0] stone_x_in5, stone_y_in5, input [3:0] sx_in_5, sy_in_5, input [1:0] xdir_5, ydir_5,
output broom_on_center,broom_on_up,broom_on_left,broom_on_right,broom_on_center_design,broom_on_up_design, // broom 표시를 위한 출력
output fin
);

parameter STONE_RAD = 15; // Stone의 반지름 정의
parameter STONE_2RAD = STONE_RAD*2; // Stone의 지름 정의
parameter RD_X = 85; // 기본 대기장소 x좌표
parameter RD_Y = 150; // 기본 대기장소 y좌표
parameter ST_X = 319;  // 시작장소 x좌표
parameter ST_Y = 449; // 시작장소 y좌표


reg broom_center, broom_up, broom_left, broom_right;

assign broom_on_center = ((broom_center==1) &&(turn_st==0)&&(x>=(stone_x-20) && x<=(stone_x+20) && y>=(stone_y-25) && y<=(stone_y-19)))? 1 : 0; // 중앙(기본 broom 표시위치) 
assign broom_on_center_design = ((broom_center==1) &&(turn_st==0)&&(x>=(stone_x-10) && x<=(stone_x+10) && y>=(stone_y-23) && y<=(stone_y-20)))? 1 : 0; // 중앙(기본 broom 표시위치)

assign broom_on_up = ((broom_up==1) && (turn_st==0)&&(x>=(stone_x-20) && x<=(stone_x+20) && y>=(stone_y-45) && y<=(stone_y-39)))? 1 : 0; // 위(broom 정면 작동시 표시위치) 
assign broom_on_up_design = ((broom_up==1) && (turn_st==0)&&(x>=(stone_x-10) && x<=(stone_x+10) && y>=(stone_y-43) && y<=(stone_y-40)))? 1 : 0; // 위(broom 정면 작동시 표시위치) 

assign broom_on_left = ((broom_left==1)&&(x>=(stone_x-25) && x<=(stone_x+5) && y>=(stone_y-30) && y<=(stone_y-19)))? 1 : 0; // 왼쪽(broom 왼쪽방향 작동시 표시 위치)
assign broom_on_right = ((broom_right==1)&&(x>=(stone_x+25) && x<=(stone_x+55) && y>=(stone_y-30) && y<=(stone_y-19)))? 1 : 0; // 오른쪽(broom 오른쪽방향 작동시 표시 위치)

reg [1:0] broom_c_state, broom_n_state; 

parameter BROOM_READY = 2'b00, BROOM_SET = 2'b01, BROOM_UP = 2'b10, BROOM_STOP = 2'b11;

always @ (*) begin
    case(broom_c_state)
        BROOM_READY: begin broom_center=0 ; broom_up=0; broom_left=0; broom_right=0; if(broomdisable) broom_n_state = BROOM_STOP;
                                                                                     else if(turn_st==0 &&((key_pulse==5'h1A)||(key_pulse==5'h1B))) broom_n_state = BROOM_SET;  
                                                                                     else broom_n_state = BROOM_READY; end
        BROOM_SET: begin broom_center=1 ; broom_up=0; broom_left=0; broom_right=0; if(broomdisable) broom_n_state = BROOM_STOP;
                                                                                   else if(turn_st==0 &&((key_pulse==5'h1A)||(key_pulse==5'h1B)))  broom_n_state = BROOM_UP; 
                                                                                   else broom_n_state = BROOM_SET; end
        BROOM_UP: begin broom_center=0; broom_up=1; broom_left=0; broom_right=0; if(broomdisable) broom_n_state = BROOM_STOP;
                                                                                 else if (turn_st==0 &&((key_pulse==5'h1A)||(key_pulse==5'h1B))) broom_n_state = BROOM_SET;
                                                                                 else broom_n_state = BROOM_UP; end
        BROOM_STOP: begin broom_center=0 ; broom_up=0; broom_left=0; broom_right=0; broom_n_state = BROOM_READY; end
        default: begin broom_center=0 ; broom_up=0; broom_left=0; broom_right=0; broom_n_state = BROOM_READY; end
        endcase
end

always @ (posedge clk, posedge rst) begin
    if(rst | turn_st !=0 | broomdisable) broom_c_state <= BROOM_READY;
    else broom_c_state <= broom_n_state; 
end


/////////////////////////////
/// wall collison detect ///
///////////////////////////

parameter FIELD_TOP = 5;   // 화면 상단 좌표 (hdmi cut issue -> change from 1 to 5 )
parameter FIELD_LEFT = 169; // 필드 좌측벽 좌표
parameter FIELD_RIGHT = 470; // 필드 우측벽 좌표
parameter FIELD_BOTTOM = 448; // 필드 히단벽 좌표
parameter COLLMARGIN = 7;   // 스톤 충돌시 x값 좌우 마진. 5-15 사이에서 적정값 찾을 필요 있음 아직 조정중,

wire reach_top, reach_bottom, reach_left, reach_right,outof_field; // 상단벽(없앰) 하단벽,좌측벽,우측벽,필드벗어남 감지변수

//assign reach_top = ((stone_y-STONE_RAD)<= FIELD_TOP)? 1 : 0; // 상단벽에 충돌감지 (비활성화)
assign reach_bottom = ((stone_y+STONE_RAD)>= FIELD_BOTTOM)? 1 : 0; // 하단벽에 충돌감지
assign reach_left = ((stone_x-STONE_RAD)<= FIELD_LEFT)? 1 : 0; // 좌측벽에 충돌감지
assign reach_right = ((stone_x+STONE_RAD)>= FIELD_RIGHT)? 1 : 0; // 우측벽에 충돌감지
assign outof_field = (stone_y>= 481)? 1 : 0; // 상단혹은 하단 뚫고 나감 감지

//////////////////////////////////////
//// other stone collision detect ////
////////////////////////////////////

wire meet_stone1,meet_stone2,meet_stone3,meet_stone4,meet_stone5; // 다른 Stone들과의 충돌감지 각각.

assign meet_stone1 = (((stone_x - stone_x_in1)*(stone_x - stone_x_in1)) + ((stone_y - stone_y_in1)*(stone_y - stone_y_in1)) <= (STONE_2RAD*STONE_2RAD))? 1:0; // 다른 stone 1과 충돌감지
assign meet_stone2 = (((stone_x - stone_x_in2)*(stone_x - stone_x_in2)) + ((stone_y - stone_y_in2)*(stone_y - stone_y_in2)) <= (STONE_2RAD*STONE_2RAD))? 1:0; // 다른 stone 2과 충돌감지
assign meet_stone3 = (((stone_x - stone_x_in3)*(stone_x - stone_x_in3)) + ((stone_y - stone_y_in3)*(stone_y - stone_y_in3)) <= (STONE_2RAD*STONE_2RAD))? 1:0; // 다른 stone 3과 충돌감지
assign meet_stone4 = (((stone_x - stone_x_in4)*(stone_x - stone_x_in4)) + ((stone_y - stone_y_in4)*(stone_y - stone_y_in4)) <= (STONE_2RAD*STONE_2RAD))? 1:0; // 다른 stone 4과 충돌감지
assign meet_stone5 = (((stone_x - stone_x_in5)*(stone_x - stone_x_in5)) + ((stone_y - stone_y_in5)*(stone_y - stone_y_in5)) <= (STONE_2RAD*STONE_2RAD))? 1:0; // 다른 stone 5과 충돌감지

//////////////////////////////////
/// collison direction detect ///
////////////////////////////////

wire [1:0] angle_b1_dat, angle_b2_dat, angle_b3_dat, angle_b4_dat, angle_b5_dat; // 각 stone과의 x좌표 차이 계산을 통한 충돌 방향 변수

// 각 stone과의 충돌시 x위치 계산을 통한 좌측, 중앙, 우측 충돌 감지(턴 0일경우 0중앙, 1 좌측, 2 우측) (턴 3일경우 0 중앙 2 우측 1 좌측).
// COLLMARGIN은 중앙감지의 마진 범위

assign angle_b1_dat =((stone_x_in1 < (stone_x + COLLMARGIN))&&((stone_x_in1+ COLLMARGIN) > stone_x ))? 0 :
                     (stone_x_in1 >= (stone_x + COLLMARGIN))? 1 :
                     ((stone_x_in1+ COLLMARGIN) <= stone_x )? 2 : 0;
                      
assign angle_b2_dat =((stone_x_in2 < (stone_x + COLLMARGIN))&&((stone_x_in2+ COLLMARGIN) > stone_x ))? 0 :
                     (stone_x_in2 >= (stone_x + COLLMARGIN))? 1 :
                     ((stone_x_in2+ COLLMARGIN) <= stone_x )? 2 : 0;

assign angle_b3_dat =((stone_x_in3 < (stone_x + COLLMARGIN))&&((stone_x_in3+ COLLMARGIN) > stone_x ))? 0 :
                     (stone_x_in3 >= (stone_x + COLLMARGIN))? 1 :
                     ((stone_x_in3+ COLLMARGIN) <= stone_x )? 2 : 0;

assign angle_b4_dat =((stone_x_in4 < (stone_x + COLLMARGIN))&&((stone_x_in4+ COLLMARGIN) > stone_x ))? 0 :
                     (stone_x_in4 >= (stone_x + COLLMARGIN))? 1 :
                     ((stone_x_in4+ COLLMARGIN) <= stone_x )? 2 : 0;
                      
assign angle_b5_dat =((stone_x_in5 < (stone_x + COLLMARGIN))&&((stone_x_in5+ COLLMARGIN) > stone_x ))? 0 :
                     (stone_x_in5 >= (stone_x + COLLMARGIN))? 1 :
                     ((stone_x_in5+ COLLMARGIN) <= stone_x )? 2 : 0;
                      
wire [1:0] collib1, collib2, collib3, collib4, collib5; // 각 stone과의 y좌표 차이 계산을 통한 충돌 방향 변수
//각 stone과의 y위치 계산을 통한 상단, 중앙, 하단 충돌 감지(턴 0일경우 0중앙, 1 상측, 2 하측) (턴 3일경우 0 중앙 2 상측 1 하측). 
// COLLMARGIN은 중앙감지의 마진 범위

assign collib1 = ((stone_y_in1 - stone_y)<0)? 1: ((stone_y_in1 - stone_y)>0)? 2: 0;
assign collib2 = ((stone_y_in2 - stone_y)<0)? 1: ((stone_y_in2 - stone_y)>0)? 2: 0;
assign collib3 = ((stone_y_in3 - stone_y)<0)? 1: ((stone_y_in3 - stone_y)>0)? 2: 0;
assign collib4 = ((stone_y_in4 - stone_y)<0)? 1: ((stone_y_in4 - stone_y)>0)? 2: 0;
assign collib5 = ((stone_y_in5 - stone_y)<0)? 1: ((stone_y_in5 - stone_y)>0)? 2: 0;

wire [3:0] collidetect1, collidetect2, collidetect3, collidetect4, collidetect5; // 위의 x연산, y연산 값을 이용한 충돌 방향 확정 변수
 // 턴0일 경우 0: 좌상단 / 1: 상단중앙 / 2: 우상단  / 3: 좌측중앙 / 4: 우측중앙 / 5:좌하단 / 6: 하단중앙 / 7: 우하단
 // 턴3일 경우 0: 우하단 / 1: 하단중앙 / 2: 좌하단  / 3: 우측중앙 / 4: 좌측중앙  / 5: 우상단 / 6: 상단중앙 / 7: 좌상단

assign collidetect1 = ((angle_b1_dat==1)&&(collib1==2))? 0 :
                      ((angle_b1_dat==0)&&(collib1==2))? 1 :
                      ((angle_b1_dat==2)&&(collib1==2))? 2 :
                      ((angle_b1_dat==1)&&(collib1==0))? 3 :
                      ((angle_b1_dat==2)&&(collib1==0))? 4 :
                      ((angle_b1_dat==1)&&(collib1==1))? 5 :
                      ((angle_b1_dat==0)&&(collib1==1))? 6 : 
                      ((angle_b1_dat==2)&&(collib1==1))? 7 : 8;

assign collidetect2 = ((angle_b2_dat==1)&&(collib2==2))? 0 :
                      ((angle_b2_dat==0)&&(collib2==2))? 1 :
                      ((angle_b2_dat==2)&&(collib2==2))? 2 :
                      ((angle_b2_dat==1)&&(collib2==0))? 3 :
                      ((angle_b2_dat==2)&&(collib2==0))? 4 :
                      ((angle_b2_dat==1)&&(collib2==1))? 5 :
                      ((angle_b2_dat==0)&&(collib2==1))? 6 : 
                      ((angle_b2_dat==2)&&(collib2==1))? 7 : 8;

assign collidetect3 = ((angle_b3_dat==1)&&(collib3==2))? 0 :
                      ((angle_b3_dat==0)&&(collib3==2))? 1 :
                      ((angle_b3_dat==2)&&(collib3==2))? 2 :
                      ((angle_b3_dat==1)&&(collib3==0))? 3 :
                      ((angle_b3_dat==2)&&(collib3==0))? 4 :
                      ((angle_b3_dat==1)&&(collib3==1))? 5 :
                      ((angle_b3_dat==0)&&(collib3==1))? 6 : 
                      ((angle_b3_dat==2)&&(collib3==1))? 7 : 8;

assign collidetect4 = ((angle_b4_dat==1)&&(collib4==2))? 0 :
                      ((angle_b4_dat==0)&&(collib4==2))? 1 :
                      ((angle_b4_dat==2)&&(collib4==2))? 2 :
                      ((angle_b4_dat==1)&&(collib4==0))? 3 :
                      ((angle_b4_dat==2)&&(collib4==0))? 4 :
                      ((angle_b4_dat==1)&&(collib4==1))? 5 :
                      ((angle_b4_dat==0)&&(collib4==1))? 6 : 
                      ((angle_b4_dat==2)&&(collib4==1))? 7 : 8;

assign collidetect5 = ((angle_b5_dat==1)&&(collib5==2))? 0 :
                      ((angle_b5_dat==0)&&(collib5==2))? 1 :
                      ((angle_b5_dat==2)&&(collib5==2))? 2 :
                      ((angle_b5_dat==1)&&(collib5==0))? 3 :
                      ((angle_b5_dat==2)&&(collib5==0))? 4 :
                      ((angle_b5_dat==1)&&(collib5==1))? 5 :
                      ((angle_b5_dat==0)&&(collib5==1))? 6 : 
                      ((angle_b5_dat==2)&&(collib5==1))? 7 : 8;

wire [3:0] collimux; // 실제 충돌 발생한 Stone에 따라 위의충돌 위치변수를 연결

assign collimux = (meetsel==1)? collidetect1 :
                  (meetsel==2)? collidetect2 :
                  (meetsel==3)? collidetect3 :
                  (meetsel==4)? collidetect4 :
                  (meetsel==5)? collidetect5 : 10;
 
/////////////////////////
/// collison process ///
///////////////////////               

reg meet_calc,mv_stop,meetfin; // 충돌연산,이동중지,충돌여부 플래그 저장변수.
reg sav_dir, sav_s,copy_dir,copy_s,calcangle; // 방향값저장, 속력저장, 방향값복사, 속력값복사, 충돌방향연산 플래그 저장변수.
reg [2:0] meet_state, meet_state_n, meetsel; // 충돌 반응을 위한 상태저장변수와 그 다음상태저장변수, 충돌시 어떤 stone과 충돌했는지 정보 저장변수


always @(posedge clk or posedge rst) begin // 충돌시 충돌플래그 켬, 리셋 혹은 턴2(시작대기)상태시 끔
if(rst| (turn_st==2)) meetfin<=0;
else if(meetstones) meetfin<=1;
end

always @(*) begin // 어떤 stone과 충돌했는지 정보 저장, 리셋 혹은 턴2(시작대기)상태시 초기화
if(rst| (turn_st==2)) meetsel<=0;
else if(meet_stone1) meetsel<=1;
else if(meet_stone2) meetsel<=2;
else if(meet_stone3) meetsel<=3;
else if(meet_stone4) meetsel<=4;
else if(meet_stone5) meetsel<=5;
else if(meet_state==4) meetsel<=0;
else begin end
end

// 충돌 발생후 이동연산 및 필드이탈시 특정장소로 텔레포트후 이동금지 조건문.  리셋 혹은 턴2(시작대기)상태시 플래그 전부 끄고 상태 처음으로.
// 충돌 발생시 충돌연산플래그 켜짐으로 충돌연산 FSM동작 시작 및 broom작동 비활성화
// 0.이동정지 및 이 stone과, 충돌한 stone의 현재 방향, 속력 저장시작. 1. 저장종료, 복사시작 2. 충돌방향 연산시작
// 3. 충돌방향 연산종료, 복사종료, 이동재개, 4까지 진행 후 FSM동작 중지 플래그 켜짐
// 4. race현상 방지를 위한 상태. 종료후  fsm 작동 대기상태로.
always @(posedge clk or posedge rst) begin
if(rst| (turn_st==2)) begin  meet_calc<=0; meet_state_n<=0; sav_dir<=0; sav_s<=0; copy_dir<=0; copy_s<=0; mv_stop<=0; broomdisable<=0; end
else if (outof_field) mv_stop<=1;
else if (meetstones==1) begin meet_calc<=1; broomdisable<=1;
    case(meet_state)
    0: if(meet_calc==1) begin mv_stop<=1; sav_dir<=1; sav_s<=1; meet_state_n<=1; end else meet_state_n<=0;
    1: begin sav_dir<=0; sav_s<=0; calcangle<=1; meet_state_n<=2; end
    2: begin calcangle<=0; copy_dir<=1; copy_s<=1; meet_state_n<=3; end
    3: begin copy_dir<=0; copy_s<=0; meet_calc<=0; meet_state_n<=4; end
    4: begin mv_stop<=0; meet_state_n<=5; end
    5: begin if(frame_tick) meet_state_n<=0; else meet_state_n<=5; end
    default: meet_state_n<=0;
endcase
end
else 
    case(meet_state)
    0: if(meet_calc==1) begin mv_stop<=1; sav_dir<=1; sav_s<=1; meet_state_n<=1; end else meet_state_n<=0;
    1: begin sav_dir<=0; sav_s<=0; calcangle<=1; meet_state_n<=2; end
    2: begin calcangle<=0; copy_dir<=1; copy_s<=1; meet_state_n<=3; end
    3: begin copy_dir<=0; copy_s<=0; meet_calc<=0; meet_state_n<=4; end
    4: begin mv_stop<=0; meet_state_n<=5; end
    5: begin if(frame_tick) meet_state_n<=0; else meet_state_n<=5; end
    default: meet_state_n<=0;
endcase
end


always @(posedge clk or posedge rst) begin
if(rst) meet_state<=0;
else meet_state<=meet_state_n;
end

//////////////////////
///// direction /////
////////////////////

reg [1:0] xdir;    // 0 for stop,  2 for left, 1 for right
reg [1:0] ydir;  // 0 for stop, 2 for up, 1 for down

reg [1:0] xdir_sav_me,ydir_sav_me; //자기 자신의 방향값 저장
reg [1:0] xdir_sav_mef,ydir_sav_mef; //자기 자신의 방향값 처리 후 저장
reg [1:0] xdir_sav_oth,ydir_sav_oth; //부딛힌 상대의 방향값 저장
reg [1:0] xdir_sav_othf,ydir_sav_othf; //부딛힌 상대의 방향값 처리 후 저장

// 리셋 혹은 턴2(시작대기)시 저장값 초기화, 저장신호 들어오면 이 stone의 현재 방향 값 저장.
always @(*) begin
    if(rst | (turn_st==2) ) xdir_sav_me <= 0;
    else if (sav_dir) xdir_sav_me <= xdir;
    else xdir_sav_me <= xdir_sav_me;
      end
      
 always @(*) begin
    if(rst | (turn_st==2) ) ydir_sav_me <= 0;
    else if (sav_dir) ydir_sav_me <= ydir;
    else ydir_sav_me<=ydir_sav_me;
      end     
 
 
reg sav_dir_fin_x; //저장 완료 플래그
reg sav_dir_fin_y;
 
 // 리셋 혹은 턴2(시작대기)시 저장값 초기화, 저장신호 들어오면 다른 stone의 현재 방향값 저장.
 always @(posedge clk or posedge rst) begin
    if(rst | (turn_st==2) ) begin xdir_sav_oth<= 0; sav_dir_fin_x<=0; end
    else if (meet_stone1 && sav_dir && sav_dir_fin_x==0 ) begin xdir_sav_oth <= xdir_1; sav_dir_fin_x<=1; end
    else if (meet_stone2 && sav_dir && sav_dir_fin_x==0 ) begin xdir_sav_oth <= xdir_2; sav_dir_fin_x<=1; end
    else if (meet_stone3 && sav_dir && sav_dir_fin_x==0 ) begin xdir_sav_oth <= xdir_3; sav_dir_fin_x<=1; end
    else if (meet_stone4 && sav_dir && sav_dir_fin_x==0 ) begin xdir_sav_oth <= xdir_4; sav_dir_fin_x<=1; end
    else if (meet_stone5 && sav_dir && sav_dir_fin_x==0 ) begin xdir_sav_oth <= xdir_5; sav_dir_fin_x<=1; end
    else if (meetfin==1) sav_dir_fin_x<=0;
    else begin end;
      end
      
 always @(posedge clk or posedge rst) begin
    if(rst | (turn_st==2) ) begin ydir_sav_oth<= 0; sav_dir_fin_y<=0; end
    else if (sav_dir && sav_dir_fin_y==0) begin ydir_sav_oth <= 2; sav_dir_fin_y<=1; end
    else if (sav_dir && sav_dir_fin_y==0) begin ydir_sav_oth <= 2; sav_dir_fin_y<=1; end
    else if (sav_dir && sav_dir_fin_y==0) begin ydir_sav_oth <= 2; sav_dir_fin_y<=1; end
    else if (sav_dir && sav_dir_fin_y==0) begin ydir_sav_oth <= 2; sav_dir_fin_y<=1; end
    else if (sav_dir && sav_dir_fin_y==0) begin ydir_sav_oth <= 2; sav_dir_fin_y<=1; end
    else if (meetfin==1) sav_dir_fin_y<=0;
    else begin end;
      end          
      
////////////////////////////

//턴0(이 stone이 가서 부딛힌경우)충돌방향 계산값을 이용하여 튕겨나갈 방향 연산. 각도는 45도 단위.
always @(posedge clk or posedge rst) begin
    if(rst | (turn_st==2) ) xdir_sav_mef <= 0;
    else if (calcangle) begin
        case(collimux)
        0: xdir_sav_mef <= 2;
        1: xdir_sav_mef <= 0;
        2: xdir_sav_mef <= 1;
        3: xdir_sav_mef <= 2;
        4: xdir_sav_mef <= 1;
        5: xdir_sav_mef <= 2;
        6: xdir_sav_mef <= 0;
        7: xdir_sav_mef <= 1;
        default: xdir_sav_mef <= 0;
        endcase
        end
    else xdir_sav_mef <= xdir_sav_mef;
      end
     
      always @(posedge clk or posedge rst) begin
    if(rst | (turn_st==2) ) ydir_sav_mef <= 0;
    else if (calcangle) begin
        case(collimux)
        0: ydir_sav_mef <= 1;
        1: ydir_sav_mef <= 2;
        2: ydir_sav_mef <= 1;
        3: ydir_sav_mef <= 0;
        4: ydir_sav_mef <= 0;
        5: ydir_sav_mef <= 2;
        6: ydir_sav_mef <= 1;
        7: ydir_sav_mef <= 2;
        default: ydir_sav_mef <= 0;
        endcase
        end
    else ydir_sav_mef <= ydir_sav_mef;
      end
      
 
 //턴3(다른 stone이 와서 부딛힌경우)충돌방향 계산값을 이용하여 튕겨나갈 방향 연산. 각도는 45도 단위.  
 always @(posedge clk or posedge rst) begin
    if(rst | (turn_st==2) ) begin xdir_sav_othf<= 0;end
    else if (calcangle) begin
        case(collimux)
        7: xdir_sav_othf <= 1;
        6: xdir_sav_othf <= 0;
        5: xdir_sav_othf <= 2;
        4: xdir_sav_othf <= 1;
        3: xdir_sav_othf <= 2;
        2: xdir_sav_othf <= 1;
        1: xdir_sav_othf <= 0;
        0: xdir_sav_othf <= 2;
        default: xdir_sav_othf <= 0;
        endcase
        end
    else xdir_sav_othf <=xdir_sav_othf;
      end

 always @(posedge clk or posedge rst) begin
    if(rst | (turn_st==2) ) begin ydir_sav_othf<= 0;end
    else if (calcangle) begin
        case(collimux)
        7: ydir_sav_othf <= 1;
        6: ydir_sav_othf <= 1;
        5: ydir_sav_othf <= 1;
        3: ydir_sav_othf <= 0;
        4: ydir_sav_othf <= 0;
        2: ydir_sav_othf <= 2;
        1: ydir_sav_othf <= 2;
        0: ydir_sav_othf <= 2;
        default: ydir_sav_othf <= 0;
        endcase
        end    
    else ydir_sav_othf <= ydir_sav_othf;
      end

      
// 방향값 확정.
// 리셋 혹은 턴2(시작대기)시 방향값 없음, 턴1(시작장소위치)시 x방향 오른쪽으로 시작, 턴6(임시상태)시 방향값 없음. 벽과 충돌시 방향 반전
// 충돌시 저장플래그 켜지면 충돌연산결과 나온 값을 입력.
always @(posedge clk or posedge rst) begin
    if(rst| (turn_st==2)) xdir <= 0;
    else if(turn_st==1) xdir <= 1;
    else if(turn_st==6) xdir <= 0;
    //else if(turn_st==5) xdir <= 0;
    else if ((turn_st==3)&&(reach_left)) xdir <= 1;
    else if ((turn_st==3)&&(reach_right)) xdir <= 2;
    else if ((turn_st==3)&&(copy_dir)) xdir <= xdir_sav_othf;
    else if ((turn_st==0)&&(reach_left)) xdir <= 1;
    else if ((turn_st==0)&&(reach_right)) xdir <= 2;
    else if ((turn_st==0)&&(copy_dir)) xdir <= xdir_sav_mef;
    else if (turn_st==4) begin
         if (reach_left) xdir <= 1;
         else if (reach_right) xdir <= 2;
        end
    else xdir<=xdir;
   end
   
  
always @(posedge clk or posedge rst) begin
    if(rst| (turn_st==2)) ydir <= 2;
    else if(turn_st==1) ydir <= 2;
    else if(turn_st==6) ydir <= 0;
    //else if ((turn_st==3)&&(reach_top)) ydir <= 1;
    else if ((turn_st==3)&&(reach_bottom)) ydir <= 2;
    else if ((turn_st==3)&&(copy_dir)) ydir <= ydir_sav_othf; 
    //else if ((turn_st==0)&&(reach_top)) ydir <= 1;
    else if ((turn_st==0)&&(reach_bottom)) ydir <= 2;
    else if ((turn_st==0)&&(copy_dir)) ydir <= ydir_sav_mef;
    else ydir<=ydir;
    end 

       
///////////////////////////////////
/// collision flag (debounced) ///
/////////////////////////////////

wire meetstones,meetstones_r; // 다른 stone과의 충돌판별. 연속신호 방지를 위해 디바운싱처리.

assign meetstones_r = (meet_stone1 || meet_stone2 || meet_stone3 || meet_stone4 || meet_stone5)? 1 : 0;
debounce #(.BTN_WIDTH(1)) debounce_mtb_inst (clk, rst, meetstones_r, ,meetstones);


//////////////////
///// speed /////
////////////////

reg [3:0] sx, sy; // 자신의 속력
reg [3:0] sx_sav_me, sy_sav_me; // 자신의 속력 저장
reg [3:0] sx_sav_mef, sy_sav_mef; // 자신의 속력 처리값  저장
reg [3:0] sx_sav_oth,sy_sav_oth; // 부딛힌 상대의 속력 저장
reg [3:0] sx_sav_othf,sy_sav_othf; // 부딛힌 상대의 속력 처리값 저장

// 리셋 혹은 턴2(시작대기)시 저장값 초기화, 저장신호 들어오면 이 stone의 현재 속력값 저장.
always @(posedge clk or posedge rst) begin
    if(rst | (turn_st==2) ) sx_sav_me <= 0;
    else if (sav_s) sx_sav_me <= sx/2;
    else sx_sav_me <= sx_sav_me;
      end
      
 always @(posedge clk or posedge rst) begin
    if(rst | (turn_st==2) ) sy_sav_me <= 0;
    else if (sav_s) sy_sav_me <= sy/2;
    else sy_sav_me <= sy_sav_me;
      end 
      
//////////////      

reg sav_s_fin_x; //저장 완료 플래그
reg sav_s_fin_y; 

// 리셋 혹은 턴2(시작대기)시 저장값 초기화, 저장신호 들어오면 다른 stone의 현재 속력값 저장.
always @(posedge clk or posedge rst) begin
    if(rst | (turn_st==2) ) begin sx_sav_oth <= 0; sav_s_fin_x<=0;end
    else if (sav_s && meet_stone1 && sav_s_fin_x==0) begin sx_sav_oth <= sx_in_1; sav_s_fin_x<=1; end
    else if (sav_s && meet_stone2 && sav_s_fin_x==0) begin sx_sav_oth <= sx_in_2; sav_s_fin_x<=1; end
    else if (sav_s && meet_stone3 && sav_s_fin_x==0) begin sx_sav_oth <= sx_in_3; sav_s_fin_x<=1; end
    else if (sav_s && meet_stone4 && sav_s_fin_x==0) begin sx_sav_oth <= sx_in_4; sav_s_fin_x<=1; end
    else if (sav_s && meet_stone5 && sav_s_fin_x==0) begin sx_sav_oth <= sx_in_5; sav_s_fin_x<=1; end
    else if (meetfin==1) sav_s_fin_x<=0;
    else begin end;
      end


      
 always @(posedge clk or posedge rst) begin
    if(rst | (turn_st==2) ) begin sy_sav_oth <= 0; sav_s_fin_y<=0;end
    else if (sav_s && meet_stone1 && sav_s_fin_y==0) begin sy_sav_oth <= sy_in_1; sav_s_fin_y<=1; end
    else if (sav_s && meet_stone2 && sav_s_fin_y==0) begin sy_sav_oth <= sy_in_2; sav_s_fin_y<=1; end
    else if (sav_s && meet_stone3 && sav_s_fin_y==0) begin sy_sav_oth <= sy_in_3; sav_s_fin_y<=1; end
    else if (sav_s && meet_stone4 && sav_s_fin_y==0) begin sy_sav_oth <= sy_in_4; sav_s_fin_y<=1; end
    else if (sav_s && meet_stone5 && sav_s_fin_y==0) begin sy_sav_oth <= sy_in_5; sav_s_fin_y<=1; end
    else if (meetfin==1) sav_s_fin_y<=0;
    else begin end;
      end    



//턴0(이 stone이 가서 부딛힌경우)충돌시 저장한 속력값을 이용하여 튕겨나갈 속력 연산. 소수점연산이 불가한 한계로, 대각선이동 거리 연산은 올림하여 연산하였음.
 always @(posedge clk or posedge rst) begin
    if(rst | (turn_st==2) ) begin sx_sav_mef<= 0;end
    else if (calcangle) begin
        case(collimux)
        0: sx_sav_mef <= ((sy_sav_me/2)<=1)? 1 : sy_sav_me/2;
        1: sx_sav_mef <= 0;
        2: sx_sav_mef <= ((sy_sav_me/2)<=1)? 1 : sy_sav_me/2;
        3: sx_sav_mef <= 0;
        4: sx_sav_mef <= 0;
        5: sx_sav_mef <= ((sy_sav_me/2)<=1)? 1 : sy_sav_me/2;
        6: sx_sav_mef <= 0;
        7: sx_sav_mef <= ((sy_sav_me/2)<=1)? 1 : sy_sav_me/2;
        default: sx_sav_mef <= 0;
        endcase
        end    
    else begin end
      end

always @(posedge clk or posedge rst) begin
    if(rst | (turn_st==2) ) begin sy_sav_mef<= 0;end
    else if (calcangle) begin
        case(collimux)
        0: sy_sav_mef <= ((sy_sav_me/2)<=1)? 1 : sy_sav_me/2;
        1: sy_sav_mef <= 0;
        2: sy_sav_mef <= ((sy_sav_me/2)<=1)? 1 : sy_sav_me/2;
        3: sy_sav_mef <= 0;
        4: sy_sav_mef <= 0;
        5: sy_sav_mef <= ((sy_sav_me/2)<=1)? 1 : sy_sav_me/2;
        6: sy_sav_mef <= 0;
        7: sy_sav_mef <= ((sy_sav_me/2)<=1)? 1 : sy_sav_me/2;
        default: sy_sav_mef <= 0;
        endcase
        end    
    else begin end
      end
 
 //턴3(다른  stone이 와서 부딛힌경우)충돌시 저장한 속력값을 이용하여 튕겨나갈 속력 연산. 소수점연산이 불가한 한계로, 대각선이동 거리 연산은 올림하여 연산하였음.     
 always @(posedge clk or posedge rst) begin
    if(rst | (turn_st==2) ) begin sx_sav_othf<= 0;end
    else if (calcangle) begin
        case(collimux)
        7: sx_sav_othf <= sy_sav_oth;
        6: sx_sav_othf <= 0;
        5: sx_sav_othf <= sy_sav_oth;
        4: sx_sav_othf <= 0;
        3: sx_sav_othf <= 0;
        2: sx_sav_othf <= sy_sav_oth;
        1: sx_sav_othf <= 0;
        0: sx_sav_othf <= sy_sav_oth;
        default: sx_sav_othf <= 0;
        endcase
        end    
    else begin end
      end

 always @(posedge clk or posedge rst) begin
    if(rst | (turn_st==2) ) begin sy_sav_othf<= 0;end
    else if (calcangle) begin
        case(collimux)
        7: sy_sav_othf <= sy_sav_oth;
        6: sy_sav_othf <= sy_sav_oth;
        5: sy_sav_othf <= sy_sav_oth;
        4: sy_sav_othf <= 0;
        3: sy_sav_othf <= 0;
        2: sy_sav_othf <= sy_sav_oth;
        1: sy_sav_othf <= sy_sav_oth;
        0: sy_sav_othf <= sy_sav_oth;
        default: sy_sav_othf <= 0;
        endcase
        end    
    else begin end
      end


////////////////////////////////
// Auto deceleration by time //
//////////////////////////////

reg [31:0] so,so1,so2,so3,so4;
wire speeddown,speeddown1,speeddown2,sec1,fin;

//속력에 따른 감속 차등을 위해 3개의 카운터 펄스발생 사용.
always @ (posedge clk or posedge rst) begin
if(rst || (shoot==1) || (meetstones==1) || (mv_stop==1)) so<=0;
else
    if (so==7559459-1) so<=0;
    else so<=so+1;
end
assign speeddown = (so==7559459-1)?1'b1 : 1'b0;  // 0.3sec



always @ (posedge clk or posedge rst) begin
if(rst || (shoot==1) || (meetstones==1) || (mv_stop==1)) so1<=0;
else
    if (so1==15103800-1) so1<=0;
    else so1<=so1+1;
end
assign speeddown1 = (so1==15103800-1)?1'b1 : 1'b0;  // 0.6sec

always @ (posedge clk or posedge rst) begin
if(rst || (shoot==1) || (meetstones==1) || (mv_stop==1) || (broomfront)) so2<=0;
else
    if (so2==22678378-1) so2<=0;
    else so2<=so2+1;
end
assign speeddown2 = (so2==22678378-1)?1'b1 : 1'b0;  // 0.9sec


// 시작시 방향 및 속력 정해지면 1초뒤 자동 발사(?) 
always @ (posedge clk or posedge rst) begin
if(rst || (turn_st==2) ) so3<=0;
else if(turn_st==0)
    if (so3==25173000-1) so3<=0;
    else so3<=so3+1;
end
assign sec1 = (so3==25173000-1)?1'b1 : 1'b0;  // 1sec


// 턴 종료시 방향 및 속력 정해지면 3초뒤 자동 턴 종료 
always @ (posedge clk or posedge rst) begin
if(rst || (turn_st==2) || (fincheck==1) ) so4<=0;
else if(turn_st==0)
    if (so4==75519000-1) so4<=0;
    else so4<=so4+1;
end
assign fin = (so4==75519000-1)?1'b1 : 1'b0;  // 3sec

reg shootchk,shoot;

always @ (posedge clk or posedge rst) begin
if(rst | (turn_st==2)) begin shootchk<=0; shoot<=0; end
else if((turn_st==0)&&(shootchk==0)&&(sec1)) begin shootchk<=1;  shoot<=1; end
else shoot<=0;
end

//자동 턴 종료 감지. 동작방식은 이 stone의 이동이 완전히 멈추는 것을 감지하여 타이머 동작.
reg [9:0] stone_x_pre, stone_y_pre;
reg [2:0] fincheck, fincheck_n;

always @ (posedge clk or posedge rst) begin
if(rst  || (turn_st==2) ) begin fincheck_n<=0; stone_x_pre<=0; stone_y_pre<=0; end
else case(fincheck)
0: if(sec1) fincheck_n<=1; else fincheck_n<=0;
1: if((stone_x_pre==stone_x)&&(stone_y_pre==stone_y)&&(mv_stop==0)) fincheck_n<=2; else if((stone_x_pre!=stone_x)&&(stone_y_pre!=stone_y)&&(mv_stop==0)) begin stone_x_pre<=stone_x; stone_y_pre<=stone_y; fincheck_n<=1; end
2: if(fin) fincheck_n<=0; else fincheck_n<=2;
default: fincheck_n<=0;
endcase
end

always @ (posedge clk or posedge rst) begin
if(rst || (turn_st==2) ) fincheck<=0;
else fincheck<=fincheck_n;
end


// speed
// 속력값 확정.
// 리셋 혹은 턴2(시작대기)시 속력값 없음, 턴0(시작)시 외부에서 정해진 속력 입력, 턴5(속력선택상태)시 속력값0. 턴6(임시상태)시 속력값 없음.
// 충돌시 저장플래그 켜지면 충돌연산결과 나온 값을 입력.
// 현재 속력에 따라 일정 시간마다 자동 감속 작동.
always @ (posedge clk or posedge rst) begin
if(rst| (turn_st==2)) begin sx<=0; end
else if((turn_st==0)&&(shoot)) begin sx <= sx_in; end
else if(turn_st==5) sx <= 0;
else if(turn_st==6) sx <= 0;
else if((copy_s)&&(turn_st==3)) begin sx<=sx_sav_othf; end
else if((copy_s)&&(turn_st==0)) begin sx<=sx_sav_mef; end
else if((turn_st==0)&&(broomside)&&(sx<1)&&(sy!=0)) begin sx<=sx+1; end
else if((mv_stop==0)&&(sx==1)&&(speeddown2)&&(broomside==0)&&((turn_st==0)||(turn_st==3))) sx <= sx-1; 
else if((mv_stop==0)&&(sx>1)&&(sx<4)&&(speeddown1)&&(broomside==0)&&((turn_st==0)||(turn_st==3))) sx <= sx-1; 
else if((mv_stop==0)&&(sx>3)&&(speeddown)&&(broomside==0)&&((turn_st==0)||(turn_st==3))) sx <= sx-1; 
end

always @ (posedge clk or posedge rst) begin                             
if(rst | (turn_st==2)) begin sy<=0; end
else if((turn_st==0)&&(shoot)) begin sy <= sy_in; end
else if(turn_st==5) sy <= 0;
else if(turn_st==6) sy <= 0;
else if((copy_s)&&(turn_st==3)) begin sy<=sy_sav_othf; end
else if((copy_s)&&(turn_st==0)) begin sy<=sy_sav_mef; end
else if((mv_stop==0)&&(sy==1)&&(speeddown2)&&(broomfront==0)&&((turn_st==0)||(turn_st==3))) sy <= sy-1; 
else if((mv_stop==0)&&(sy>1)&&(sy<4)&&(speeddown1)&&(broomfront==0)&&((turn_st==0)||(turn_st==3))) sy <= sy-1; 
else if((mv_stop==0)&&(sy>3)&&(speeddown)&&(broomfront==0)&&((turn_st==0)||(turn_st==3))) sy <= sy-1; 
end



////////////////////////
/// stone coordinate ///
//////////////////////

// stone의 이동.
// 리셋 혹은 턴2(시작대기)시 대기장소에 위치, 필드에서 벗어나면 지정위치로 텔레포트하여 고정, 턴1(시작준비)시 시작선으로 이동,
//턴5(속력선택상태) 및 턴6(임시상태)시 위치 유지, 턴4(방향선택)시 고정된 속력값으로 반복이동, 턴0(시작) 및 턴3(필드대기)시 위에서 연산된 방향,속력에 따라 이동.
always @(posedge clk or posedge rst) begin    //stone_x
    if(rst | (turn_st==2)) begin // if not your turn, stay at waiting area
        stone_x <= RD_X;
    end
    else if(outof_field) stone_x <=ST_X;
    else if(turn_st==1) begin // if your turn, teleport to start area
        stone_x <= ST_X;
    end
    else if(turn_st==5) stone_x<=stone_x;
    else if(turn_st==6) stone_x<=stone_x;
    
    // if in dir select mode
    else if((turn_st==4)&&(turn_st!=5)&&(frame_tick)&&(xdir==1)) stone_x <= stone_x+3;
    else if((turn_st==4)&&(turn_st!=5)&&(frame_tick)&&(xdir==2)) stone_x <= stone_x-3;
    
    
             
    else if(((turn_st==0) || (turn_st==3))&&(mv_stop==0)&&(frame_tick)&&(xdir==1)) stone_x <= stone_x + sx;
    else if(((turn_st==0) || (turn_st==3))&&(mv_stop==0)&&(frame_tick)&&(xdir==2)) stone_x <= stone_x - sx;
    else if(((turn_st==0) || (turn_st==3))&&(mv_stop==0)&&(frame_tick)&&(xdir==0)) stone_x <= stone_x;
    
    else stone_x <=stone_x;
    end
    
    
always @(posedge clk or posedge rst) begin //stone_y
    if(rst | (turn_st==2) ) begin // if not your turn, stay at waiting area
        stone_y <= RD_Y;
    end
    else if(outof_field) stone_y <=510;
    else if(turn_st==1) begin // if your turn, teleport to start area
        stone_y <= ST_Y;
    end
    else if(turn_st==6) stone_y<=stone_y;

    else if(((turn_st==0) || (turn_st==3))&&(mv_stop==0)&&(frame_tick)&&(ydir==1)) stone_y <= stone_y + sy;
    else if(((turn_st==0) || (turn_st==3))&&(mv_stop==0)&&(frame_tick)&&(ydir==2)) stone_y <= stone_y - sy;
    else if(((turn_st==0) || (turn_st==3))&&(mv_stop==0)&&(frame_tick)&&(ydir==0)) stone_y <= stone_y;

    else stone_y<=stone_y;
    end

//////////////    
/// broom ///
////////////

// 컬리의 Broom을 구현.
// 정면은 속도 감속을 늦춤 (횟수제한있음) , 좌측 혹은 우측은 시작방향 선택시 방향(좌로 이동하는중 확정=좌, 우로 이동하는중 확정=우)에 따라 한쪽만 가능, 해당방향으로 속력증가(횟수제한있음) 
reg [3:0] broomfrontcnt, broomsidecnt;
wire broomfront, broomside;
reg broomdisable;
reg [1:0] broomfrontx, broomsidex;

always @(posedge clk or posedge rst) begin
if(rst| (turn_st==2) ) begin broomfrontcnt<=0; broomfrontx<=0; end 
else if((turn_st==0)&&(key_pulse==5'h1B)&&(broomdisable==0)&&(broomfrontx<9)) broomfrontx<=broomfrontx+1;
     else begin end;
end


assign broomfront = ((turn_st==0)&&(key_pulse==5'h1B)&&(broomdisable==0)&&(broomfrontx<9))? 1: 0;

always @(posedge clk or posedge rst) begin
if(rst| (turn_st==2) ) begin broomsidecnt<=0; broomsidex<=0; end 
else if((turn_st==0)&&(key_pulse==5'h1A)&&(broomdisable==0)&&(broomsidex<2)) broomsidex<=broomsidex+1;
         else begin end
end

assign broomside = ((turn_st==0)&&(key_pulse==5'h1A)&&(broomdisable==0)&&(broomsidex<2))? 1: 0;

////////////////////////
/// draw stone shape ///
//////////////////////

wire [19:0] distance;

//컬링 스톤의 디자인. 
assign distance = (((stone_x-x)*(stone_x-x)) + ((stone_y-y)*(stone_y-y)));
assign stone_on = ((STONE_RAD-5)*(STONE_RAD-5) >= distance)? 1 : 0;
assign stone_edge = (STONE_RAD*STONE_RAD >= distance)? 1 : 0;
assign hand_on = ((x > stone_x-4) && (x < stone_x+4) && (y > stone_y-5) && (y < stone_y+10))? 1: 0;
assign real_edge = ((STONE_RAD+1)*(STONE_RAD+1) >= distance)? 1 : 0;

endmodule
