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
parameter RGB_GRAY =   {4'd7,   4'd7,  4'd7};

parameter RGB_REDBROWN = {4'd7,   4'd0,  4'd0};
parameter RGB_DARKBROWN = {4'd2,   4'd0,  4'd0};
parameter RGB_LIGHTBLUE = {4'd6,   4'd13,  4'd15};
parameter RGB_LIGHTGREEN = {4'd8,   4'd15,  4'd7};
parameter RGB_LIGHTYELLOW = {4'd15,   4'd15,  4'd8};
parameter RGB_LIGHTORANGE = {4'd14,   4'd9,  4'd4};
parameter RGB_LIGHTRED = {4'd15,   4'd7,  4'd7};
parameter RGB_PURPLE =   {4'd9,   4'd0,  4'd9};
parameter RGB_OCHER =   {4'd13,   4'd10,  4'd2};


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

//wall0�� x ��ǥ
parameter WALL0_X_L = 166; 
parameter WALL0_X_R = 473;
parameter WALL0_Y_U = 0; 
parameter WALL0_Y_D = 5; // hdmi cut issue -> change from 1 to 5

//wall1 �� ��ǥ ����
parameter WALL1_X_L = 166; 
parameter WALL1_X_R = 169;
parameter WALL1_Y_U = 0; 
parameter WALL1_Y_D = 479;

//wall2 �� ��ǥ ����
parameter WALL2_X_L = 470; 
parameter WALL2_X_R = 473;
parameter WALL2_Y_U = 0; 
parameter WALL2_Y_D = 479;

/*--------- target define -----------
----------- target define -----------
----------- target define ---------*/

//target �� ��ǥ ����
parameter TARGET_X_C = 318; 
parameter TARGET_Y_C = 100;
parameter TARGET_R = 90;

parameter TARGET0_COLOR = {RGB_SKY};
parameter TARGET1_COLOR = {RGB_WHITE};
parameter TARGET2_COLOR = {RGB_JAHONG};
parameter TARGET3_COLOR = {RGB_WHITE};

//stone
parameter STONE_R = 15;

/*--------- direction move bar define -----------
----------- direction move bar define -----------
----------- direction move bar define ---------*/

//move bar �� ��ǥ ����
parameter MVBAR_X_L = 170; 
parameter MVBAR_X_R = 469;
parameter MVBAR_Y_U = 448; 
parameter MVBAR_Y_D = 449;

/*--------- power gauge bar define -----------
----------- power gauge bar define -----------
----------- power gauge bar define ---------*/

//gaugebarguide �� ��ǥ����
parameter GAUGEGUIDE_X_L = 170; 
parameter GAUGEGUIDE_X_R = 469;
parameter GAUGEGUIDE_Y_U = 470; 
parameter GAUGEGUIDE_Y_D = 471;
//gauge bar move �� ��ǥ����
parameter GAUGESHOW_X_L = 170; 
parameter GAUGESHOW_X_R = 173;
parameter GAUGESHOW_Y_U = 472; 
parameter GAUGESHOW_Y_D = 476; // // hdmi cut issue -> change from 9 to 6
//gauge bar 0 �� ��ǥ����
parameter GAUGEBAR0_X_L = 170; 
parameter GAUGEBAR0_X_R = 269;
parameter GAUGEBAR0_Y_U = 472; 
parameter GAUGEBAR0_Y_D = 479;
//gauge bar 1 �� ��ǥ����
parameter GAUGEBAR1_X_L = 270; 
parameter GAUGEBAR1_X_R = 349;
parameter GAUGEBAR1_Y_U = 472; 
parameter GAUGEBAR1_Y_D = 479;
//gauge bar 2 �� ��ǥ����
parameter GAUGEBAR2_X_L = 350; 
parameter GAUGEBAR2_X_R = 409;
parameter GAUGEBAR2_Y_U = 472; 
parameter GAUGEBAR2_Y_D = 479;
//gauge bar 3 �� ��ǥ����
parameter GAUGEBAR3_X_L = 410; 
parameter GAUGEBAR3_X_R = 449;
parameter GAUGEBAR3_Y_U = 472; 
parameter GAUGEBAR3_Y_D = 479;
//gauge bar 4 �� ��ǥ����
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


wire frame_tick; 

wire [2:0] wall_on;
wire [3:0] target_on;
wire [4:0] gaugebar_on;
wire gaugeshow_on, gaugeguide_on, mvbar_on,endbox,endbox_red, endbox_blue, red_winbox, blue_winbox, select_box_keep, select_box_reset;



wire reach_top, reach_bottom, reach_wall, reach_bar, miss_stone;
reg game_stop, game_over;  

//refrernce tick 
assign frame_tick = (y==MAX_Y-1 && x==MAX_X-1)? 1 : 0; // �� �����Ӹ��� �� clk ���ȸ� 1�� ��. 

// wall
assign wall_on[0] = (x>=WALL0_X_L && x<=WALL0_X_R && y>=WALL0_Y_U && y<=WALL0_Y_D)? 1 : 0; //wall�� �ִ� ����
assign wall_on[1] = (x>=WALL1_X_L && x<=WALL1_X_R && y>=WALL1_Y_U && y<=WALL1_Y_D)? 1 : 0; //wall�� �ִ� ����
assign wall_on[2] = (x>=WALL2_X_L && x<=WALL2_X_R && y>=WALL2_Y_U && y<=WALL2_Y_D)? 1 : 0; //wall�� �ִ� ����



//���� ū ���� ���� ��, ������ ŭ target
circle target3(.x(x), .y(y), .cir_x(TARGET_X_C), .cir_y(TARGET_Y_C), .cir_r(15), .cir_rgb(), .circle_on(target_on[3]));
circle target2(.x(x), .y(y), .cir_x(TARGET_X_C), .cir_y(TARGET_Y_C), .cir_r(30), .cir_rgb(), .circle_on(target_on[2]));
circle target1(.x(x), .y(y), .cir_x(TARGET_X_C), .cir_y(TARGET_Y_C), .cir_r(60), .cir_rgb(), .circle_on(target_on[1]));
circle target0(.x(x), .y(y), .cir_x(TARGET_X_C), .cir_y(TARGET_Y_C), .cir_r(90), .cir_rgb(), .circle_on(target_on[0]));

// wall
assign mvbar_on = (x>=MVBAR_X_L  && x<=MVBAR_X_R  && y>=MVBAR_Y_U  && y<=MVBAR_Y_D )? 1 : 0; //wall�� �ִ� ����

//gauge bar
//assign gaugeshow_on = (x>=GAUGESHOW_X_L && x<=GAUGESHOW_X_R && y>=GAUGESHOW_Y_U && y<=GAUGESHOW_Y_D)? 1 : 0; //gaugebar ǥ�ð� �ִ� ����
assign gaugebar_on[0] = (x>=GAUGEBAR0_X_L && x<=GAUGEBAR0_X_R && y>=GAUGEBAR0_Y_U && y<=GAUGEBAR0_Y_D)? 1 : 0; //gaugebar�� �ִ� ����
assign gaugebar_on[1] = (x>=GAUGEBAR1_X_L && x<=GAUGEBAR1_X_R && y>=GAUGEBAR1_Y_U && y<=GAUGEBAR1_Y_D)? 1 : 0; //gaugebar�� �ִ� ����
assign gaugebar_on[2] = (x>=GAUGEBAR2_X_L && x<=GAUGEBAR2_X_R && y>=GAUGEBAR2_Y_U && y<=GAUGEBAR2_Y_D)? 1 : 0; //gaugebar�� �ִ� ����
assign gaugebar_on[3] = (x>=GAUGEBAR3_X_L && x<=GAUGEBAR3_X_R && y>=GAUGEBAR3_Y_U && y<=GAUGEBAR3_Y_D)? 1 : 0; //gaugebar�� �ִ� ����
assign gaugebar_on[4] = (x>=GAUGEBAR4_X_L && x<=GAUGEBAR4_X_R && y>=GAUGEBAR4_Y_U && y<=GAUGEBAR4_Y_D)? 1 : 0; //gaugebar�� �ִ� ����
assign gaugeguide_on = (x>=GAUGEGUIDE_X_L && x<=GAUGEGUIDE_X_R && y>=GAUGEGUIDE_Y_U && y<=GAUGEGUIDE_Y_D)? 1 : 0; //gaugebar guide�� �ִ� ����


reg red_end_box, blue_end_box, draw_end_box;

assign endbox_red = (red_end_box ==1 && ((x>=131 && x<=508 && y>=170 && y<=360)||(x>=180 && x<=459 && y>=70 && y<=100)))? 1 : 0; //end box    ?
assign endbox_blue = (blue_end_box ==1 && ((x>=131 && x<=508 && y>=170 && y<=360)||(x>=180 && x<=459 && y>=70 && y<=100)))? 1 : 0; //end box    ?
assign endbox_draw = (draw_end_box ==1 && ((x>=131 && x<=508 && y>=170 && y<=360)||(x>=180 && x<=459 && y>=70 && y<=100)))? 1 : 0; //end box    ?


assign select_box_keep = (selkeep==1 && gamestate>SCORING2 && x>=141 && x<=271 && y>=255 && y<=340)? 1 : 0;
assign select_box_reset = (selrst==1 && gamestate>SCORING2 && x>=338 && x<=488 && y>=255 && y<=340)? 1 : 0;




/*---------------------------------------------------------*/
// scoring
/*---------------------------------------------------------*/
wire [3:0] score_redout, score_blueout;
wire scoring_ends;

reg [3:0] gamestate, gamenstate;
scoring scoring_inst(
    .clk(clk), .rst(rst),

    .target_x(TARGET_X_C), .target_y(TARGET_Y_C), .target_r(TARGET_R), 
    .stone_x_a1(stone_x[0]), .stone_y_a1(stone_y[0]),
    .stone_x_a2(stone_x[2]), .stone_y_a2(stone_y[2]),
    .stone_x_a3(stone_x[4]), .stone_y_a3(stone_y[4]),

    .stone_x_b1(stone_x[1]), .stone_y_b1(stone_y[1]),
    .stone_x_b2(stone_x[3]), .stone_y_b2(stone_y[3]),
    .stone_x_b3(stone_x[5]), .stone_y_b3(stone_y[5]),

    .stone_r(STONE_R),
    
    .gamestate_in(gamestate),

    .score_red(score_redout), .score_blue(score_blueout),
    .scoring_end(scoring_ends)
    );


reg [3:0] score_reds, score_blues;
wire [1:0] whowin;
wire resetdata;

always@(posedge clk, posedge rst) begin
    if(rst || resetdata ) begin
        score_reds <= 0;
        score_blues <= 0;
    end
    else if(scoring_ends) begin
        score_reds <= score_redout + score_reds;
        score_blues <= score_blueout + score_blues;
    end
end

assign whowin = (( score_reds > score_blues) && (gamestate==SCORING2)) ? 1: ((score_reds < score_blues)&& (gamestate==SCORING2))? 2: ((score_reds == score_blues)&& (gamestate==SCORING2))? 0 : 3;



/*---------------------------------------------------------*/
// text on screen 
/*---------------------------------------------------------*/
// score region
wire [6:0] char_addr;
reg [6:0] char_addr_l, char_addr_s, char_addr_r_s, char_addr_b_s, char_addr_keep, char_addr_reset, char_addr_ng, char_addr_rw, char_addr_bw, char_addr_dw ;
wire [2:0] bit_addr;
reg [2:0] bit_addr_l, bit_addr_s, bit_addr_r_s, bit_addr_b_s,bit_addr_d_s , bit_addr_keep, bit_addr_reset, bit_addr_ng, bit_addr_rw, bit_addr_bw, bit_addr_dw;
wire [3:0] row_addr, row_addr_l, row_addr_s, row_addr_r_s, row_addr_b_s, row_addr_d_s, row_addr_keep, row_addr_reset, row_addr_ng, row_addr_rw, row_addr_bw, row_addr_dw; 
wire red_on, blue_on, draw_on, red_score_on, blue_score_on, keep_on, reset_on, set_game_on, RED_WIN_ON, BLUE_WIN_ON, DRAW_FLAG_ON ;
reg game_set_over;



wire font_bit;
wire [7:0] font_word;
wire [10:0] rom_addr;

font_rom_vhd font_rom_inst (clk, rom_addr, font_word);

assign rom_addr = {char_addr, row_addr};
assign font_bit = font_word[~bit_addr]; 

assign char_addr = (red_on)? char_addr_l :(blue_on)? char_addr_s :(red_score_on)? char_addr_r_s :(blue_score_on)? char_addr_b_s :(keep_on)? char_addr_keep : (reset_on)? char_addr_reset : (set_game_on)? char_addr_ng : (RED_WIN_ON)? char_addr_rw :(BLUE_WIN_ON)? char_addr_bw :(DRAW_FLAG_ON)? char_addr_dw : 0;  // score    ? 
assign row_addr =  (red_on)? row_addr_l : (blue_on)? row_addr_s :(red_score_on)? row_addr_r_s :(blue_score_on)? row_addr_b_s : (keep_on)? row_addr_keep : (reset_on)? row_addr_reset : (set_game_on)? row_addr_ng : (RED_WIN_ON)? row_addr_rw : (BLUE_WIN_ON)? row_addr_bw : (DRAW_FLAG_ON)? row_addr_dw : 0; 
assign bit_addr =  (red_on)? bit_addr_l : (blue_on)? bit_addr_s :(red_score_on)? bit_addr_r_s :(blue_score_on)? bit_addr_b_s :(keep_on)? bit_addr_keep : (reset_on)? bit_addr_reset : (set_game_on)? bit_addr_ng : (RED_WIN_ON)? bit_addr_rw : (BLUE_WIN_ON)? bit_addr_bw : (DRAW_FLAG_ON)? bit_addr_dw : 0;  


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


// TEAM RED SCORE
wire [9:0] red_score_x_l, red_score_y_t; 
assign red_score_x_l = 70; 
assign red_score_y_t = 110; 
assign red_score_on = (y>=red_score_y_t && y<red_score_y_t+32 && x>=red_score_x_l && x<red_score_x_l+16*3)? 1 : 0;
assign row_addr_r_s = (y-red_score_y_t) >> 1;
always @(*) begin
    if(rst) begin char_addr_r_s = 0; end
    else if (x>=red_score_x_l+16*0 && x<red_score_x_l+16*1) begin bit_addr_r_s = (x-red_score_x_l-16*0) >> 1; char_addr_r_s = {3'b011, score_reds}; end //       ?               
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
    if(rst) begin char_addr_b_s = 0; end
    if (x>=blue_score_x_l+16*0 && x<blue_score_x_l+16*1) begin bit_addr_b_s = (x-blue_score_x_l-16*0) >> 1; char_addr_b_s = {3'b011, score_blues}; end //       ?               
    else begin bit_addr_b_s = 0; char_addr_b_s = 0; end   
end
// keep_score
reg [9:0] keep_x_l, keep_y_t;
// assign keep_x_l = 150; 
// assign keep_y_t = 300; 
assign keep_on = (gamestate>SCORING2 && y>=keep_y_t && y<keep_y_t+32 && x>=keep_x_l && x<keep_x_l+16*7)? 1 : 0; 
assign row_addr_keep = (y-keep_y_t) >> 1;
always @ (*) begin
    if (x>=keep_x_l+16*0 && x<keep_x_l+16*1) begin bit_addr_keep = (x-keep_x_l-16*0) >> 1; char_addr_keep = 7'b1001011; end      // K x4b
    else if (x>=keep_x_l+16*1 && x<keep_x_l+16*2) begin bit_addr_keep = (x-keep_x_l-16*1) >> 1; char_addr_keep = 7'b1100101; end // e x65 
    else if (x>=keep_x_l+16*2 && x<keep_x_l+16*3) begin bit_addr_keep = (x-keep_x_l-16*2) >> 1; char_addr_keep = 7'b1100101; end // e x65
    else if (x>=keep_x_l+16*3 && x<keep_x_l+16*4) begin bit_addr_keep = (x-keep_x_l-16*3) >> 1; char_addr_keep = 7'b1110000; end // p x70
    else if (x>=keep_x_l+16*4 && x<keep_x_l+16*5) begin bit_addr_keep = (x-keep_x_l-16*4) >> 1; char_addr_keep = 7'b0000000; end // 
    else if (x>=keep_x_l+16*5 && x<keep_x_l+16*6) begin bit_addr_keep = (x-keep_x_l-16*5) >> 1; char_addr_keep = 7'b1001111; end // O x4f
    else if (x>=keep_x_l+16*6 && x<keep_x_l+16*7) begin bit_addr_keep = (x-keep_x_l-16*6) >> 1; char_addr_keep = 7'b1101110; end // n x6e
    else begin bit_addr_keep = 0; char_addr_keep = 0; end                         
end

reg move_reset, move_keep;

always @(posedge clk, posedge rst) begin
    if(rst || move_keep) begin
        keep_x_l <= 150;
        keep_y_t <= 300; end
    else if(keep_y_t >= 360 && frame_tick==1 && move_keep==0) begin
        keep_y_t <= 510; end
    else if(frame_tick==1 && move_keep==0) begin
        keep_y_t <= keep_y_t + 2;
    end
end

       

// reset_score
reg [9:0] reset_x_l, reset_y_t; 
//assign reset_x_l = 350; 
//assign reset_y_t = 300; 
assign reset_on = (gamestate>SCORING2 && y>=reset_y_t && y<reset_y_t+32 && x>=reset_x_l && x<reset_x_l+16*8)? 1 : 0;
assign row_addr_reset = (y-reset_y_t) >> 1;
always @(*) begin
    if (x>=reset_x_l+16*0 && x<reset_x_l+16*1) begin bit_addr_reset = (x-reset_x_l-16*0)>>1; char_addr_reset = 7'b1010010; end      // R x52
    else if (x>=reset_x_l+16*1 && x<reset_x_l+16*2) begin bit_addr_reset = (x-reset_x_l-16*1)>>1; char_addr_reset = 7'b1100101; end // e x65
    else if (x>=reset_x_l+16*2 && x<reset_x_l+16*3) begin bit_addr_reset = (x-reset_x_l-16*2)>>1; char_addr_reset = 7'b1110011; end // s x73
    else if (x>=reset_x_l+16*3 && x<reset_x_l+16*4) begin bit_addr_reset = (x-reset_x_l-16*3)>>1; char_addr_reset = 7'b1100101; end // e x65
    else if (x>=reset_x_l+16*4 && x<reset_x_l+16*5) begin bit_addr_reset = (x-reset_x_l-16*4)>>1; char_addr_reset = 7'b1110100; end // t x74
    else if (x>=reset_x_l+16*5 && x<reset_x_l+16*6) begin bit_addr_reset = (x-reset_x_l-16*5)>>1; char_addr_reset = 7'b0000000; end //
    else if (x>=reset_x_l+16*6 && x<reset_x_l+16*7) begin bit_addr_reset = (x-reset_x_l-16*6)>>1; char_addr_reset = 7'b1001111; end // O x4f
    else if (x>=reset_x_l+16*7 && x<reset_x_l+16*8) begin bit_addr_reset = (x-reset_x_l-16*7)>>1; char_addr_reset = 7'b1101110; end // n x6e 
    else begin bit_addr_reset = 0; char_addr_reset = 0; end   
end

always @(posedge clk, posedge rst) begin
    if(rst || move_reset) begin
        reset_x_l <= 350;
        reset_y_t <= 300; end
    else if(reset_y_t >= 360 && frame_tick==1 && move_reset==0) reset_y_t <= 510; 
    else if(frame_tick==1 && move_reset==0) reset_y_t <= reset_y_t + 2;
end



// game set select
assign set_game_on = (gamestate>SCORING2 && y[9:6]==3 && x[9:5]>=5 && x[9:5]<=14)? 1 : 0; // ���⿡ select_game ��ȣ �߰��ؼ� 1�̸� set_game_on 
assign row_addr_ng = y[5:2];
always @(*) begin

    bit_addr_ng = x[4:2];

    case (x[9:5]) 
        5: char_addr_ng = 7'b1001110;  // N x 4e
        6: char_addr_ng = 7'b1000101;  // E x 45
        7: char_addr_ng = 7'b1011000;  // X x 58
        8: char_addr_ng = 7'b1010100;  // T x 54
        9: char_addr_ng = 7'b0000000;  //   x 00                
        10: char_addr_ng = 7'b1000111; // G x 47
        11: char_addr_ng = 7'b1000001; // A x 41
        12: char_addr_ng = 7'b1001101; // M x 4d
        13: char_addr_ng = 7'b1000101; // E x 45
        14: char_addr_ng = 7'b0111111; // ? x 3f
        default: char_addr_ng = 0; 
    endcase
end

reg red_win, blue_win, draw_flag, selkeep, selrst;

// RED_win
wire [9:0] rw_x_l, rw_y_t;
assign rw_x_l = 260; 
assign rw_y_t = 70; 
//assign RED_WIN_ON = (red_win==1 && y > rw_y_t && y<rw_y_t+32 && x>=rw_x_l && x<rw_x_l+16*7)? 1 : 0; 
assign RED_WIN_ON = (red_win==1 &&  y > rw_y_t && y<rw_y_t+32 && x>=rw_x_l && x<rw_x_l+16*7)? 1 : 0; 
assign row_addr_rw = (y-rw_y_t) >> 1;
always @ (*) begin
    if (x>=rw_x_l+16*0 && x<rw_x_l+16*1) begin bit_addr_rw = (x-rw_x_l-16*0) >> 1; char_addr_rw = 7'b1010010; end      // R x52
    else if (x>=rw_x_l+16*1 && x<rw_x_l+16*2) begin bit_addr_rw = (x-rw_x_l-16*1) >> 1; char_addr_rw = 7'b1000101; end // E x45
    else if (x>=rw_x_l+16*2 && x<rw_x_l+16*3) begin bit_addr_rw = (x-rw_x_l-16*2) >> 1; char_addr_rw = 7'b1000100; end // D x44
    else if (x>=rw_x_l+16*3 && x<rw_x_l+16*4) begin bit_addr_rw = (x-rw_x_l-16*3) >> 1; char_addr_rw = 7'b0000000; end //   x00
    else if (x>=rw_x_l+16*4 && x<rw_x_l+16*5) begin bit_addr_rw = (x-rw_x_l-16*4) >> 1; char_addr_rw = 7'b1010111; end // W x57
    else if (x>=rw_x_l+16*5 && x<rw_x_l+16*6) begin bit_addr_rw = (x-rw_x_l-16*5) >> 1; char_addr_rw = 7'b1001001; end // I x49
    else if (x>=rw_x_l+16*6 && x<rw_x_l+16*7) begin bit_addr_rw = (x-rw_x_l-16*6) >> 1; char_addr_rw = 7'b1001110; end // N x4e
    else begin bit_addr_rw = 0; char_addr_rw = 0; end                         
end

// BLUE_win
wire [9:0] bw_x_l, bw_y_t; 
assign bw_x_l = 255; 
assign bw_y_t = 70; 
assign BLUE_WIN_ON = (blue_win==1 && y>=bw_y_t && y<bw_y_t+32 && x>=bw_x_l && x<bw_x_l+16*8)? 1 : 0;
assign row_addr_bw = (y-bw_y_t) >> 1;
always @(*) begin
    if (x>=bw_x_l+16*0 && x<bw_x_l+16*1) begin bit_addr_bw = (x-bw_x_l-16*0)>>1; char_addr_bw = 7'b1000010; end      // B x42
    else if (x>=bw_x_l+16*1 && x<bw_x_l+16*2) begin bit_addr_bw = (x-bw_x_l-16*1)>>1; char_addr_bw = 7'b1001100; end // L
    else if (x>=bw_x_l+16*2 && x<bw_x_l+16*3) begin bit_addr_bw = (x-bw_x_l-16*2)>>1; char_addr_bw = 7'b1010101; end // U
    else if (x>=bw_x_l+16*3 && x<bw_x_l+16*4) begin bit_addr_bw = (x-bw_x_l-16*3)>>1; char_addr_bw = 7'b1000101; end // E
    else if (x>=bw_x_l+16*4 && x<bw_x_l+16*5) begin bit_addr_bw = (x-bw_x_l-16*4)>>1; char_addr_bw = 7'b0000000; end //   x00
    else if (x>=bw_x_l+16*5 && x<bw_x_l+16*6) begin bit_addr_bw = (x-bw_x_l-16*5)>>1; char_addr_bw = 7'b1010111; end // W x57
    else if (x>=bw_x_l+16*6 && x<bw_x_l+16*7) begin bit_addr_bw = (x-bw_x_l-16*6)>>1; char_addr_bw = 7'b1001001; end // I x49
    else if (x>=bw_x_l+16*7 && x<bw_x_l+16*8) begin bit_addr_bw = (x-bw_x_l-16*7)>>1; char_addr_bw = 7'b1001110; end // N x4e
    else begin bit_addr_bw = 0; char_addr_bw = 0; end   
end

// DRAW
wire [9:0] dw_x_l, dw_y_t; 
assign dw_x_l = 255; 
assign dw_y_t = 70; 
assign DRAW_FLAG_ON = (draw_flag==1 && y>=dw_y_t && y<dw_y_t+32 && x>=dw_x_l && x<dw_x_l+16*8)? 1 : 0;
assign row_addr_dw = (y-dw_y_t) >> 1;
always @(*) begin
    if (x>=dw_x_l+16*2 && x<dw_x_l+16*3) begin bit_addr_dw = (x-dw_x_l-16*2)>>1; char_addr_dw = 7'b1000100; end // D
    else if (x>=dw_x_l+16*3 && x<dw_x_l+16*4) begin bit_addr_dw = (x-dw_x_l-16*3)>>1; char_addr_dw = 7'b1010010; end // R
    else if (x>=dw_x_l+16*5 && x<dw_x_l+16*6) begin bit_addr_dw = (x-dw_x_l-16*4)>>1; char_addr_dw = 7'b1000001; end // A
    else if (x>=dw_x_l+16*6 && x<dw_x_l+16*7) begin bit_addr_dw = (x-dw_x_l-16*5)>>1; char_addr_dw = 7'b1010111; end // W
    else begin bit_addr_dw = 0; char_addr_dw = 0; end   
end



/*---------------------------------------------------------*/
// color setting
/*---------------------------------------------------------*/
assign rgb = (font_bit & red_on)?        RGB_RED : //RED text_RED
             (font_bit & blue_on)?       RGB_BLUE : //blue text_BLUE
             (font_bit & red_score_on)?  RGB_RED :  // RED SCORE
             (font_bit & blue_score_on)? RGB_BLUE :  // BLUE SCORE
             (font_bit & keep_on)? RGB_BLACK : //blue text
             (font_bit & reset_on)? RGB_BLACK : //blue text
             (font_bit & RED_WIN_ON) ? RGB_BLACK:
             (font_bit & BLUE_WIN_ON) ? RGB_BLACK:
             (font_bit & DRAW_FLAG_ON) ? RGB_BLACK:
             (font_bit & set_game_on)? RGB_BLACK : //blue text
             (select_box_keep)?  RGB_BLACK :
             (select_box_reset)? RGB_BLACK :
            
             (endbox_red)? RGB_ORANGE :
             (endbox_blue)? RGB_ORANGE :
             (endbox_draw)? RGB_ORANGE :  //endbox
            // (red_winbox)? RGB_RED ://red_winbox 
            // (blue_winbox) ? RGB_BLUE :// blue_winbox
           //  (draw_winbox)? RGB_PURPLE :


             (wall_on[0])?          RGB_REDBROWN : //brown wall
             (wall_on[1])?          RGB_REDBROWN : //brown wall
             (wall_on[2])?          RGB_REDBROWN : //brown wall
             
             (hand_on[0])?          RGB_REDBROWN :
             (hand_on[1])?          RGB_REDBROWN :
             (hand_on[2])?          RGB_REDBROWN :
             (hand_on[3])?          RGB_REDBROWN :
             (hand_on[4])?          RGB_REDBROWN :
             (hand_on[5])?          RGB_REDBROWN :

             (stone_on[0])?          RGB_RED : //stone 0 red             
             (stone_on[1])?          RGB_BLUE : //stone 1 blue
             (stone_on[2])?          RGB_RED : //stone 2 red
             (stone_on[3])?          RGB_BLUE : //stone 3 blue
             (stone_on[4])?          RGB_RED : //stone 4 red
             (stone_on[5])?          RGB_BLUE : //stone 5 blue

             (stone_edge[0])?          RGB_GRAY : //stone 0 red             
             (stone_edge[1])?          RGB_GRAY : //stone 1 blue
             (stone_edge[2])?          RGB_GRAY : //stone 2 red
             (stone_edge[3])?          RGB_GRAY : //stone 3 blue
             (stone_edge[4])?          RGB_GRAY : //stone 4 red
             (stone_edge[5])?          RGB_GRAY : //stone 5 blue
             
             (real_edge[0])?        RGB_BLACK:
             (real_edge[1])?        RGB_BLACK:
             (real_edge[2])?        RGB_BLACK:
             (real_edge[3])?        RGB_BLACK:
             (real_edge[4])?        RGB_BLACK:
             (real_edge[5])?        RGB_BLACK:


             (broom_on_center_design[0])?  RGB_BLACK:
             (broom_on_center_design[1])?  RGB_BLACK:
             (broom_on_center_design[2])?  RGB_BLACK:
             (broom_on_center_design[3])?  RGB_BLACK:
             (broom_on_center_design[4])?  RGB_BLACK:
             (broom_on_center_design[5])?  RGB_BLACK:

             (broom_on_up_design[0])?    RGB_BLACK:
             (broom_on_up_design[1])?    RGB_BLACK:
             (broom_on_up_design[2])?    RGB_BLACK:
             (broom_on_up_design[3])?    RGB_BLACK:
             (broom_on_up_design[4])?    RGB_BLACK:
             (broom_on_up_design[5])?    RGB_BLACK:


             (broom_on_center[0])?         RGB_OCHER: //���
             (broom_on_center[1])?         RGB_OCHER: //���
             (broom_on_center[2])?         RGB_OCHER: //���
             (broom_on_center[3])?         RGB_OCHER: //���
             (broom_on_center[4])?         RGB_OCHER: //���
             (broom_on_center[5])?         RGB_OCHER: //���
             
             (broom_on_up[0])?         RGB_OCHER: //���
             (broom_on_up[1])?         RGB_OCHER: //���
             (broom_on_up[2])?         RGB_OCHER: //���
             (broom_on_up[3])?         RGB_OCHER: //���
             (broom_on_up[4])?         RGB_OCHER: //���
             (broom_on_up[5])?         RGB_OCHER: //���
             
             (broom_on_left[0])?         RGB_OCHER: //���
             (broom_on_left[1])?         RGB_OCHER: //���
             (broom_on_left[2])?         RGB_OCHER: //���
             (broom_on_left[3])?         RGB_OCHER: //���
             (broom_on_left[4])?         RGB_OCHER: //���
             (broom_on_left[5])?         RGB_OCHER: //���
             
             (broom_on_right[0])?         RGB_OCHER: //���
             (broom_on_right[1])?         RGB_OCHER: //���
             (broom_on_right[2])?         RGB_OCHER: //���
             (broom_on_right[3])?         RGB_OCHER: //���
             (broom_on_right[4])?         RGB_OCHER: //���
             (broom_on_right[5])?         RGB_OCHER: //���
             
             
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
            // (circle_on)?           RGB_ORANGE : // circle_test
                                    RGB_WHITE ; //white background
                                    
                                    
                                    
wire [9:0] stone_x [5:0];
wire [9:0] stone_y [5:0];
reg [2:0] turn_st[5:0]; // 0:your turn, 1: ready, 2: wait 3: turn end, 4: dir select 5: wait for powsel, 6: wair for idle
wire stone_on[5:0];
wire [5:0] broom_on_center,broom_on_up,broom_on_left,broom_on_right,stone_edge,hand_on, broom_on_center_design, broom_on_up_design, real_edge;
//wire broom_ons;
reg [3:0] sx_in[5:0];
reg [3:0] sy_in[5:0];
wire [3:0] sx_out[5:0];
wire [3:0] sy_out[5:0];
wire [1:0] xdir_out[5:0];
wire [1:0] ydir_out[5:0];



// 2�� ī����(?) 
reg [31:0] stcnt;
wire stsig;
 


parameter GAMESTANBY=0, GAMEREADY=1, GAME0ST=2, GAME1ST=3, GAME2ST=4, GAME3ST=5, GAME4ST=6, GAME5ST=7, SCORINGSTART=8, SCORING=9,SCORING2=10, GAMEEND=11, WAIT=12, WAIT2=13;

always @ (posedge clk or posedge rst) begin
if(rst || (gamestate==WAIT) ) stcnt<=0;
else if(gamestate==WAIT2)
    if (stcnt==50346000-1) stcnt<=0;
    else stcnt<=stcnt+1;
end
assign stsig = (stcnt==50346000-1)?1'b1 : 1'b0;  // 2sec

//game auto state
reg gamereset;
wire no_rst;
reg [1:0] now_turn;

assign resetdata = (selrst==1)? 1: 0;
assign no_rst = (now_turn==2)? 1:0;
wire gamekeepsig;
assign gamekeepsig = ((key ==5'h1D) && (no_rst==0))? 1:0;  //(no_rst==0) && (key_pulse==5'h1D)

always @ (*) begin
case(gamestate)
    GAMESTANBY: begin red_end_box<=0; blue_end_box<=0; draw_end_box<=0; gamereset=0; move_reset<=1; move_keep<=1; game_set_over <= 0; red_win<=0; blue_win<=0; draw_flag<=0; b0_st<=0; b1_st<=0; b2_st<=0; b3_st<=0; b4_st<=0; b5_st<=0; gamenstate <=GAMEREADY;  end       
    GAMEREADY : if(key_pulse==5'h11) begin gamenstate<=GAME0ST; end else gamenstate <=GAMEREADY;
    GAME0ST : if(turn_st[0]==3) begin b0_st<=0; gamenstate<=GAME1ST; end else begin b0_st<=1; b1_st<=0; b2_st<=0; b3_st<=0; b4_st<=0; b5_st<=0; gamenstate<=GAME0ST; end
    GAME1ST : if(turn_st[1]==3) begin b1_st<=0; gamenstate<=GAME2ST; end else begin b1_st<=1; b0_st<=0; b2_st<=0; b3_st<=0; b4_st<=0; b5_st<=0; gamenstate<=GAME1ST; end
    GAME2ST : if(turn_st[2]==3) begin b2_st<=0; gamenstate<=GAME3ST; end else begin b2_st<=1; b0_st<=0; b1_st<=0; b3_st<=0; b4_st<=0; b5_st<=0; gamenstate<=GAME2ST; end
    GAME3ST : if(turn_st[3]==3) begin b3_st<=0; gamenstate<=GAME4ST; end else begin b3_st<=1; b0_st<=0; b1_st<=0; b2_st<=0; b4_st<=0; b5_st<=0; gamenstate<=GAME3ST; end
    GAME4ST : if(turn_st[4]==3) begin b4_st<=0; gamenstate<=GAME5ST; end else begin b4_st<=1; b0_st<=0; b1_st<=0; b2_st<=0; b3_st<=0; b5_st<=0; gamenstate<=GAME4ST; end
    GAME5ST : if(turn_st[5]==3) begin b5_st<=0; gamenstate<=SCORINGSTART; end else begin b5_st<=1; b0_st<=0; b1_st<=0; b2_st<=0; b3_st<=0; b4_st<=0; gamenstate<=GAME5ST; end
    SCORINGSTART : gamenstate <=SCORING;
    SCORING :  if(scoring_ends==1) begin game_set_over <= 1; gamenstate<=SCORING2;end
               else gamenstate<=SCORING;
    SCORING2: if(whowin==1) begin red_win<= 1; blue_win <= 0; draw_flag <=0;  red_end_box<=1;gamenstate=GAMEEND; end
              else if(whowin==2) begin red_win<= 0; blue_win <= 1; draw_flag <=0; blue_end_box<=1;gamenstate=GAMEEND; end
              else if(whowin==0) begin red_win<= 0; blue_win <= 0; draw_flag <=1; draw_end_box<=1; gamenstate=GAMEEND; end
              else gamenstate<=SCORING2;                                   
    GAMEEND: begin move_keep<=1; move_reset<=1; gamenstate<=WAIT; end
    WAIT : if(key_pulse==5'h1F) begin selrst<=1; now_turn<=0;  move_keep<=0; move_reset<=1; gamereset<=1; gamenstate<= WAIT2; end
           else if(gamekeepsig==1) begin selkeep<=1; now_turn<=now_turn+1; move_keep<=1; move_reset<=0;gamereset<=1; gamenstate<=WAIT2; end
           else begin move_keep<=1; move_reset<=1; gamenstate <= WAIT; end
    WAIT2 : if(stsig)begin selkeep<=0; selrst<=0; game_set_over<=0; gamereset<=1; gamenstate=GAMESTANBY; end else begin gamereset<=1; gamenstate<=WAIT2; end     
    default : gamenstate <=GAMESTANBY;
    endcase
end



    

 always @(posedge clk or posedge rst) begin
 if(rst) gamestate <= GAMESTANBY;
 else gamestate <= gamenstate;
 end   


reg [2:0] b0_c, b0_n, b1_c, b1_n, b2_c, b2_n, b3_c, b3_n, b4_c, b4_n, b5_c, b5_n;
parameter GSTANBY=3'd0, GSTART=3'd1, GDIRSEL=3'd2, GPOWSEL=3'd3,  GMOVE=3'd4, GEND=3'd5;
reg b0_st, b0_dir, b0_stop, b1_st, b1_dir, b1_stop, b2_st, b2_dir, b2_stop, b3_st, b3_dir, b3_stop, b4_st, b4_dir, b4_stop, b5_st, b5_dir, b5_stop;
wire [5:0] fin;


always @(*) begin   //for test, b(n)_stop replaced to key_pulse==5'h19
if(rst) turn_st[0]<=2;
else
case(b0_c)
    GSTANBY : if(b0_st==1) b0_n <= GSTART; else begin turn_st[0]<=2; b0_n <= GSTANBY; end
    GSTART  : begin if(turn_st[0]==1) b0_n <= GDIRSEL; else turn_st[0]<=1;  end
    GDIRSEL : if(key_pulse==5'h12) begin turn_st[0]<=5; b0_n <= GPOWSEL; end else begin turn_st[0]<=4; b0_n <= GDIRSEL; end
    GPOWSEL : if(powsel==1) b0_n <= GMOVE; else begin b0_n <= GPOWSEL; turn_st[0]<=5;end
    GMOVE   : if(fin[0]) begin turn_st[0]<=6; b0_n <= GEND; end else begin turn_st[0]<=0; b0_n <= GMOVE; end
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
    GPOWSEL : if(powsel==1) b1_n <= GMOVE; else begin b1_n <= GPOWSEL; turn_st[1]<=5;end
    GMOVE   : if(fin[1]) begin turn_st[1]<=6; b1_n <= GEND; end else begin turn_st[1]<=0; b1_n <= GMOVE; end
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
    GPOWSEL : if(powsel==1) b2_n <= GMOVE; else begin b2_n <= GPOWSEL; turn_st[2]<=5;end
    GMOVE   : if(fin[2]) begin turn_st[2]<=6; b2_n <= GEND; end else begin turn_st[2]<=0; b2_n <= GMOVE; end
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
    GPOWSEL : if(powsel==1) b3_n <= GMOVE; else begin b3_n <= GPOWSEL; turn_st[3]<=5; end
    GMOVE   : if(fin[3]) begin turn_st[3]<=6; b3_n <= GEND; end else begin turn_st[3]<=0; b3_n <= GMOVE; end
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
    GPOWSEL : if(powsel==1) b4_n <= GMOVE; else begin b4_n <= GPOWSEL; turn_st[4]<=5; end
    GMOVE   : if(fin[4]) begin turn_st[4]<=6; b4_n <= GEND; end else begin turn_st[4]<=0; b4_n <= GMOVE; end
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
    GPOWSEL : if(powsel==1) b5_n <= GMOVE; else begin b5_n <= GPOWSEL; turn_st[5]<=5; end
    GMOVE   : if(fin[5]) begin turn_st[5]<=6; b5_n <= GEND; end else begin turn_st[5]<=0; b5_n <= GMOVE; end
    GEND    : if(gamereset==1)b5_n <= GSTANBY; else begin turn_st[5]<=3; b5_n <= GEND; end
    default : begin turn_st[5]<=2; b5_n <= GSTANBY; end
    endcase
    end

    
 always @(posedge clk or posedge rst) begin
 if(rst) begin b0_c <= GSTANBY; b1_c <= GSTANBY; b2_c <= GSTANBY; b3_c <= GSTANBY; b4_c <= GSTANBY; b5_c <= GSTANBY; end
 else begin b0_c <= b0_n; b1_c <= b1_n; b2_c <= b2_n; b3_c <= b3_n; b4_c <= b4_n; b5_c <= b5_n; end
 end   
 
stone #(.RD_X(85), .RD_Y(200)) stone0(clk, rst, frame_tick, x, y, stone_x[0], stone_y[0],
key, key_pulse, turn_st[0], stone_on[0], stone_edge[0], hand_on[0], real_edge[0],
sx_in[0], sy_in[0],sx_out[0],sy_out[0],xdir_out[0],ydir_out[0],
stone_x[1], stone_y[1],sx_out[1],sy_out[1],xdir_out[1],ydir_out[1],
stone_x[2], stone_y[2],sx_out[2],sy_out[2],xdir_out[2],ydir_out[2],
stone_x[3], stone_y[3],sx_out[3],sy_out[3],xdir_out[3],ydir_out[3],
stone_x[4], stone_y[4],sx_out[4],sy_out[4],xdir_out[4],ydir_out[4],
stone_x[5], stone_y[5],sx_out[5],sy_out[5],xdir_out[5],ydir_out[5],
broom_on_center[0],broom_on_up[0],broom_on_left[0],broom_on_right[0],broom_on_center_design[0], broom_on_up_design[0],fin[0]);

stone #(.RD_X(555), .RD_Y(200)) stone1(clk, rst,frame_tick,x, y, stone_x[1], stone_y[1],
key, key_pulse, turn_st[1], stone_on[1], stone_edge[1], hand_on[1], real_edge[1],
sx_in[1], sy_in[1],sx_out[1],sy_out[1],xdir_out[1],ydir_out[1],
stone_x[0], stone_y[0],sx_out[0],sy_out[0],xdir_out[0],ydir_out[0],
stone_x[2], stone_y[2],sx_out[2],sy_out[2],xdir_out[2],ydir_out[2],
stone_x[3], stone_y[3],sx_out[3],sy_out[3],xdir_out[3],ydir_out[3],
stone_x[4], stone_y[4],sx_out[4],sy_out[4],xdir_out[4],ydir_out[4],
stone_x[5], stone_y[5],sx_out[5],sy_out[5],xdir_out[5],ydir_out[5],
broom_on_center[1],broom_on_up[1],broom_on_left[1],broom_on_right[1],broom_on_center_design[1], broom_on_up_design[1],fin[1]);

stone #(.RD_X(85), .RD_Y(250)) stone2(clk, rst,frame_tick,x, y, stone_x[2], stone_y[2],
key, key_pulse, turn_st[2], stone_on[2],stone_edge[2], hand_on[2], real_edge[2],
sx_in[2], sy_in[2],sx_out[2],sy_out[2],xdir_out[2],ydir_out[2],
stone_x[0], stone_y[0],sx_out[0],sy_out[0],xdir_out[0],ydir_out[0],
stone_x[1], stone_y[1],sx_out[1],sy_out[1],xdir_out[1],ydir_out[1],
stone_x[3], stone_y[3],sx_out[3],sy_out[3],xdir_out[3],ydir_out[3],
stone_x[4], stone_y[4],sx_out[4],sy_out[4],xdir_out[4],ydir_out[4],
stone_x[5], stone_y[5],sx_out[5],sy_out[5],xdir_out[5],ydir_out[5],
broom_on_center[2],broom_on_up[2],broom_on_left[2],broom_on_right[2],broom_on_center_design[2], broom_on_up_design[2],fin[2]);

stone #(.RD_X(555), .RD_Y(250)) stone3(clk, rst,frame_tick,x, y, stone_x[3], stone_y[3],
key, key_pulse, turn_st[3], stone_on[3],stone_edge[3], hand_on[3], real_edge[3],
sx_in[3], sy_in[3],sx_out[3],sy_out[3],xdir_out[3],ydir_out[3],
stone_x[0], stone_y[0],sx_out[0],sy_out[0],xdir_out[0],ydir_out[0],
stone_x[1], stone_y[1],sx_out[1],sy_out[1],xdir_out[1],ydir_out[1],
stone_x[2], stone_y[2],sx_out[2],sy_out[2],xdir_out[2],ydir_out[2],
stone_x[4], stone_y[4],sx_out[4],sy_out[4],xdir_out[4],ydir_out[4],
stone_x[5], stone_y[5],sx_out[5],sy_out[5],xdir_out[5],ydir_out[5],
broom_on_center[3],broom_on_up[3],broom_on_left[3],broom_on_right[3],broom_on_center_design[3], broom_on_up_design[3],fin[3]);

stone #(.RD_X(85), .RD_Y(300)) stone4(clk, rst,frame_tick,x, y, stone_x[4], stone_y[4],
key, key_pulse, turn_st[4], stone_on[4],stone_edge[4], hand_on[4], real_edge[4],
sx_in[4], sy_in[4],sx_out[4],sy_out[4],xdir_out[4],ydir_out[4],
stone_x[0], stone_y[0],sx_out[0],sy_out[0],xdir_out[0],ydir_out[0],
stone_x[1], stone_y[1],sx_out[1],sy_out[1],xdir_out[1],ydir_out[1],
stone_x[2], stone_y[2],sx_out[2],sy_out[2],xdir_out[2],ydir_out[2],
stone_x[3], stone_y[3],sx_out[3],sy_out[3],xdir_out[3],ydir_out[3],
stone_x[5], stone_y[5],sx_out[5],sy_out[5],xdir_out[5],ydir_out[5],
broom_on_center[4],broom_on_up[4],broom_on_left[4],broom_on_right[4],broom_on_center_design[4], broom_on_up_design[4],fin[4]);

stone #(.RD_X(555), .RD_Y(300)) stone5(clk, rst,frame_tick,x, y, stone_x[5], stone_y[5],
key, key_pulse, turn_st[5], stone_on[5],stone_edge[5], hand_on[5], real_edge[5],
sx_in[5], sy_in[5],sx_out[5],sy_out[5],xdir_out[5],ydir_out[5],
stone_x[0], stone_y[0],sx_out[0],sy_out[0],xdir_out[0],ydir_out[0],
stone_x[1], stone_y[1],sx_out[1],sy_out[1],xdir_out[1],ydir_out[1],
stone_x[2], stone_y[2],sx_out[2],sy_out[2],xdir_out[2],ydir_out[2],
stone_x[3], stone_y[3],sx_out[3],sy_out[3],xdir_out[3],ydir_out[3],
stone_x[4], stone_y[4],sx_out[4],sy_out[4],xdir_out[4],ydir_out[4],
broom_on_center[5],broom_on_up[5],broom_on_left[5],broom_on_right[5],broom_on_center_design[5], broom_on_up_design[5],fin[5]);
 

//gauge moving functions

reg [9:0] gaugeshow_x; // for power gauge bar moving
reg [1:0] gaugeshow_dir;
reg powsel,gaugereset; // for checking power select is finished
wire [3:0] pow;
wire reachwall1, reachwall2;

assign pow = (gaugeshow_x>=GAUGEBAR0_X_L &&gaugeshow_x<=GAUGEBAR0_X_R) ? 2 :  // �� �� ��ư� �� �κ� �Ķ���� ��� ��ǥ �Ǻ��� �� 10�� �̻����� �ɰ��� ��������? 
             (gaugeshow_x>=GAUGEBAR1_X_L &&gaugeshow_x<=GAUGEBAR1_X_R) ? 3 :
             (gaugeshow_x>=GAUGEBAR2_X_L &&gaugeshow_x<=GAUGEBAR2_X_R) ? 4 :
             (gaugeshow_x>=GAUGEBAR3_X_L &&gaugeshow_x<=GAUGEBAR3_X_R) ? 5 :
             (gaugeshow_x>=GAUGEBAR4_X_L &&gaugeshow_x<=GAUGEBAR4_X_R) ? 6 : 4;
             
always @(posedge clk or posedge rst) begin
if(rst) begin  sy_in[0]<=0; sy_in[1]<=0; sy_in[2]<=0; sy_in[3]<=0; sy_in[4]<=0; sy_in[5]<=0; end
else if((powsel==1)&(b0_c == GPOWSEL)) sy_in[0]<=pow;
else if((powsel==1)&(b1_c == GPOWSEL)) sy_in[1]<=pow;
else if((powsel==1)&(b2_c == GPOWSEL)) sy_in[2]<=pow;
else if((powsel==1)&(b3_c == GPOWSEL)) sy_in[3]<=pow;
else if((powsel==1)&(b4_c == GPOWSEL)) sy_in[4]<=pow;
else if((powsel==1)&(b5_c == GPOWSEL)) sy_in[5]<=pow;
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
