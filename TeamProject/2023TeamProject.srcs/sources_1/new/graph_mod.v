`timescale 1ns / 1ps

module graph_mod (clk, rst, x, y, key, key_pulse, rgb);

/*--------- color define -----------
----------- color define -----------
----------- color define ---------*/

parameter RGB_RED =     {4'd15,  4'd0,  4'd0};
parameter RGB_ORANGE =  {4'd15,  4'd9,  4'd0};
parameter RGB_YELLOW =  {4'd15,  4'd15, 4'd0};
parameter RGB_GREEN =   {4'd0,   4'd15, 4'd0};
parameter RGB_CYAN =    {4'd0,   4'd15, 4'd15};
parameter RGB_BLUE =    {4'd0,   4'd0,  4'd15};
parameter RGB_WHITE =   {4'd15,  4'd15, 4'd15};
parameter RGB_BLACK =   {4'd0,   4'd0,  4'd0};

parameter RGB_REDBROWN = {4'd7,   4'd0,  4'd0};
parameter RGB_DARKBROWN = {4'd2,   4'd0,  4'd0};
parameter RGB_LIGHTBLUE = {4'd6,   4'd13,  4'd15};
parameter RGB_LIGHTGREEN = {4'd8,   4'd15,  4'd7};
parameter RGB_LIGHTYELLOW = {4'd15,   4'd15,  4'd8};
parameter RGB_LIGHTORANGE = {4'd14,   4'd9,  4'd4};
parameter RGB_LIGHTRED = {4'd15,   4'd7,  4'd7};
parameter RGB_PURPLE =   {4'd9,   4'd0,  4'd9};

parameter RGB_JAHONG =  {4'd13,   4'd0, 4'd1};
parameter RGB_SKY =     {4'd0,   4'd9, 4'd14};

/*--------- screen size define -----------
----------- screen size define -----------
----------- screen size define ---------*/

parameter MAX_X = 640; 
parameter MAX_Y = 480;  

/*--------- wall define -----------
----------- wall define -----------
----------- wall define ---------*/

//wall0의 x 좌표
parameter WALL0_X_L = 166; 
parameter WALL0_X_R = 473;
parameter WALL0_Y_U = 0; 
parameter WALL0_Y_D = 5; // hdmi cut issue -> change from 1 to 5

//wall1 의 좌표 설정
parameter WALL1_X_L = 166; 
parameter WALL1_X_R = 169;
parameter WALL1_Y_U = 0; 
parameter WALL1_Y_D = 479;

//wall2 의 좌표 설정
parameter WALL2_X_L = 470; 
parameter WALL2_X_R = 473;
parameter WALL2_Y_U = 0; 
parameter WALL2_Y_D = 479;

/*--------- target define -----------
----------- target define -----------
----------- target define ---------*/

//target 의 좌표 설정
parameter TARGET_X_C = 318; 
parameter TARGET_Y_C = 100;
parameter TARGET_R = 90;

parameter TARGET0_COLOR = {RGB_SKY};
parameter TARGET1_COLOR = {RGB_WHITE};
parameter TARGET2_COLOR = {RGB_JAHONG};
parameter TARGET3_COLOR = {RGB_WHITE};

//ball
parameter BALL_R = 15;

/*--------- direction move bar define -----------
----------- direction move bar define -----------
----------- direction move bar define ---------*/

//move bar 의 좌표 설정
parameter MVBAR_X_L = 170; 
parameter MVBAR_X_R = 469;
parameter MVBAR_Y_U = 448; 
parameter MVBAR_Y_D = 449;

/*--------- power gauge bar define -----------
----------- power gauge bar define -----------
----------- power gauge bar define ---------*/

//gaugebarguide 의 좌표설정
parameter GAUGEGUIDE_X_L = 170; 
parameter GAUGEGUIDE_X_R = 469;
parameter GAUGEGUIDE_Y_U = 470; 
parameter GAUGEGUIDE_Y_D = 471;
//gauge bar move 의 좌표설정
parameter GAUGESHOW_X_L = 170; 
parameter GAUGESHOW_X_R = 173;
parameter GAUGESHOW_Y_U = 472; 
parameter GAUGESHOW_Y_D = 476; // // hdmi cut issue -> change from 9 to 6
//gauge bar 0 의 좌표설정
parameter GAUGEBAR0_X_L = 170; 
parameter GAUGEBAR0_X_R = 269;
parameter GAUGEBAR0_Y_U = 472; 
parameter GAUGEBAR0_Y_D = 479;
//gauge bar 1 의 좌표설정
parameter GAUGEBAR1_X_L = 270; 
parameter GAUGEBAR1_X_R = 349;
parameter GAUGEBAR1_Y_U = 472; 
parameter GAUGEBAR1_Y_D = 479;
//gauge bar 2 의 좌표설정
parameter GAUGEBAR2_X_L = 350; 
parameter GAUGEBAR2_X_R = 409;
parameter GAUGEBAR2_Y_U = 472; 
parameter GAUGEBAR2_Y_D = 479;
//gauge bar 3 의 좌표설정
parameter GAUGEBAR3_X_L = 410; 
parameter GAUGEBAR3_X_R = 449;
parameter GAUGEBAR3_Y_U = 472; 
parameter GAUGEBAR3_Y_D = 479;
//gauge bar 4 의 좌표설정
parameter GAUGEBAR4_X_L = 450; 
parameter GAUGEBAR4_X_R = 469;
parameter GAUGEBAR4_Y_U = 472; 
parameter GAUGEBAR4_Y_D = 479;

/*--------- input, output, wire and regs for module -----------
----------- input, output, wire and regs for module -----------
----------- input, output, wire and regs for module ---------*/

input clk, rst;
input [9:0] x, y;
input [4:0] key, key_pulse; 
output [11:0] rgb; 

wire clk_1hz;
counter clk1(clk, rst, clk_1hz);

wire frame_tick; 

wire [2:0] wall_on;
wire [3:0] target_on;
wire [4:0] gaugebar_on;
wire gaugeshow_on, gaugeguide_on, mvbar_on;



wire reach_top, reach_bottom, reach_wall, reach_bar, miss_ball;
reg game_stop, game_over;  

//refrernce tick 
assign frame_tick = (y==MAX_Y-1 && x==MAX_X-1)? 1 : 0; // 매 프레임마다 한 clk 동안만 1이 됨. 

// wall
assign wall_on[0] = (x>=WALL0_X_L && x<=WALL0_X_R && y>=WALL0_Y_U && y<=WALL0_Y_D)? 1 : 0; //wall이 있는 영역
assign wall_on[1] = (x>=WALL1_X_L && x<=WALL1_X_R && y>=WALL1_Y_U && y<=WALL1_Y_D)? 1 : 0; //wall이 있는 영역
assign wall_on[2] = (x>=WALL2_X_L && x<=WALL2_X_R && y>=WALL2_Y_U && y<=WALL2_Y_D)? 1 : 0; //wall이 있는 영역



//숫자 큰 원이 작은 원, 점수가 큼 target
circle target3(.x(x), .y(y), .cir_x(TARGET_X_C), .cir_y(TARGET_Y_C), .cir_r(15), .cir_rgb(), .circle_on(target_on[3]));
circle target2(.x(x), .y(y), .cir_x(TARGET_X_C), .cir_y(TARGET_Y_C), .cir_r(30), .cir_rgb(), .circle_on(target_on[2]));
circle target1(.x(x), .y(y), .cir_x(TARGET_X_C), .cir_y(TARGET_Y_C), .cir_r(60), .cir_rgb(), .circle_on(target_on[1]));
circle target0(.x(x), .y(y), .cir_x(TARGET_X_C), .cir_y(TARGET_Y_C), .cir_r(90), .cir_rgb(), .circle_on(target_on[0]));

// wall
assign mvbar_on = (x>=MVBAR_X_L  && x<=MVBAR_X_R  && y>=MVBAR_Y_U  && y<=MVBAR_Y_D )? 1 : 0; //wall이 있는 영역

//gauge bar
//assign gaugeshow_on = (x>=GAUGESHOW_X_L && x<=GAUGESHOW_X_R && y>=GAUGESHOW_Y_U && y<=GAUGESHOW_Y_D)? 1 : 0; //gaugebar 표시가 있는 영역
assign gaugebar_on[0] = (x>=GAUGEBAR0_X_L && x<=GAUGEBAR0_X_R && y>=GAUGEBAR0_Y_U && y<=GAUGEBAR0_Y_D)? 1 : 0; //gaugebar가 있는 영역
assign gaugebar_on[1] = (x>=GAUGEBAR1_X_L && x<=GAUGEBAR1_X_R && y>=GAUGEBAR1_Y_U && y<=GAUGEBAR1_Y_D)? 1 : 0; //gaugebar가 있는 영역
assign gaugebar_on[2] = (x>=GAUGEBAR2_X_L && x<=GAUGEBAR2_X_R && y>=GAUGEBAR2_Y_U && y<=GAUGEBAR2_Y_D)? 1 : 0; //gaugebar가 있는 영역
assign gaugebar_on[3] = (x>=GAUGEBAR3_X_L && x<=GAUGEBAR3_X_R && y>=GAUGEBAR3_Y_U && y<=GAUGEBAR3_Y_D)? 1 : 0; //gaugebar가 있는 영역
assign gaugebar_on[4] = (x>=GAUGEBAR4_X_L && x<=GAUGEBAR4_X_R && y>=GAUGEBAR4_Y_U && y<=GAUGEBAR4_Y_D)? 1 : 0; //gaugebar가 있는 영역
assign gaugeguide_on = (x>=GAUGEGUIDE_X_L && x<=GAUGEGUIDE_X_R && y>=GAUGEGUIDE_Y_U && y<=GAUGEGUIDE_Y_D)? 1 : 0; //gaugebar guide가 있는 영역

/*---------------------------------------------------------*/
// circle test
/*---------------------------------------------------------*/
wire circle_on;
circle circle_test(.x(x), .y(y), .cir_x(200), .cir_y(200), .cir_r(BALL_R), .cir_rgb({4'd15,4'd15,4'd15}), .circle_on(circle_on));

wire [7:0] score_a, score_b;
scoring scoring_inst(
    .target_x(TARGET_X_C), .target_y(TARGET_Y_C), .target_r(TARGET_R), 
    .ball_x_a1(), .ball_y_a1(),
    .ball_x_a2(), .ball_y_a2(),
    .ball_x_a3(), .ball_y_a3(),

    .ball_x_b1(), .ball_y_b1(),
    .ball_x_b2(), .ball_y_b2(),
    .ball_x_b3(), .ball_y_b3(),

    .ball_r(BALL_R),

    .on_track_count(),
    .score_a(score_a), .score_b(score_b)
    );



/*---------------------------------------------------------*/
// text on screen 
/*---------------------------------------------------------*/
// score region
wire [6:0] char_addr;
reg [6:0] char_addr_l, char_addr_s, char_addr_o, char_addr_r_s, char_addr_b_s;
wire [2:0] bit_addr;
reg [2:0] bit_addr_l, bit_addr_s, bit_addr_o, bit_addr_r_s, bit_addr_b_s;
wire [3:0] row_addr, row_addr_l, row_addr_s, row_addr_o, row_addr_r_s, row_addr_b_s; 
wire red_on, blue_on, over_on, red_score_on, blue_score_on;

wire font_bit;
wire [7:0] font_word;
wire [10:0] rom_addr;

font_rom_vhd font_rom_inst (clk, rom_addr, font_word);

assign rom_addr = {char_addr, row_addr};
assign font_bit = font_word[~bit_addr]; 

assign char_addr = (red_on)? char_addr_l :(blue_on)? char_addr_s :(red_score_on)? char_addr_r_s :(blue_score_on)? char_addr_b_s : (over_on)? char_addr_o : 0;  // score    ? 
assign row_addr =  (red_on)? row_addr_l : (blue_on)? row_addr_s :(red_score_on)? row_addr_r_s :(blue_score_on)? row_addr_b_s : (over_on)? row_addr_o : 0; 
assign bit_addr =  (red_on)? bit_addr_l : (blue_on)? bit_addr_s :(red_score_on)? bit_addr_r_s :(blue_score_on)? bit_addr_b_s : (over_on)? bit_addr_o : 0; 


// TEAM RED(red_on) : 'l'
wire [9:0] red_x_l, red_y_t; 
assign red_x_l = 50; 
assign red_y_t = 50; 
assign red_on = (y>=red_y_t && y<red_y_t+32 && x>=red_x_l && x<red_x_l+16*3)? 1 : 0;
assign row_addr_l = (y-red_y_t) >> 1;
always @(*) begin
    if (x>=red_x_l+16*0 && x<red_x_l+16*1) begin bit_addr_l = (x-red_x_l-16*0) >> 1; char_addr_l = 7'b1010010; end // R x52
    else if (x>=red_x_l+16*1 && x<red_x_l+16*2) begin bit_addr_l = (x-red_x_l-16*1) >> 1; char_addr_l = 7'b1000101; end // E x45
    else if (x>=red_x_l+16*2 && x<red_x_l+16*3) begin bit_addr_l = (x-red_x_l-16*2) >> 1; char_addr_l = 7'b1000100; end // D x44
    else begin bit_addr_l = 0; char_addr_l = 0; end   
end

// {6'b011000, score_red} score에 변수를 불러와서 숫자를 바꿀 수 있음.
// {6'b011000, score_Blue}

// TEAM RED SCORE
wire [9:0] red_score_x_l, red_score_y_t; 
assign red_score_x_l = 70; 
assign red_score_y_t = 110; 
assign red_score_on = (y>=red_score_y_t && y<red_score_y_t+32 && x>=red_score_x_l && x<red_score_x_l+16*3)? 1 : 0;
assign row_addr_r_s = (y-red_score_y_t) >> 1;
always @(*) begin
    if (x>=red_score_x_l+16*0 && x<red_score_x_l+16*1) begin bit_addr_r_s = (x-red_score_x_l-16*0) >> 1; char_addr_r_s = 7'b0110000; end //       ?               
    else begin bit_addr_r_s = 0; char_addr_r_s = 0; end   
end

// TEAM BLUE(blue_on) 's'
wire [9:0] blue_x_l, blue_y_t;
assign blue_x_l = 540; 
assign blue_y_t = 50; 
assign blue_on = (y>=blue_y_t && y<blue_y_t+32 && x>=blue_x_l && x<blue_x_l+16*4)? 1 : 0; 
assign row_addr_s = (y-blue_y_t) >> 1;
always @ (*) begin
    if (x>=blue_x_l+16*0 && x<blue_x_l+16*1) begin bit_addr_s = (x-blue_x_l-16*0)>>1; char_addr_s = 7'b1000010; end // B x42
    else if (x>=blue_x_l+16*1 && x<blue_x_l+16*2) begin bit_addr_s = (x-blue_x_l-16*1)>>1; char_addr_s = 7'b1001100; end // L x4c
    else if (x>=blue_x_l+16*2 && x<blue_x_l+16*3) begin bit_addr_s = (x-blue_x_l-16*2)>>1; char_addr_s = 7'b1010101; end // U x55
    else if (x>=blue_x_l+16*3 && x<blue_x_l+16*4) begin bit_addr_s = (x-blue_x_l-16*3)>>1; char_addr_s = 7'b1000101; end // E x45
    else begin bit_addr_s = 0; char_addr_s = 0; end                         
end

// TEAM BLUE SCORE
wire [9:0] blue_score_x_l, blue_score_y_t; 
assign blue_score_x_l = 570; 
assign blue_score_y_t = 110; 
assign blue_score_on = (y>=blue_score_y_t && y<blue_score_y_t+32 && x>=blue_score_x_l && x<blue_score_x_l+16*3)? 1 : 0;
assign row_addr_b_s = (y-blue_score_y_t) >> 1;
always @(*) begin
    if (x>=blue_score_x_l+16*0 && x<blue_score_x_l+16*1) begin bit_addr_b_s = (x-blue_score_x_l-16*0) >> 1; char_addr_b_s = 7'b0110000; end //       ?               
    else begin bit_addr_b_s = 0; char_addr_b_s = 0; end   
end
// game over
assign over_on = (game_over==1 && y[9:6]==3 && x[9:5]>=5 && x[9:5]<=13)? 1 : 0; 
assign row_addr_o = y[5:2];
always @(*) begin
    bit_addr_o = x[4:2];
    case (x[9:5]) 
        5: char_addr_o = 7'b1000111; // G x47
        6: char_addr_o = 7'b1100001; // a x61
        7: char_addr_o = 7'b1101101; // m x6d
        8: char_addr_o = 7'b1100101; // e x65
        9: char_addr_o = 7'b0000000; //                      
        10: char_addr_o = 7'b1001111; // O x4f
        11: char_addr_o = 7'b1110110; // v x76
        12: char_addr_o = 7'b1100101; // e x65
        13: char_addr_o = 7'b1110010; // r x72
        default: char_addr_o = 0; 
    endcase
end




/*---------------------------------------------------------*/
// color setting
/*---------------------------------------------------------*/
assign rgb = (font_bit & red_on)?        RGB_RED : //RED text_RED
             (font_bit & blue_on)?       RGB_BLUE : //blue text_BLUE
             (font_bit & red_score_on)?  RGB_RED :  // RED SCORE
             (font_bit & blue_score_on)? RGB_BLUE :  // BLUE SCORE
             (font_bit & over_on)?       RGB_PURPLE : //blue text

             (wall_on[0])?          RGB_REDBROWN : //brown wall
             (wall_on[1])?          RGB_REDBROWN : //brown wall
             (wall_on[2])?          RGB_REDBROWN : //brown wall
             
             (ball_on[0])?          RGB_RED : //ball 0 red
             (ball_on[1])?          RGB_BLUE : //ball 1 blue
             (ball_on[2])?          RGB_RED : //ball 2 red
             (ball_on[3])?          RGB_BLUE : //ball 3 blue
             (ball_on[4])?          RGB_RED : //ball 4 red
             (ball_on[5])?          RGB_BLUE : //ball 5 blue
             
             (target_on[3])?        TARGET3_COLOR : //SMALLEST target
             (target_on[2])?        TARGET2_COLOR :
             (target_on[1])?        TARGET1_COLOR :
             (target_on[0])?        TARGET0_COLOR : //LARGEST target
             
             (mvbar_on)?            RGB_DARKBROWN : //move bar
             (gaugeguide_on)?       RGB_BLACK     : //gauge guide bar                    
             (gaugeshow_on)?        RGB_BLACK     : //black gauge bar          
             (gaugebar_on[0])?      RGB_LIGHTBLUE : //lightblue gauge bar
             (gaugebar_on[1])?      RGB_LIGHTGREEN : //lightgreen gauge bar
             (gaugebar_on[2])?      RGB_LIGHTYELLOW: //lightyellow gauge bar
             (gaugebar_on[3])?      RGB_LIGHTORANGE: //lightorange gauge bar
             (gaugebar_on[4])?      RGB_LIGHTRED   : //lightred gauge bar
             (circle_on)?           RGB_ORANGE : // circle_test
                                    RGB_WHITE ; //white background
                                    
                                    
                                    
wire [9:0] ball_x [5:0];
wire [9:0] ball_y [5:0];
reg [2:0] turn_st[5:0]; // 0:your turn, 1: ready, 2: wait 3: turn end, 4: dir select
wire ball_on[5:0];
reg [3:0] vx_in[5:0];
reg [3:0] vy_in[5:0];
wire [3:0] vx_out[5:0];
wire [3:0] vy_out[5:0];
wire [1:0] xdir_out[5:0];
wire [1:0] ydir_out[5:0];



//game auto state
reg gamereset,gamekeep,resetdata;
reg [3:0] gamestate, gamenstate;

parameter GAMESTANBY=0, GAMEREADY=1, GAME0ST=2, GAME1ST=3, GAME2ST=4, GAME3ST=5, GAME4ST=6, GAME5ST=7, GAMEEND=8;

always @ (*) begin
case(gamestate)
    GAMESTANBY: if(key_pulse==5'h11) begin gamenstate <=GAMEREADY; end else begin gamenstate<=GAMESTANBY; b0_st<=0; b1_st<=0; b2_st<=0; b3_st<=0; b4_st<=0; b5_st<=0; end
    GAMEREADY : if(gamekeep==1) begin resetdata<=0; gamenstate<=GAME0ST; end else begin resetdata<=1; gamenstate<=GAME0ST; end
    GAME0ST : if(turn_st[0]==3) begin b0_st<=0; gamenstate<=GAME1ST; end else begin b0_st<=1; b1_st<=0; b2_st<=0; b3_st<=0; b4_st<=0; b5_st<=0; gamenstate<=GAME0ST; end
    GAME1ST : if(turn_st[1]==3) begin b1_st<=0; gamenstate<=GAME2ST; end else begin b1_st<=1; b0_st<=0; b2_st<=0; b3_st<=0; b4_st<=0; b5_st<=0; gamenstate<=GAME1ST; end
    GAME2ST : if(turn_st[2]==3) begin b2_st<=0; gamenstate<=GAME3ST; end else begin b2_st<=1; b0_st<=0; b1_st<=0; b3_st<=0; b4_st<=0; b5_st<=0; gamenstate<=GAME2ST; end
    GAME3ST : if(turn_st[3]==3) begin b3_st<=0; gamenstate<=GAME4ST; end else begin b3_st<=1; b0_st<=0; b1_st<=0; b2_st<=0; b4_st<=0; b5_st<=0; gamenstate<=GAME3ST; end
    GAME4ST : if(turn_st[4]==3) begin b4_st<=0; gamenstate<=GAME5ST; end else begin b4_st<=1; b0_st<=0; b1_st<=0; b2_st<=0; b3_st<=0; b5_st<=0; gamenstate<=GAME4ST; end
    GAME5ST : if(turn_st[5]==3) begin b5_st<=0; gamenstate<=GAMEEND; end else begin b5_st<=1; b0_st<=0; b1_st<=0; b2_st<=0; b3_st<=0; b4_st<=0; gamenstate<=GAME5ST; end
    GAMEEND : gamenstate<=GAMESTANBY;
    default : gamenstate <=GAMEREADY;
    endcase
    end
    

 always @(posedge clk or posedge rst) begin
 if(rst) gamestate <= GAMESTANBY;
 else gamestate <= gamenstate;
 end   


reg [2:0] b0_c, b0_n, b1_c, b1_n, b2_c, b2_n, b3_c, b3_n, b4_c, b4_n, b5_c, b5_n;
parameter GSTANBY=3'd0, GSTART=3'd1, GDIRSEL=3'd2, GPOWSEL=3'd3,  GMOVE=3'd4, GEND=3'd5;
reg b0_st, b0_dir, b0_stop, b1_st, b1_dir, b1_stop, b2_st, b2_dir, b2_stop, b3_st, b3_dir, b3_stop, b4_st, b4_dir, b4_stop, b5_st, b5_dir, b5_stop;



always @(*) begin   //for test, b(n)_stop replaced to key_pulse==5'h19
if(rst) turn_st[0]<=2;
else
case(b0_c)
    GSTANBY : if(b0_st==1) b0_n <= GSTART; else begin turn_st[0]<=2; b0_n <= GSTANBY; end
    GSTART  : begin if(turn_st[0]==1) b0_n <= GDIRSEL; else turn_st[0]<=1;  end
    GDIRSEL : if(key_pulse==5'h12) begin turn_st[0]<=5; b0_n <= GPOWSEL; end else begin turn_st[0]<=4; b0_n <= GDIRSEL; end
    GPOWSEL : if(powsel==1) b0_n <= GMOVE; else begin b0_n <= GPOWSEL; end
    GMOVE   : if(key_pulse==5'h19) begin turn_st[0]<=3; b0_n <= GEND; end else begin turn_st[0]<=0; b0_n <= GMOVE; end
    GEND    : if(gamereset==1)b0_n <= GSTANBY; else begin turn_st[0]<=3; b0_n <= GEND; end
    default : begin turn_st[0]<=2; b0_n <= GSTANBY; end
    endcase
    end


always @(*) begin
if(rst) turn_st[1]<=2;
else
case(b1_c)
    GSTANBY : if(b1_st==1) b1_n <= GSTART; else begin turn_st[1]<=2; b1_n <= GSTANBY; end
    GSTART  : begin if(turn_st[1]==1) b1_n <= GDIRSEL; else turn_st[1]<=1; end
    GDIRSEL : if(key_pulse==5'h12) begin turn_st[1]<=5; b1_n <= GPOWSEL; end else begin turn_st[1]<=4; b1_n <= GDIRSEL; end
    GPOWSEL : if(powsel==1) b1_n <= GMOVE; else begin b1_n <= GPOWSEL; end
    GMOVE   : if(key_pulse==5'h19) begin turn_st[1]<=3; b1_n <= GEND; end else begin turn_st[1]<=0; b1_n <= GMOVE; end
    GEND    : if(gamereset==1)b1_n <= GSTANBY; else begin turn_st[1]<=3; b1_n <= GEND; end
    default : begin turn_st[1]<=2; b1_n <= GSTANBY; end
    endcase
    end


always @(*) begin
if(rst) turn_st[2]<=2;
else
case(b2_c)
    GSTANBY : if(b2_st==1) b2_n <= GSTART; else begin turn_st[2]<=2; b2_n <= GSTANBY; end
    GSTART  : begin if(turn_st[2]==1) b2_n <= GDIRSEL; else turn_st[2]<=1;  end
    GDIRSEL : if(key_pulse==5'h12) begin turn_st[2]<=5; b2_n <= GPOWSEL; end else begin turn_st[2]<=4; b2_n <= GDIRSEL; end
    GPOWSEL : if(powsel==1) b2_n <= GMOVE; else begin b2_n <= GPOWSEL; end
    GMOVE   : if(key_pulse==5'h19) begin turn_st[2]<=3; b2_n <= GEND; end else begin turn_st[2]<=0; b2_n <= GMOVE; end
    GEND    : if(gamereset==1)b2_n <= GSTANBY; else begin turn_st[2]<=3; b2_n <= GEND; end
    default : begin turn_st[2]<=2; b2_n <= GSTANBY; end
    endcase
    end


always @(*) begin
if(rst) turn_st[3]<=2;
else
case(b3_c)
    GSTANBY : if(b3_st==1) b3_n <= GSTART; else begin turn_st[3]<=2; b3_n <= GSTANBY; end
    GSTART  : begin if(turn_st[3]==1) b3_n <= GDIRSEL; else turn_st[3]<=1;  end
    GDIRSEL : if(key_pulse==5'h12) begin turn_st[3]<=5; b3_n <= GPOWSEL; end else begin turn_st[3]<=4; b3_n <= GDIRSEL; end
    GPOWSEL : if(powsel==1) b3_n <= GMOVE; else begin b3_n <= GPOWSEL; end
    GMOVE   : if(key_pulse==5'h19) begin turn_st[3]<=3; b3_n <= GEND; end else begin turn_st[3]<=0; b3_n <= GMOVE; end
    GEND    : if(gamereset==1)b3_n <= GSTANBY; else begin turn_st[3]<=3; b3_n <= GEND; end
    default : begin turn_st[3]<=2; b3_n <= GSTANBY; end
    endcase
    end


always @(*) begin
if(rst) turn_st[4]<=2;
else
case(b4_c)
    GSTANBY : if(b4_st==1) b4_n <= GSTART; else begin turn_st[4]<=2; b4_n <= GSTANBY; end
    GSTART  : begin if(turn_st[4]==1) b4_n <= GDIRSEL; else turn_st[4]<=1;  end
    GDIRSEL : if(key_pulse==5'h12) begin turn_st[4]<=5; b4_n <= GPOWSEL; end else begin turn_st[4]<=4; b4_n <= GDIRSEL; end
    GPOWSEL : if(powsel==1) b4_n <= GMOVE; else begin b4_n <= GPOWSEL; end
    GMOVE   : if(key_pulse==5'h19) begin turn_st[4]<=3; b4_n <= GEND; end else begin turn_st[4]<=0; b4_n <= GMOVE; end
    GEND    : if(gamereset==1)b4_n <= GSTANBY; else begin turn_st[4]<=3; b4_n <= GEND; end
    default : begin turn_st[4]<=2; b4_n <= GSTANBY; end
    endcase
    end


always @(*) begin
if(rst) turn_st[5]<=2;
else
case(b5_c)
    GSTANBY : if(b5_st==1) b5_n <= GSTART; else begin turn_st[5]<=2; b5_n <= GSTANBY; end
    GSTART  : begin if(turn_st[5]==1) b5_n <= GDIRSEL; else turn_st[5]<=1;  end
    GDIRSEL : if(key_pulse==5'h12) begin turn_st[5]<=5; b5_n <= GPOWSEL; end else begin turn_st[5]<=4; b5_n <= GDIRSEL; end
    GPOWSEL : if(powsel==1) b5_n <= GMOVE; else begin b5_n <= GPOWSEL; end
    GMOVE   : if(key_pulse==5'h19) begin turn_st[5]<=3; b5_n <= GEND; end else begin turn_st[5]<=0; b5_n <= GMOVE; end
    GEND    : if(gamereset==1)b5_n <= GSTANBY; else begin turn_st[5]<=3; b5_n <= GEND; end
    default : begin turn_st[5]<=2; b5_n <= GSTANBY; end
    endcase
    end

    
 always @(posedge clk or posedge rst) begin
 if(rst) begin b0_c <= GSTANBY; b1_c <= GSTANBY; b2_c <= GSTANBY; b3_c <= GSTANBY; b4_c <= GSTANBY; b5_c <= GSTANBY; end
 else begin b0_c <= b0_n; b1_c <= b1_n; b2_c <= b2_n; b3_c <= b3_n; b4_c <= b4_n; b5_c <= b5_n; end
 end   
 
ball #(.RD_X(85), .RD_Y(200)) ball0(clk, rst, frame_tick, x, y, ball_x[0], ball_y[0], key, key_pulse, turn_st[0], ball_on[0],vx_in[0], vy_in[0],vx_out[0],vy_out[0],xdir_out[0],ydir_out[0], ball_x[1], ball_y[1],vx_out[1],vy_out[1],xdir_out[1],ydir_out[1],ball_x[2], ball_y[2],vx_out[2],vy_out[2],xdir_out[2],ydir_out[2],ball_x[3], ball_y[3],vx_out[3],vy_out[3],xdir_out[3],ydir_out[3],ball_x[4], ball_y[4],vx_out[4],vy_out[4],xdir_out[4],ydir_out[4],ball_x[5], ball_y[5],vx_out[5],vy_out[5],xdir_out[5],ydir_out[5]);
ball #(.RD_X(555), .RD_Y(200)) ball1(clk, rst,frame_tick,x, y, ball_x[1], ball_y[1], key, key_pulse, turn_st[1], ball_on[1],vx_in[1], vy_in[1],vx_out[1],vy_out[1],xdir_out[1],ydir_out[1], ball_x[0], ball_y[0],vx_out[0],vy_out[0],xdir_out[0],ydir_out[0],ball_x[2], ball_y[2],vx_out[2],vy_out[2],xdir_out[2],ydir_out[2],ball_x[3], ball_y[3],vx_out[3],vy_out[3],xdir_out[3],ydir_out[3],ball_x[4], ball_y[4],vx_out[4],vy_out[4],xdir_out[4],ydir_out[4],ball_x[5], ball_y[5],vx_out[5],vy_out[5],xdir_out[5],ydir_out[5]);
ball #(.RD_X(85), .RD_Y(250)) ball2(clk, rst,frame_tick,x, y, ball_x[2], ball_y[2], key, key_pulse, turn_st[2], ball_on[2],vx_in[2], vy_in[2],vx_out[2],vy_out[2],xdir_out[2],ydir_out[2], ball_x[0], ball_y[0],vx_out[0],vy_out[0],xdir_out[0],ydir_out[0],ball_x[1], ball_y[1],vx_out[1],vy_out[1],xdir_out[1],ydir_out[1],ball_x[3], ball_y[3],vx_out[3],vy_out[3],xdir_out[3],ydir_out[3],ball_x[4], ball_y[4],vx_out[4],vy_out[4],xdir_out[4],ydir_out[4],ball_x[5], ball_y[5],vx_out[5],vy_out[5],xdir_out[5],ydir_out[5]);
ball #(.RD_X(555), .RD_Y(250)) ball3(clk, rst,frame_tick,x, y, ball_x[3], ball_y[3], key, key_pulse, turn_st[3], ball_on[3],vx_in[3], vy_in[3],vx_out[3],vy_out[3],xdir_out[3],ydir_out[3], ball_x[0], ball_y[0],vx_out[0],vy_out[0],xdir_out[0],ydir_out[0],ball_x[1], ball_y[1],vx_out[1],vy_out[1],xdir_out[1],ydir_out[1],ball_x[2], ball_y[2],vx_out[2],vy_out[2],xdir_out[2],ydir_out[2],ball_x[4], ball_y[4],vx_out[4],vy_out[4],xdir_out[4],ydir_out[4],ball_x[5], ball_y[5],vx_out[5],vy_out[5],xdir_out[5],ydir_out[5]);
ball #(.RD_X(85), .RD_Y(300)) ball4(clk, rst,frame_tick,x, y, ball_x[4], ball_y[4], key, key_pulse, turn_st[4], ball_on[4],vx_in[4], vy_in[4],vx_out[4],vy_out[4],xdir_out[4],ydir_out[4], ball_x[0], ball_y[0],vx_out[0],vy_out[0],xdir_out[0],ydir_out[0],ball_x[1], ball_y[1],vx_out[1],vy_out[1],xdir_out[1],ydir_out[1],ball_x[2], ball_y[2],vx_out[2],vy_out[2],xdir_out[2],ydir_out[2],ball_x[3], ball_y[3],vx_out[3],vy_out[3],xdir_out[3],ydir_out[3],ball_x[5], ball_y[5],vx_out[5],vy_out[5],xdir_out[5],ydir_out[5]);
ball #(.RD_X(555), .RD_Y(300)) ball5(clk, rst,frame_tick,x, y, ball_x[5], ball_y[5], key, key_pulse, turn_st[5], ball_on[5],vx_in[5], vy_in[5],vx_out[5],vy_out[5],xdir_out[5],ydir_out[5], ball_x[0], ball_y[0],vx_out[0],vy_out[0],xdir_out[0],ydir_out[0],ball_x[1], ball_y[1],vx_out[1],vy_out[1],xdir_out[1],ydir_out[1],ball_x[2], ball_y[2],vx_out[2],vy_out[2],xdir_out[2],ydir_out[2],ball_x[3], ball_y[3],vx_out[3],vy_out[3],xdir_out[3],ydir_out[3],ball_x[4], ball_y[4],vx_out[4],vy_out[4],xdir_out[4],ydir_out[4]);
 
 
/*                        
ball #(.RD_X(85), .RD_Y(200)) ball0(clk, rst,frame_tick,x, y, ball_x[0], ball_y[0], key, key_pulse, turn_st[0], ball_on[0],vx_in[0], vy_in[0], ball_x[1], ball_y[1], vx_in[1],vy_in[1], ball_x[2], ball_y[2],vx_in[2],vy_in[2], ball_x[3], ball_y[3], vx_in[3],vy_in[3], ball_x[4], ball_y[4], vx_in[4],vy_in[4], ball_x[5], ball_y[5], vx_in[5],vy_in[5]);
ball #(.RD_X(555), .RD_Y(200)) ball1(clk, rst,frame_tick,x, y, ball_x[1], ball_y[1], key, key_pulse, turn_st[1], ball_on[1],vx_in[1], vy_in[1], ball_x[0], ball_y[0],vx_in[0],vy_in[0], ball_x[2], ball_y[2],vx_in[2],vy_in[2], ball_x[3], ball_y[3], vx_in[3],vy_in[3], ball_x[4], ball_y[4], vx_in[4],vy_in[4], ball_x[5], ball_y[5], vx_in[5],vy_in[5]);
ball #(.RD_X(85), .RD_Y(250)) ball2(clk, rst,frame_tick,x, y, ball_x[2], ball_y[2], key, key_pulse, turn_st[2], ball_on[2],vx_in[2], vy_in[2], ball_x[0], ball_y[0], vx_in[0],vy_in[0], ball_x[1], ball_y[1],vx_in[1],vy_in[1], ball_x[3], ball_y[3], vx_in[3],vy_in[3], ball_x[4], ball_y[4], vx_in[4],vy_in[4], ball_x[5], ball_y[5], vx_in[5],vy_in[5]);
ball #(.RD_X(555), .RD_Y(250)) ball3(clk, rst,frame_tick,x, y, ball_x[3], ball_y[3], key, key_pulse, turn_st[3], ball_on[3],vx_in[3], vy_in[3], ball_x[0], ball_y[0],vx_in[0],vy_in[0],ball_x[1], ball_y[1],vx_in[1],vy_in[1], ball_x[2], ball_y[2], vx_in[2],vy_in[2], ball_x[4], ball_y[4], vx_in[4],vy_in[4], ball_x[5], ball_y[5], vx_in[5],vy_in[5]);
ball #(.RD_X(85), .RD_Y(300)) ball4(clk, rst,frame_tick,x, y, ball_x[4], ball_y[4], key, key_pulse, turn_st[4], ball_on[4],vx_in[4], vy_in[4], ball_x[0], ball_y[0],vx_in[0],vy_in[0],ball_x[1], ball_y[1],vx_in[1],vy_in[1], ball_x[2], ball_y[2], vx_in[2],vy_in[2], ball_x[3], ball_y[3], vx_in[3],vy_in[3], ball_x[5], ball_y[5], vx_in[5],vy_in[5]);
ball #(.RD_X(555), .RD_Y(300)) ball5(clk, rst,frame_tick,x, y, ball_x[5], ball_y[5], key, key_pulse, turn_st[5], ball_on[5],vx_in[5], vy_in[5], ball_x[0], ball_y[0],vx_in[0],vy_in[0],ball_x[1], ball_y[1],vx_in[1],vy_in[1], ball_x[2], ball_y[2], vx_in[2],vy_in[2], ball_x[3], ball_y[3], vx_in[3],vy_in[3], ball_x[4], ball_y[4], vx_in[4],vy_in[4]);
*/



//gauge moving functions

reg [9:0] gaugeshow_x; // for power gauge bar moving
reg [1:0] gaugeshow_dir;
reg powsel,gaugereset; // for checking power select is finished
wire [3:0] pow;
wire reachwall1, reachwall2;

assign pow = (gaugeshow_x>=GAUGEBAR0_X_L &&gaugeshow_x<=GAUGEBAR0_X_R) ? 6 :
             (gaugeshow_x>=GAUGEBAR1_X_L &&gaugeshow_x<=GAUGEBAR1_X_R) ? 8 :
             (gaugeshow_x>=GAUGEBAR2_X_L &&gaugeshow_x<=GAUGEBAR2_X_R) ? 10 :
             (gaugeshow_x>=GAUGEBAR3_X_L &&gaugeshow_x<=GAUGEBAR3_X_R) ? 12 :
             (gaugeshow_x>=GAUGEBAR4_X_L &&gaugeshow_x<=GAUGEBAR4_X_R) ? 14 : 6;
             
always @(posedge clk or posedge rst) begin
if(rst) begin  vy_in[0]<=0; vy_in[1]<=0; vy_in[2]<=0; vy_in[3]<=0; vy_in[4]<=0; vy_in[5]<=0; end
else if((powsel==1)&(b0_c == GPOWSEL)) vy_in[0]<=pow;
else if((powsel==1)&(b1_c == GPOWSEL)) vy_in[1]<=pow;
else if((powsel==1)&(b2_c == GPOWSEL)) vy_in[2]<=pow;
else if((powsel==1)&(b3_c == GPOWSEL)) vy_in[3]<=pow;
else if((powsel==1)&(b4_c == GPOWSEL)) vy_in[4]<=pow;
else if((powsel==1)&(b5_c == GPOWSEL)) vy_in[5]<=pow;
end          
             
assign gaugeshow_on = (x>=gaugeshow_x && x<=(gaugeshow_x+3) && y>=GAUGESHOW_Y_U && y<=GAUGESHOW_Y_D);

always @(posedge clk or posedge rst) begin
if(rst) powsel<=1;
else if(((b0_c == GPOWSEL)|(b1_c == GPOWSEL)|(b2_c == GPOWSEL)|(b3_c == GPOWSEL)|(b4_c == GPOWSEL)|(b5_c == GPOWSEL))&(key_pulse==5'h13)) powsel<=1;
else if((b0_n == GPOWSEL)|(b1_n == GPOWSEL)|(b2_n == GPOWSEL)|(b3_n == GPOWSEL)|(b4_n == GPOWSEL)|(b5_n == GPOWSEL)) powsel<=0;
end

always @(posedge clk or posedge rst) begin
if(rst) gaugereset<=1;
else if((b0_c == GSTART)|(b1_c == GSTART)|(b2_c == GSTART)|(b3_c == GSTART)|(b4_c == GSTART)|(b5_c == GSTART)) gaugereset<=1;
else gaugereset<=0;
end

always @(posedge clk or posedge rst) begin
if(rst) gaugeshow_x<=170;
else if(gaugereset==1) gaugeshow_x<=170;
else if((b0_c == GPOWSEL)|(b1_c == GPOWSEL)|(b2_c == GPOWSEL)|(b3_c == GPOWSEL)|(b4_c == GPOWSEL)|(b5_c == GPOWSEL)) begin 
    if((powsel==0)&(frame_tick)) begin
        if(gaugeshow_dir==1) gaugeshow_x <= gaugeshow_x+3; else if (gaugeshow_dir==2) gaugeshow_x <= gaugeshow_x-3; end
     else if (powsel==1) gaugeshow_x <= gaugeshow_x; end
end

assign reachwall1 = ((gaugeshow_x)<=WALL1_X_R)? 1:0;
assign reachwall2 = ((gaugeshow_x+3)>=WALL2_X_L)? 1:0;

always @(posedge clk, posedge rst) begin
if(rst) gaugeshow_dir <= 1;
else if (gaugereset==1) gaugeshow_dir <= 1; // move right when start
else if (reachwall1) gaugeshow_dir <= 1; // reach right? change direction
else if (reachwall2) gaugeshow_dir <= 2; // reach left? change direction
else gaugeshow_dir <= gaugeshow_dir; // or keep going
end


endmodule
