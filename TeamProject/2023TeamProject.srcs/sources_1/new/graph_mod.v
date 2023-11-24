`timescale 1ns / 1ps

module graph_mod (clk, rst, x, y, key, key_pulse, rgb);

// ȭ�� ũ�� ����
parameter MAX_X = 640; 
parameter MAX_Y = 480;  

//wall �� ��ǥ ����
parameter WALL_X_L = 32; 
parameter WALL_X_R = 35;

//bar�� x ��ǥ
parameter BAR_X_L = 600; 
parameter BAR_X_R = 603;

//bar �ӵ�, bar size
parameter BAR_Y_SIZE = 72; 
parameter BAR_V = 4; 

//ball �ӵ�, ball size 
parameter BALL_SIZE = 8; 
parameter BALL_V = 4; //ball�� �ӵ�

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
assign frame_tick = (y==MAX_Y-1 && x==MAX_X-1)? 1 : 0; // �� �����Ӹ��� �� clk ���ȸ� 1�� ��. 

// wall
assign wall_on = (x>=WALL_X_L && x<=WALL_X_R)? 1 : 0; //wall�� �ִ� ����

/*---------------------------------------------------------*/
// circle test
/*---------------------------------------------------------*/
wire circle_on;
circle circle_test(.x(x), .y(y), .cir_x(200), .cir_y(200), .cir_r(10), .cir_rgb({4'd15,4'd15,4'd15}), .circle_on(circle_on));





/*---------------------------------------------------------*/
// bar�� ��ġ ����
/*---------------------------------------------------------*/
assign bar_y_t = current_bar_y; //bar�� top
assign bar_y_b = bar_y_t + BAR_Y_SIZE - 1; //bar�� bottom

assign bar_on = (x>=BAR_X_L && x<=BAR_X_R && y>=bar_y_t && y<=bar_y_b)? 1 : 0; //bar�� �ִ� ����

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
// ball�� ��ġ ����
/*---------------------------------------------------------*/
assign ball_x_l = current_ball_x; //ball�� left
assign ball_x_r = current_ball_x + BALL_SIZE - 1; //ball�� right
assign ball_y_t = current_ball_y; //ball�� top
assign ball_y_b = current_ball_y + BALL_SIZE - 1; //ball�� bottom

assign ball_on = (x>=ball_x_l && x<=ball_x_r && y>=ball_y_t && y<=ball_y_b)? 1 : 0; //ball�� �ִ� ����

assign reach_top = (ball_y_t==0)? 1 : 0; //ball ���� ��谡 1���� ������ õ�忡 �ε���
assign reach_bottom = (ball_y_b>MAX_Y-1)? 1 : 0; //ball�� �Ʒ��� ��谡 479���� ũ�� �ٴڿ� �ε���
assign reach_wall =(ball_x_l<=WALL_X_R)? 1 : 0; //ball�� ���ʰ�谡 wall�� ������ ��躸�� ������ wall�� �ε���
assign reach_bar = (ball_x_r>=BAR_X_L && ball_x_r<=BAR_X_R && ball_y_b>=bar_y_t && ball_y_t<=bar_y_b)? 1 : 0; //ball�� bar�� �ε���
assign miss_ball = (ball_x_r>MAX_X)? 1 : 0; //ball�� ������ ��谡 639���� ũ�� ball�� ��ħ

always @* begin
    if (game_stop) next_ball_vx = -1*BALL_V; //�����Ҷ��� ��������
    else if (reach_wall) next_ball_vx = BALL_V; //���� �ε����� ����������
    else if (reach_bar) next_ball_vx = -1*BALL_V; //�ٿ� ƨ��� ��������
    else next_ball_vx = current_ball_vx; //�ƴϸ� ���� ��������
end

always @* begin
    if (game_stop) next_ball_vy = BALL_V; //�����Ҷ��� �Ʒ���
    else if (reach_top) next_ball_vy = BALL_V; //õ�忡 �ε����� �Ʒ���.
    else if (reach_bottom) next_ball_vy = -1*BALL_V; //�ٴڿ� �ε����� ����
    else next_ball_vy = current_ball_vy; //�ƴϸ� ���� ��������
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
        next_ball_x = current_ball_x + current_ball_vx; //�� �����Ӹ��� ball_vx_reg��ŭ ������
        next_ball_y = current_ball_y + current_ball_vy; //�� �����Ӹ��� ball_vy_reg��ŭ ������
    end
    else begin
        next_ball_x = current_ball_x; //frame_tick�� �ƴҶ��� �� ������. 
        next_ball_y = current_ball_y; //frame_tick�� �ƴҶ��� �� ������. 
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
// bar�� ���� ���� �� ���� score�� 1�� ������Ű�� ���� 
/*---------------------------------------------------------*/
reg d_inc, d_clr;
wire hit, miss;
reg [3:0] dig0, dig1;

assign hit = (reach_bar==1 && frame_tick==1)? 1 : 0; //ball�� bar�� ����, hit�� 1Ŭ�� pulse�� ����� ���� frame_tick�� AND ��Ŵ
assign miss = (miss_ball==1 && frame_tick==1)? 1 : 0; //bar�� ball�� ��ħ, miss�� 1Ŭ�� pulse�� ����� ���� frame_tick�� AND ��Ŵ

always @ (posedge clk or posedge rst) begin
    if(rst | d_clr) begin
        dig1 <= 0;
        dig0 <= 0;
    end else if (hit) begin //bar�� ���߸� ������ ����
        if(dig0==9) begin 
            dig0 <= 0;
            if (dig1==9) dig1 <= 0;
            else dig1 <= dig1+1; //���� 10�� �ڸ� 1�� ����
        end else dig0 <= dig0+1; //���� 1�� �ڸ� 1�� ����
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
        NEWGAME: begin //�� ����
            d_clr = 1; //���ھ� 0���� �ʱ�ȭ
            if(key[4] == 1) begin //��ư�� ������
                state_next = PLAY; //���ӽ���
                life_next = 2'b10; //���� ���� 2����
            end else begin
                state_next = NEWGAME; //��ư�� �� ������ ���� ���� ����
                life_next = 2'b11; //���� ���� 3�� ����
            end
         end
         PLAY: begin
            game_stop = 0; //���� Running
            d_inc = hit;
            if (miss) begin //ball�� ��ġ��
                if (life_reg==2'b00) //���� ������ ������
                    state_next = OVER; //��������
                else begin//���� ������ ������ 
                    state_next = NEWBALL; 
                    life_next = life_reg-1'b1; //���� ���� �ϳ� ����
                end
            end else
                state_next = PLAY; //ball ��ġ�� ������ ��� ����
        end
        NEWBALL: //�� ball �غ�
            if(key[4] == 1) state_next = PLAY;
            else state_next = NEWBALL; 
        OVER: begin
            if(key[4] == 1) begin //������ ������ �� ��ư�� ������ ������ ����
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
assign font_bit = font_word[~bit_addr]; //ȭ�� x��ǥ�� ������ ������, rom�� bit�� �������� �����Ƿ� reverse

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
    else if (x>=score_x_l+8*2 && x<score_x_l+8*3) begin bit_addr_s = x-score_x_l-8*2; char_addr_s = {3'b011, dig1}; end // digit 10, ASCII �ڵ忡�� ������ address�� 011�� ���� 
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
