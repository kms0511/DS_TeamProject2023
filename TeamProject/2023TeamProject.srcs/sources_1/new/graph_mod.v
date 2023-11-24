`timescale 1ns / 1ps

module graph_mod (clk, rst, x, y, key, key_pulse, rgb);

// 화면 크기 설정
parameter MAX_X = 640; 
parameter MAX_Y = 480;  

//wall 의 좌표 설정
parameter WALL_X_L = 32; 
parameter WALL_X_R = 35;

//bar의 x 좌표
parameter BAR_X_L = 600; 
parameter BAR_X_R = 603;

//bar 속도, bar size
parameter BAR_Y_SIZE = 72; 
parameter BAR_V = 4; 

//ball 속도, ball size 
parameter BALL_SIZE = 8; 
parameter BALL_V = 4; //ball의 속도

input clk, rst;
input [9:0] x, y;
input [4:0] key, key_pulse; 
output [11:0] rgb; 

wire frame_tick; 

wire wall_on, bar_on, ball_on; 
wire [9:0] bar_y_t, bar_y_b; 
reg [9:0] current_bar_y, next_bar_y; 

reg [9:0] current_ball_x, current_ball_y;
reg [9:0] next_ball_x, next_ball_y;

reg [9:0] current_ball_vx, current_ball_vy; 
reg [9:0] next_ball_vx, next_ball_vy;

wire [9:0] ball_x_l, ball_x_r, ball_y_t, ball_y_b;
wire reach_top, reach_bottom, reach_wall, reach_bar, miss_ball;
reg game_stop, game_over;  

//refrernce tick 
assign frame_tick = (y==MAX_Y-1 && x==MAX_X-1)? 1 : 0; // 매 프레임마다 한 clk 동안만 1이 됨. 

// wall
assign wall_on = (x>=WALL_X_L && x<=WALL_X_R)? 1 : 0; //wall이 있는 영역

/*---------------------------------------------------------*/
// circle test
/*---------------------------------------------------------*/
wire circle_on;
circle circle_test(.x(x), .y(y), .cir_x(200), .cir_y(200), .cir_r(10), .cir_rgb({4'd15,4'd15,4'd15}), .circle_on(circle_on));





/*---------------------------------------------------------*/
// bar의 위치 결정
/*---------------------------------------------------------*/
assign bar_y_t = current_bar_y; //bar의 top
assign bar_y_b = bar_y_t + BAR_Y_SIZE - 1; //bar의 bottom

assign bar_on = (x>=BAR_X_L && x<=BAR_X_R && y>=bar_y_t && y<=bar_y_b)? 1 : 0; //bar가 있는 영역

//always @* begin
//    if (game_stop) next_bar_y <= (MAX_Y-BAR_Y_SIZE)/2;
//    else if (key_pulse==5'h11 && bar_y_b<=MAX_Y-1-BAR_V) next_bar_y = current_bar_y + BAR_V;
//    else if (key_pulse==5'h14 && bar_y_t>=BAR_V) next_bar_y = current_bar_y - BAR_V;
//    else next_bar_y = current_bar_y; 
//end

always @* begin
    if (game_stop) next_bar_y <= (MAX_Y-BAR_Y_SIZE)/2;
    else if (frame_tick==1 && key==5'h11 && bar_y_b<=MAX_Y-1-BAR_V) next_bar_y = current_bar_y + BAR_V;
    else if (frame_tick==1 && key==5'h14 && bar_y_t>=BAR_V) next_bar_y = current_bar_y - BAR_V;
    else next_bar_y = current_bar_y; 
end

always @(posedge clk, posedge rst) begin
    if (rst) current_bar_y <= (MAX_Y-BAR_Y_SIZE)/2; 
    else current_bar_y <= next_bar_y; 
end
       
/*---------------------------------------------------------*/
// ball의 위치 결정
/*---------------------------------------------------------*/
assign ball_x_l = current_ball_x; //ball의 left
assign ball_x_r = current_ball_x + BALL_SIZE - 1; //ball의 right
assign ball_y_t = current_ball_y; //ball의 top
assign ball_y_b = current_ball_y + BALL_SIZE - 1; //ball의 bottom

assign ball_on = (x>=ball_x_l && x<=ball_x_r && y>=ball_y_t && y<=ball_y_b)? 1 : 0; //ball이 있는 영역

assign reach_top = (ball_y_t==0)? 1 : 0; //ball 윗쪽 경계가 1보다 작으면 천장에 부딪힘
assign reach_bottom = (ball_y_b>MAX_Y-1)? 1 : 0; //ball의 아래쪽 경계가 479보다 크면 바닥에 부딪힘
assign reach_wall =(ball_x_l<=WALL_X_R)? 1 : 0; //ball의 왼쪽경계가 wall의 오른쪽 경계보다 작으면 wall에 부딪힘
assign reach_bar = (ball_x_r>=BAR_X_L && ball_x_r<=BAR_X_R && ball_y_b>=bar_y_t && ball_y_t<=bar_y_b)? 1 : 0; //ball이 bar에 부딪힘
assign miss_ball = (ball_x_r>MAX_X)? 1 : 0; //ball의 오른쪽 경계가 639보다 크면 ball을 놓침

always @* begin
    if (game_stop) next_ball_vx = -1*BALL_V; //시작할때는 왼쪽으로
    else if (reach_wall) next_ball_vx = BALL_V; //벽에 부딪히면 오른쪽으로
    else if (reach_bar) next_ball_vx = -1*BALL_V; //바에 튕기면 왼쪽으로
    else next_ball_vx = current_ball_vx; //아니면 가던 방향으로
end

always @* begin
    if (game_stop) next_ball_vy = BALL_V; //시작할때는 아래로
    else if (reach_top) next_ball_vy = BALL_V; //천장에 부딪히면 아래로.
    else if (reach_bottom) next_ball_vy = -1*BALL_V; //바닥에 부딪히면 위로
    else next_ball_vy = current_ball_vy; //아니면 가던 방향으로
end

always @(posedge clk, posedge rst) begin
    if (rst) begin
        current_ball_vx <= -1*BALL_V; 
        current_ball_vy <= BALL_V;
    end
    else begin
        current_ball_vx <= next_ball_vx; 
        current_ball_vy <= next_ball_vy;
    end
end


always @* begin
    if (game_stop) begin 
        next_ball_x = MAX_X/2;
        next_ball_y = MAX_Y/2; 
    end
    else if (frame_tick) begin
        next_ball_x = current_ball_x + current_ball_vx; //매 프레임마다 ball_vx_reg만큼 움직임
        next_ball_y = current_ball_y + current_ball_vy; //매 프레임마다 ball_vy_reg만큼 움직임
    end
    else begin
        next_ball_x = current_ball_x; //frame_tick이 아닐때는 안 움직임. 
        next_ball_y = current_ball_y; //frame_tick이 아닐때는 안 움직임. 
    end
end

always @(posedge clk, posedge rst) begin
    if (rst) begin
        current_ball_x <= MAX_X/2; 
        current_ball_y <= MAX_Y/2;
    end
    else begin
        current_ball_x <= next_ball_x; 
        current_ball_y <= next_ball_y;
    end
end

/*---------------------------------------------------------*/
// bar로 공을 받을 때 마다 score를 1씩 증가시키는 로직 
/*---------------------------------------------------------*/
reg d_inc, d_clr;
wire hit, miss;
reg [3:0] dig0, dig1;

assign hit = (reach_bar==1 && frame_tick==1)? 1 : 0; //ball이 bar를 때림, hit를 1클럭 pulse로 만들기 위해 frame_tick과 AND 시킴
assign miss = (miss_ball==1 && frame_tick==1)? 1 : 0; //bar가 ball을 놓침, miss를 1클럭 pulse로 만들기 위해 frame_tick과 AND 시킴

always @ (posedge clk or posedge rst) begin
    if(rst | d_clr) begin
        dig1 <= 0;
        dig0 <= 0;
    end else if (hit) begin //bar를 맞추면 점수가 증가
        if(dig0==9) begin 
            dig0 <= 0;
            if (dig1==9) dig1 <= 0;
            else dig1 <= dig1+1; //점수 10의 자리 1씩 증가
        end else dig0 <= dig0+1; //점수 1의 자리 1씩 증가
    end
end

/*---------------------------------------------------------*/
// finite state machine for game control
/*---------------------------------------------------------*/
parameter NEWGAME=2'b00, PLAY=2'b01, NEWBALL=2'b10, OVER=2'b11; 
reg [1:0] state_reg, state_next;
reg [1:0] life_reg, life_next;

always @ (key, hit, miss, state_reg, life_reg) begin
    game_stop = 1; 
    d_clr = 0;
    d_inc = 0;
    life_next = life_reg;
    game_over = 0;

    case(state_reg) 
        NEWGAME: begin //새 게임
            d_clr = 1; //스코어 0으로 초기화
            if(key[4] == 1) begin //버튼이 눌리면
                state_next = PLAY; //게임시작
                life_next = 2'b10; //남은 생명 2개로
            end else begin
                state_next = NEWGAME; //버튼이 안 눌리면 현재 상태 유지
                life_next = 2'b11; //남은 생명 3개 유지
            end
         end
         PLAY: begin
            game_stop = 0; //게임 Running
            d_inc = hit;
            if (miss) begin //ball을 놓치면
                if (life_reg==2'b00) //남은 생명이 없으면
                    state_next = OVER; //게임종료
                else begin//남은 생명이 있으면 
                    state_next = NEWBALL; 
                    life_next = life_reg-1'b1; //남은 생명 하나 줄임
                end
            end else
                state_next = PLAY; //ball 놓치지 않으면 계속 진행
        end
        NEWBALL: //새 ball 준비
            if(key[4] == 1) state_next = PLAY;
            else state_next = NEWBALL; 
        OVER: begin
            if(key[4] == 1) begin //게임이 끝났을 때 버튼을 누르면 새게임 시작
                state_next = NEWGAME;
            end else begin
                state_next = OVER;
            end
            game_over = 1;
        end 
        default: 
            state_next = NEWGAME;
    endcase
end

always @ (posedge clk or posedge rst) begin
    if(rst) begin
        state_reg <= NEWGAME; 
        life_reg <= 0;
    end else begin
        state_reg <= state_next; 
        life_reg <= life_next;
    end
end

/*---------------------------------------------------------*/
// text on screen 
/*---------------------------------------------------------*/
// score region
wire [6:0] char_addr;
reg [6:0] char_addr_s, char_addr_l, char_addr_o;
wire [2:0] bit_addr;
reg [2:0] bit_addr_s, bit_addr_l, bit_addr_o;
wire [3:0] row_addr, row_addr_s, row_addr_l, row_addr_o; 
wire score_on, life_on, over_on;

wire font_bit;
wire [7:0] font_word;
wire [10:0] rom_addr;

font_rom_vhd font_rom_inst (clk, rom_addr, font_word);

assign rom_addr = {char_addr, row_addr};
assign font_bit = font_word[~bit_addr]; //화면 x좌표는 왼쪽이 작은데, rom의 bit는 오른쪽이 작으므로 reverse

assign char_addr = (score_on)? char_addr_s : (life_on)? char_addr_l : (over_on)? char_addr_o : 0;
assign row_addr = (score_on)? row_addr_s : (life_on)? row_addr_l : (over_on)? row_addr_o : 0; 
assign bit_addr = (score_on)? bit_addr_s : (life_on)? bit_addr_l : (over_on)? bit_addr_o : 0; 

// score
wire [9:0] score_x_l, score_y_t;
assign score_x_l = 100; 
assign score_y_t = 0; 
assign score_on = (y>=score_y_t && y<score_y_t+16 && x>=score_x_l && x<score_x_l+8*4)? 1 : 0; 
assign row_addr_s = y-score_y_t;
always @ (*) begin
    if (x>=score_x_l+8*0 && x<score_x_l+8*1) begin bit_addr_s = x-score_x_l-8*0; char_addr_s = 7'b1010011; end // S x53    
    else if (x>=score_x_l+8*1 && x<score_x_l+8*2) begin bit_addr_s = x-score_x_l-8*1; char_addr_s = 7'b0111010; end // : x3a
    else if (x>=score_x_l+8*2 && x<score_x_l+8*3) begin bit_addr_s = x-score_x_l-8*2; char_addr_s = {3'b011, dig1}; end // digit 10, ASCII 코드에서 숫자의 address는 011로 시작 
    else if (x>=score_x_l+8*3 && x<score_x_l+8*4) begin bit_addr_s = x-score_x_l-8*3; char_addr_s = {3'b011, dig0}; end // digit 1
    else begin bit_addr_s = 0; char_addr_s = 0; end                         
end

//remaining ball
wire [9:0] life_x_l, life_y_t; 
assign life_x_l = 200; 
assign life_y_t = 0; 
assign life_on = (y>=life_y_t && y<life_y_t+16 && x>=life_x_l && x<life_x_l+8*3)? 1 : 0;
assign row_addr_l = y-life_y_t;
always @(*) begin
    if (x>=life_x_l+8*0 && x<life_x_l+8*1) begin bit_addr_l = (x-life_x_l-8*0); char_addr_l = 7'b1000010; end // B x42  
    else if (x>=life_x_l+8*1 && x<life_x_l+8*2) begin bit_addr_l = (x-life_x_l-8*1); char_addr_l = 7'b0111010; end // :
    else if (x>=life_x_l+8*2 && x<life_x_l+8*3) begin bit_addr_l = (x-life_x_l-8*2); char_addr_l = {5'b01100, life_reg}; end
    else begin bit_addr_l = 0; char_addr_l = 0; end   
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
assign rgb = (font_bit & score_on)? {4'd0,  4'd0,   4'd15} : //blue text
             (font_bit & life_on)?  {4'd0,  4'd0,   4'd15} : //blue text
             (font_bit & over_on)?  {4'd0,  4'd0,   4'd15} : //blue text
             (wall_on)?             {4'd0,  4'd0,   4'd15} : //blue wall
             (bar_on)?              {4'd0,  4'd15,  4'd0} : // green bar
             (ball_on)?             {4'd15, 4'd0,   4'd0} : // red ball
             (circle_on)?           {4'd15, 4'd15,  4'd15} : // circle_test
                                    {4'd15, 4'd15,  4'd0}; //yellow background
  

endmodule
