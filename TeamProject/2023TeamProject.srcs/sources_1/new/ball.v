`timescale 1ns / 1ps

module ball(input clk, input rst,input frame_tick, input [9:0] x, y, output reg [9:0] ball_x, ball_y,  //Ŭ��, ����, �����Ӱ��Ž�ȣ, ���� ������� x,y��ǥ, �� ����� Ball�� ��x,y��ǥ
input [4:0] key, key_pulse, input [2:0] turn_st, output ball_on, ball_edge, hand_on, real_edge, //Ű�е��Է�, Ű�е��޽��Է� , �� ���� �Է�, Ball ������� ǥ�ø� ���� ���4�� 
input [3:0] sx_in, sy_in, output [3:0] sx, sy, output [1:0] xdir, ydir, // x�ӷ��Է�,y�ӷ��Է�,����x�ӷ�,����y�ӷ�,����x����,����y����
input [9:0] ball_x_in1, ball_y_in1, input [3:0] sx_in_1, sy_in_1, input [1:0] xdir_1, ydir_1, // �� Ball ���� �ٸ�ball���� ���� x,y ��ǥ, ���� x,y �ӷ�, ���� x,y ���Ⱚ�Է�. 
input [9:0] ball_x_in2, ball_y_in2, input [3:0] sx_in_2, sy_in_2, input [1:0] xdir_2, ydir_2,
input [9:0] ball_x_in3, ball_y_in3, input [3:0] sx_in_3, sy_in_3, input [1:0] xdir_3, ydir_3,
input [9:0] ball_x_in4, ball_y_in4, input [3:0] sx_in_4, sy_in_4, input [1:0] xdir_4, ydir_4,
input [9:0] ball_x_in5, ball_y_in5, input [3:0] sx_in_5, sy_in_5, input [1:0] xdir_5, ydir_5,
output broom_on_center,broom_on_up,broom_on_left,broom_on_right,broom_on_center_design,broom_on_up_design, // broom ǥ�ø� ���� ���
output fin
);

parameter BALL_RAD = 15; // Ball�� ������ ����
parameter BALL_2RAD = BALL_RAD*2; // Ball�� ���� ����
parameter RD_X = 85; // �⺻ ������ x��ǥ
parameter RD_Y = 150; // �⺻ ������ y��ǥ
parameter ST_X = 319;  // ������� x��ǥ
parameter ST_Y = 449; // ������� y��ǥ


reg broom_center, broom_up, broom_left, broom_right;

assign broom_on_center = ((broom_center==1) &&(turn_st==0)&&(x>=(ball_x-20) && x<=(ball_x+20) && y>=(ball_y-25) && y<=(ball_y-19)))? 1 : 0; // �߾�(�⺻ broom ǥ����ġ) 
assign broom_on_center_design = ((broom_center==1) &&(turn_st==0)&&(x>=(ball_x-10) && x<=(ball_x+10) && y>=(ball_y-23) && y<=(ball_y-20)))? 1 : 0; // �߾�(�⺻ broom ǥ����ġ)

assign broom_on_up = ((broom_up==1) && (turn_st==0)&&(x>=(ball_x-20) && x<=(ball_x+20) && y>=(ball_y-45) && y<=(ball_y-39)))? 1 : 0; // ��(broom ���� �۵��� ǥ����ġ) 
assign broom_on_up_design = ((broom_up==1) && (turn_st==0)&&(x>=(ball_x-10) && x<=(ball_x+10) && y>=(ball_y-43) && y<=(ball_y-40)))? 1 : 0; // ��(broom ���� �۵��� ǥ����ġ) 

assign broom_on_left = ((broom_left==1)&&(x>=(ball_x-25) && x<=(ball_x+5) && y>=(ball_y-30) && y<=(ball_y-19)))? 1 : 0; // ����(broom ���ʹ��� �۵��� ǥ�� ��ġ)
assign broom_on_right = ((broom_right==1)&&(x>=(ball_x+25) && x<=(ball_x+55) && y>=(ball_y-30) && y<=(ball_y-19)))? 1 : 0; // ������(broom �����ʹ��� �۵��� ǥ�� ��ġ)

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

parameter FIELD_TOP = 5;   // ȭ�� ��� ��ǥ (hdmi cut issue -> change from 1 to 5 )
parameter FIELD_LEFT = 169; // �ʵ� ������ ��ǥ
parameter FIELD_RIGHT = 470; // �ʵ� ������ ��ǥ
parameter FIELD_BOTTOM = 448; // �ʵ� ���ܺ� ��ǥ
parameter COLLMARGIN = 7;   // �� �浹�� x�� �¿� ����. 5-15 ���̿��� ������ ã�� �ʿ� ���� ���� ������,

wire reach_top, reach_bottom, reach_left, reach_right,outof_field; // ��ܺ�(����) �ϴܺ�,������,������,�ʵ��� ��������

//assign reach_top = ((ball_y-BALL_RAD)<= FIELD_TOP)? 1 : 0; // ��ܺ��� �浹���� (��Ȱ��ȭ)
assign reach_bottom = ((ball_y+BALL_RAD)>= FIELD_BOTTOM)? 1 : 0; // �ϴܺ��� �浹����
assign reach_left = ((ball_x-BALL_RAD)<= FIELD_LEFT)? 1 : 0; // �������� �浹����
assign reach_right = ((ball_x+BALL_RAD)>= FIELD_RIGHT)? 1 : 0; // �������� �浹����
assign outof_field = (ball_y>= 481)? 1 : 0; // ���Ȥ�� �ϴ� �հ� ���� ����

//////////////////////////////////////
//// other ball collision detect ////
////////////////////////////////////

wire meet_ball1,meet_ball2,meet_ball3,meet_ball4,meet_ball5; // �ٸ� Ball����� �浹���� ����.

assign meet_ball1 = (((ball_x - ball_x_in1)*(ball_x - ball_x_in1)) + ((ball_y - ball_y_in1)*(ball_y - ball_y_in1)) <= (BALL_2RAD*BALL_2RAD))? 1:0; // �ٸ� ball 1�� �浹����
assign meet_ball2 = (((ball_x - ball_x_in2)*(ball_x - ball_x_in2)) + ((ball_y - ball_y_in2)*(ball_y - ball_y_in2)) <= (BALL_2RAD*BALL_2RAD))? 1:0; // �ٸ� ball 2�� �浹����
assign meet_ball3 = (((ball_x - ball_x_in3)*(ball_x - ball_x_in3)) + ((ball_y - ball_y_in3)*(ball_y - ball_y_in3)) <= (BALL_2RAD*BALL_2RAD))? 1:0; // �ٸ� ball 3�� �浹����
assign meet_ball4 = (((ball_x - ball_x_in4)*(ball_x - ball_x_in4)) + ((ball_y - ball_y_in4)*(ball_y - ball_y_in4)) <= (BALL_2RAD*BALL_2RAD))? 1:0; // �ٸ� ball 4�� �浹����
assign meet_ball5 = (((ball_x - ball_x_in5)*(ball_x - ball_x_in5)) + ((ball_y - ball_y_in5)*(ball_y - ball_y_in5)) <= (BALL_2RAD*BALL_2RAD))? 1:0; // �ٸ� ball 5�� �浹����

//////////////////////////////////
/// collison direction detect ///
////////////////////////////////

wire [1:0] angle_b1_dat, angle_b2_dat, angle_b3_dat, angle_b4_dat, angle_b5_dat; // �� ball���� x��ǥ ���� ����� ���� �浹 ���� ����

// �� ball���� �浹�� x��ġ ����� ���� ����, �߾�, ���� �浹 ����(�� 0�ϰ�� 0�߾�, 1 ����, 2 ����) (�� 3�ϰ�� 0 �߾� 2 ���� 1 ����).
// COLLMARGIN�� �߾Ӱ����� ���� ����

assign angle_b1_dat =((ball_x_in1 < (ball_x + COLLMARGIN))&&((ball_x_in1+ COLLMARGIN) > ball_x ))? 0 :
                     (ball_x_in1 >= (ball_x + COLLMARGIN))? 1 :
                     ((ball_x_in1+ COLLMARGIN) <= ball_x )? 2 : 0;
                      
assign angle_b2_dat =((ball_x_in2 < (ball_x + COLLMARGIN))&&((ball_x_in2+ COLLMARGIN) > ball_x ))? 0 :
                     (ball_x_in2 >= (ball_x + COLLMARGIN))? 1 :
                     ((ball_x_in2+ COLLMARGIN) <= ball_x )? 2 : 0;

assign angle_b3_dat =((ball_x_in3 < (ball_x + COLLMARGIN))&&((ball_x_in3+ COLLMARGIN) > ball_x ))? 0 :
                     (ball_x_in3 >= (ball_x + COLLMARGIN))? 1 :
                     ((ball_x_in3+ COLLMARGIN) <= ball_x )? 2 : 0;

assign angle_b4_dat =((ball_x_in4 < (ball_x + COLLMARGIN))&&((ball_x_in4+ COLLMARGIN) > ball_x ))? 0 :
                     (ball_x_in4 >= (ball_x + COLLMARGIN))? 1 :
                     ((ball_x_in4+ COLLMARGIN) <= ball_x )? 2 : 0;
                      
assign angle_b5_dat =((ball_x_in5 < (ball_x + COLLMARGIN))&&((ball_x_in5+ COLLMARGIN) > ball_x ))? 0 :
                     (ball_x_in5 >= (ball_x + COLLMARGIN))? 1 :
                     ((ball_x_in5+ COLLMARGIN) <= ball_x )? 2 : 0;
                      
wire [1:0] collib1, collib2, collib3, collib4, collib5; // �� ball���� y��ǥ ���� ����� ���� �浹 ���� ����
//�� ball���� y��ġ ����� ���� ���, �߾�, �ϴ� �浹 ����(�� 0�ϰ�� 0�߾�, 1 ����, 2 ����) (�� 3�ϰ�� 0 �߾� 2 ���� 1 ����). 
// COLLMARGIN�� �߾Ӱ����� ���� ����

assign collib1 = ((ball_y_in1 - ball_y)<0)? 1: ((ball_y_in1 - ball_y)>0)? 2: 0;
assign collib2 = ((ball_y_in2 - ball_y)<0)? 1: ((ball_y_in2 - ball_y)>0)? 2: 0;
assign collib3 = ((ball_y_in3 - ball_y)<0)? 1: ((ball_y_in3 - ball_y)>0)? 2: 0;
assign collib4 = ((ball_y_in4 - ball_y)<0)? 1: ((ball_y_in4 - ball_y)>0)? 2: 0;
assign collib5 = ((ball_y_in5 - ball_y)<0)? 1: ((ball_y_in5 - ball_y)>0)? 2: 0;

wire [3:0] collidetect1, collidetect2, collidetect3, collidetect4, collidetect5; // ���� x����, y���� ���� �̿��� �浹 ���� Ȯ�� ����
 // ��0�� ��� 0: �»�� / 1: ����߾� / 2: ����  / 3: �����߾� / 4: �����߾� / 5:���ϴ� / 6: �ϴ��߾� / 7: ���ϴ�
 // ��3�� ��� 0: ���ϴ� / 1: �ϴ��߾� / 2: ���ϴ�  / 3: �����߾� / 4: �����߾�  / 5: ���� / 6: ����߾� / 7: �»��

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

wire [3:0] collimux; // ���� �浹 �߻��� Ball�� ���� �����浹 ��ġ������ ����

assign collimux = (meetsel==1)? collidetect1 :
                  (meetsel==2)? collidetect2 :
                  (meetsel==3)? collidetect3 :
                  (meetsel==4)? collidetect4 :
                  (meetsel==5)? collidetect5 : 10;
 
/////////////////////////
/// collison process ///
///////////////////////               

reg meet_calc,mv_stop,meetfin; // �浹����,�̵�����,�浹���� �÷��� ���庯��.
reg sav_dir, sav_s,copy_dir,copy_s,calcangle; // ���Ⱚ����, �ӷ�����, ���Ⱚ����, �ӷ°�����, �浹���⿬�� �÷��� ���庯��.
reg [2:0] meet_state, meet_state_n, meetsel; // �浹 ������ ���� �������庯���� �� �����������庯��, �浹�� � ball�� �浹�ߴ��� ���� ���庯��


always @(posedge clk or posedge rst) begin // �浹�� �浹�÷��� ��, ���� Ȥ�� ��2(���۴��)���½� ��
if(rst| (turn_st==2)) meetfin<=0;
else if(meetballs) meetfin<=1;
end

always @(*) begin // � ball�� �浹�ߴ��� ���� ����, ���� Ȥ�� ��2(���۴��)���½� �ʱ�ȭ
if(rst| (turn_st==2)) meetsel<=0;
else if(meet_ball1) meetsel<=1;
else if(meet_ball2) meetsel<=2;
else if(meet_ball3) meetsel<=3;
else if(meet_ball4) meetsel<=4;
else if(meet_ball5) meetsel<=5;
else if(meet_state==4) meetsel<=0;
else begin end
end

// �浹 �߻��� �̵����� �� �ʵ���Ż�� Ư����ҷ� �ڷ���Ʈ�� �̵����� ���ǹ�.  ���� Ȥ�� ��2(���۴��)���½� �÷��� ���� ���� ���� ó������.
// �浹 �߻��� �浹�����÷��� �������� �浹���� FSM���� ���� �� broom�۵� ��Ȱ��ȭ
// 0.�̵����� �� �� ball��, �浹�� ball�� ���� ����, �ӷ� �������. 1. ��������, ������� 2. �浹���� �������
// 3. �浹���� ��������, ��������, �̵��簳, 4���� ���� �� FSM���� ���� �÷��� ����
// 4. race���� ������ ���� ����. ������  fsm �۵� �����·�.
always @(posedge clk or posedge rst) begin
if(rst| (turn_st==2)) begin  meet_calc<=0; meet_state_n<=0; sav_dir<=0; sav_s<=0; copy_dir<=0; copy_s<=0; mv_stop<=0; broomdisable<=0; end
else if (outof_field) mv_stop<=1;
else if (meetballs==1) begin meet_calc<=1; broomdisable<=1;
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

reg [1:0] xdir_sav_me,ydir_sav_me; //�ڱ� �ڽ��� ���Ⱚ ����
reg [1:0] xdir_sav_mef,ydir_sav_mef; //�ڱ� �ڽ��� ���Ⱚ ó�� �� ����
reg [1:0] xdir_sav_oth,ydir_sav_oth; //�ε��� ����� ���Ⱚ ����
reg [1:0] xdir_sav_othf,ydir_sav_othf; //�ε��� ����� ���Ⱚ ó�� �� ����

// ���� Ȥ�� ��2(���۴��)�� ���尪 �ʱ�ȭ, �����ȣ ������ �� ball�� ���� ���� �� ����.
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
 
 
reg sav_dir_fin_x; //���� �Ϸ� �÷���
reg sav_dir_fin_y;
 
 // ���� Ȥ�� ��2(���۴��)�� ���尪 �ʱ�ȭ, �����ȣ ������ �ٸ� ball�� ���� ���Ⱚ ����.
 always @(posedge clk or posedge rst) begin
    if(rst | (turn_st==2) ) begin xdir_sav_oth<= 0; sav_dir_fin_x<=0; end
    else if (meet_ball1 && sav_dir && sav_dir_fin_x==0 ) begin xdir_sav_oth <= xdir_1; sav_dir_fin_x<=1; end
    else if (meet_ball2 && sav_dir && sav_dir_fin_x==0 ) begin xdir_sav_oth <= xdir_2; sav_dir_fin_x<=1; end
    else if (meet_ball3 && sav_dir && sav_dir_fin_x==0 ) begin xdir_sav_oth <= xdir_3; sav_dir_fin_x<=1; end
    else if (meet_ball4 && sav_dir && sav_dir_fin_x==0 ) begin xdir_sav_oth <= xdir_4; sav_dir_fin_x<=1; end
    else if (meet_ball5 && sav_dir && sav_dir_fin_x==0 ) begin xdir_sav_oth <= xdir_5; sav_dir_fin_x<=1; end
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

//��0(�� ball�� ���� �ε������)�浹���� ��갪�� �̿��Ͽ� ƨ�ܳ��� ���� ����. ������ 45�� ����.
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
      
 
 //��3(�ٸ� ball�� �ͼ� �ε������)�浹���� ��갪�� �̿��Ͽ� ƨ�ܳ��� ���� ����. ������ 45�� ����.  
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

      
// ���Ⱚ Ȯ��.
// ���� Ȥ�� ��2(���۴��)�� ���Ⱚ ����, ��1(���������ġ)�� x���� ���������� ����, ��6(�ӽû���)�� ���Ⱚ ����. ���� �浹�� ���� ����
// �浹�� �����÷��� ������ �浹������ ���� ���� �Է�.
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

wire meetballs,meetballs_r; // �ٸ� ball���� �浹�Ǻ�. ���ӽ�ȣ ������ ���� ��ٿ��ó��.

assign meetballs_r = (meet_ball1 || meet_ball2 || meet_ball3 || meet_ball4 || meet_ball5)? 1 : 0;
debounce #(.BTN_WIDTH(1)) debounce_mtb_inst (clk, rst, meetballs_r, ,meetballs);


//////////////////
///// speed /////
////////////////

reg [3:0] sx, sy; // �ڽ��� �ӷ�
reg [3:0] sx_sav_me, sy_sav_me; // �ڽ��� �ӷ� ����
reg [3:0] sx_sav_mef, sy_sav_mef; // �ڽ��� �ӷ� ó����  ����
reg [3:0] sx_sav_oth,sy_sav_oth; // �ε��� ����� �ӷ� ����
reg [3:0] sx_sav_othf,sy_sav_othf; // �ε��� ����� �ӷ� ó���� ����

// ���� Ȥ�� ��2(���۴��)�� ���尪 �ʱ�ȭ, �����ȣ ������ �� ball�� ���� �ӷ°� ����.
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

reg sav_s_fin_x; //���� �Ϸ� �÷���
reg sav_s_fin_y; 

// ���� Ȥ�� ��2(���۴��)�� ���尪 �ʱ�ȭ, �����ȣ ������ �ٸ� ball�� ���� �ӷ°� ����.
always @(posedge clk or posedge rst) begin
    if(rst | (turn_st==2) ) begin sx_sav_oth <= 0; sav_s_fin_x<=0;end
    else if (sav_s && meet_ball1 && sav_s_fin_x==0) begin sx_sav_oth <= sx_in_1; sav_s_fin_x<=1; end
    else if (sav_s && meet_ball2 && sav_s_fin_x==0) begin sx_sav_oth <= sx_in_2; sav_s_fin_x<=1; end
    else if (sav_s && meet_ball3 && sav_s_fin_x==0) begin sx_sav_oth <= sx_in_3; sav_s_fin_x<=1; end
    else if (sav_s && meet_ball4 && sav_s_fin_x==0) begin sx_sav_oth <= sx_in_4; sav_s_fin_x<=1; end
    else if (sav_s && meet_ball5 && sav_s_fin_x==0) begin sx_sav_oth <= sx_in_5; sav_s_fin_x<=1; end
    else if (meetfin==1) sav_s_fin_x<=0;
    else begin end;
      end


      
 always @(posedge clk or posedge rst) begin
    if(rst | (turn_st==2) ) begin sy_sav_oth <= 0; sav_s_fin_y<=0;end
    else if (sav_s && meet_ball1 && sav_s_fin_y==0) begin sy_sav_oth <= sy_in_1; sav_s_fin_y<=1; end
    else if (sav_s && meet_ball2 && sav_s_fin_y==0) begin sy_sav_oth <= sy_in_2; sav_s_fin_y<=1; end
    else if (sav_s && meet_ball3 && sav_s_fin_y==0) begin sy_sav_oth <= sy_in_3; sav_s_fin_y<=1; end
    else if (sav_s && meet_ball4 && sav_s_fin_y==0) begin sy_sav_oth <= sy_in_4; sav_s_fin_y<=1; end
    else if (sav_s && meet_ball5 && sav_s_fin_y==0) begin sy_sav_oth <= sy_in_5; sav_s_fin_y<=1; end
    else if (meetfin==1) sav_s_fin_y<=0;
    else begin end;
      end    



//��0(�� ball�� ���� �ε������)�浹�� ������ �ӷ°��� �̿��Ͽ� ƨ�ܳ��� �ӷ� ����. �Ҽ��������� �Ұ��� �Ѱ��, �밢���̵� �Ÿ� ������ �ø��Ͽ� �����Ͽ���.
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
 
 //��3(�ٸ�  ball�� �ͼ� �ε������)�浹�� ������ �ӷ°��� �̿��Ͽ� ƨ�ܳ��� �ӷ� ����. �Ҽ��������� �Ұ��� �Ѱ��, �밢���̵� �Ÿ� ������ �ø��Ͽ� �����Ͽ���.     
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

//�ӷ¿� ���� ���� ������ ���� 3���� ī���� �޽��߻� ���.
always @ (posedge clk or posedge rst) begin
if(rst || (shoot==1) || (meetballs==1) || (mv_stop==1)) so<=0;
else
    if (so==7559459-1) so<=0;
    else so<=so+1;
end
assign speeddown = (so==7559459-1)?1'b1 : 1'b0;  // 0.3sec



always @ (posedge clk or posedge rst) begin
if(rst || (shoot==1) || (meetballs==1) || (mv_stop==1)) so1<=0;
else
    if (so1==15103800-1) so1<=0;
    else so1<=so1+1;
end
assign speeddown1 = (so1==15103800-1)?1'b1 : 1'b0;  // 0.6sec

always @ (posedge clk or posedge rst) begin
if(rst || (shoot==1) || (meetballs==1) || (mv_stop==1) || (broomfront)) so2<=0;
else
    if (so2==22678378-1) so2<=0;
    else so2<=so2+1;
end
assign speeddown2 = (so2==22678378-1)?1'b1 : 1'b0;  // 0.9sec


// ���۽� ���� �� �ӷ� �������� 1�ʵ� �ڵ� �߻�(?) 
always @ (posedge clk or posedge rst) begin
if(rst || (turn_st==2) ) so3<=0;
else if(turn_st==0)
    if (so3==25173000-1) so3<=0;
    else so3<=so3+1;
end
assign sec1 = (so3==25173000-1)?1'b1 : 1'b0;  // 1sec


// �� ����� ���� �� �ӷ� �������� 3�ʵ� �ڵ� �� ���� 
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

//�ڵ� �� ���� ����. ���۹���� �� ball�� �̵��� ������ ���ߴ� ���� �����Ͽ� Ÿ�̸� ����.
reg [9:0] ball_x_pre, ball_y_pre;
reg [2:0] fincheck, fincheck_n;

always @ (posedge clk or posedge rst) begin
if(rst  || (turn_st==2) ) begin fincheck_n<=0; ball_x_pre<=0; ball_y_pre<=0; end
else case(fincheck)
0: if(sec1) fincheck_n<=1; else fincheck_n<=0;
1: if((ball_x_pre==ball_x)&&(ball_y_pre==ball_y)&&(mv_stop==0)) fincheck_n<=2; else if((ball_x_pre!=ball_x)&&(ball_y_pre!=ball_y)&&(mv_stop==0)) begin ball_x_pre<=ball_x; ball_y_pre<=ball_y; fincheck_n<=1; end
2: if(fin) fincheck_n<=0; else fincheck_n<=2;
default: fincheck_n<=0;
endcase
end

always @ (posedge clk or posedge rst) begin
if(rst || (turn_st==2) ) fincheck<=0;
else fincheck<=fincheck_n;
end


// speed
// �ӷ°� Ȯ��.
// ���� Ȥ�� ��2(���۴��)�� �ӷ°� ����, ��0(����)�� �ܺο��� ������ �ӷ� �Է�, ��5(�ӷ¼��û���)�� �ӷ°�0. ��6(�ӽû���)�� �ӷ°� ����.
// �浹�� �����÷��� ������ �浹������ ���� ���� �Է�.
// ���� �ӷ¿� ���� ���� �ð����� �ڵ� ���� �۵�.
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
/// ball coordinate ///
//////////////////////

// ball�� �̵�.
// ���� Ȥ�� ��2(���۴��)�� �����ҿ� ��ġ, �ʵ忡�� ����� ������ġ�� �ڷ���Ʈ�Ͽ� ����, ��1(�����غ�)�� ���ۼ����� �̵�,
//��5(�ӷ¼��û���) �� ��6(�ӽû���)�� ��ġ ����, ��4(���⼱��)�� ������ �ӷ°����� �ݺ��̵�, ��0(����) �� ��3(�ʵ���)�� ������ ����� ����,�ӷ¿� ���� �̵�.
always @(posedge clk or posedge rst) begin    //ball_x
    if(rst | (turn_st==2)) begin // if not your turn, stay at waiting area
        ball_x <= RD_X;
    end
    else if(outof_field) ball_x <=ST_X;
    else if(turn_st==1) begin // if your turn, teleport to start area
        ball_x <= ST_X;
    end
    else if(turn_st==5) ball_x<=ball_x;
    else if(turn_st==6) ball_x<=ball_x;
    
    // if in dir select mode
    else if((turn_st==4)&&(turn_st!=5)&&(frame_tick)&&(xdir==1)) ball_x <= ball_x+3;
    else if((turn_st==4)&&(turn_st!=5)&&(frame_tick)&&(xdir==2)) ball_x <= ball_x-3;
    
    
             
    else if(((turn_st==0) || (turn_st==3))&&(mv_stop==0)&&(frame_tick)&&(xdir==1)) ball_x <= ball_x + sx;
    else if(((turn_st==0) || (turn_st==3))&&(mv_stop==0)&&(frame_tick)&&(xdir==2)) ball_x <= ball_x - sx;
    else if(((turn_st==0) || (turn_st==3))&&(mv_stop==0)&&(frame_tick)&&(xdir==0)) ball_x <= ball_x;
    
    else ball_x <=ball_x;
    end
    
    
always @(posedge clk or posedge rst) begin //ball_y
    if(rst | (turn_st==2) ) begin // if not your turn, stay at waiting area
        ball_y <= RD_Y;
    end
    else if(outof_field) ball_y <=510;
    else if(turn_st==1) begin // if your turn, teleport to start area
        ball_y <= ST_Y;
    end
    else if(turn_st==6) ball_y<=ball_y;

    else if(((turn_st==0) || (turn_st==3))&&(mv_stop==0)&&(frame_tick)&&(ydir==1)) ball_y <= ball_y + sy;
    else if(((turn_st==0) || (turn_st==3))&&(mv_stop==0)&&(frame_tick)&&(ydir==2)) ball_y <= ball_y - sy;
    else if(((turn_st==0) || (turn_st==3))&&(mv_stop==0)&&(frame_tick)&&(ydir==0)) ball_y <= ball_y;

    else ball_y<=ball_y;
    end

//////////////    
/// broom ///
////////////

// �ø��� Broom�� ����.
// ������ �ӵ� ������ ���� (Ƚ����������) , ���� Ȥ�� ������ ���۹��� ���ý� ����(�·� �̵��ϴ��� Ȯ��=��, ��� �̵��ϴ��� Ȯ��=��)�� ���� ���ʸ� ����, �ش�������� �ӷ�����(Ƚ����������) 
//���� �̿ϼ� ����
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
/// draw ball shape ///
//////////////////////

wire [19:0] distance;

//�ø� ������ ������. ��� ball�� stone���� �ٲ���ϳ�...?
assign distance = (((ball_x-x)*(ball_x-x)) + ((ball_y-y)*(ball_y-y)));
assign ball_on = ((BALL_RAD-5)*(BALL_RAD-5) >= distance)? 1 : 0;
assign ball_edge = (BALL_RAD*BALL_RAD >= distance)? 1 : 0;
assign hand_on = ((x > ball_x-4) && (x < ball_x+4) && (y > ball_y-5) && (y < ball_y+10))? 1: 0;
assign real_edge = ((BALL_RAD+1)*(BALL_RAD+1) >= distance)? 1 : 0;

endmodule
