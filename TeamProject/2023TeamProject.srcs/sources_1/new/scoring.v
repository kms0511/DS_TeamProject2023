`timescale 1ns / 1ps

module scoring(
input clk, rst,

input signed [10:0] target_x, target_y, target_r, 

input signed [10:0] stone_x_a1, stone_y_a1,
input signed [10:0] stone_x_a2, stone_y_a2,
input signed [10:0] stone_x_a3, stone_y_a3,

input signed [10:0] stone_x_b1, stone_y_b1,
input signed [10:0] stone_x_b2, stone_y_b2,
input signed [10:0] stone_x_b3, stone_y_b3,

input signed [10:0] stone_r,

input [3:0] gamestate_in,
output reg [3:0] score_red, score_blue,
output scoring_end
);
parameter GAMESTANBY=0, GAMEREADY=1, GAME0ST=2, GAME1ST=3, GAME2ST=4, GAME3ST=5, GAME4ST=6, GAME5ST=7, SCORINGSTART=8, SCORING=9, GAMEEND=10;
// stone - target distance

reg [3:0] score_a, score_b;
wire [21:0] d_a1, d_a2, d_a3, d_b1, d_b2, d_b3; //d=distance
wire [2:0] order_end_a1, order_end_a2, order_end_a3, order_end_b1, order_end_b2, order_end_b3;
// stone - target distance calculate
// all distance is (dist)^2 ed
distance_t distance_t_a1(.target_x(target_x), .target_y(target_y), .stone_x(stone_x_a1), .stone_y(stone_y_a1), .distance_sq(d_a1));
distance_t distance_t_a2(.target_x(target_x), .target_y(target_y), .stone_x(stone_x_a2), .stone_y(stone_y_a2), .distance_sq(d_a2));
distance_t distance_t_a3(.target_x(target_x), .target_y(target_y), .stone_x(stone_x_a3), .stone_y(stone_y_a3), .distance_sq(d_a3));

distance_t distance_t_b1(.target_x(target_x), .target_y(target_y), .stone_x(stone_x_b1), .stone_y(stone_y_b1), .distance_sq(d_b1));
distance_t distance_t_b2(.target_x(target_x), .target_y(target_y), .stone_x(stone_x_b2), .stone_y(stone_y_b2), .distance_sq(d_b2));
distance_t distance_t_b3(.target_x(target_x), .target_y(target_y), .stone_x(stone_x_b3), .stone_y(stone_y_b3), .distance_sq(d_b3));

reg [4:0] c_state, n_state;
wire calc_trigger;
//, calc_end;
//reg calc_end_2;
assign calc_trigger = (gamestate_in == SCORINGSTART) ? 1 : 0;
reg [2:0] max_count;
reg [2:0] order [0:5];

parameter     WAIT=5'd0,  ORDERSTART=5'd1, ORDER0=5'd2,  ORDER1=5'd3,  ORDER2=5'd4, 
            ORDER3=5'd5,  ORDER4=5'd6,  ORDEREND=5'd7,
            MAX0 = 5'd8,  MAX1 = 5'd9,  MAX2 = 5'd10, MAX3 = 5'd11, 
            MAX4 = 5'd12, MAX5 = 5'd13, MAXEND = 5'd14,
            SCOREA0=5'd15,SCOREA1=5'd16,SCOREA2=5'd17,
            SCOREB0=5'd18,SCOREB1=5'd19,SCOREB2=5'd20,
            SCOREEND=5'd21, SCOREEND2=5'd22, SCORINGEND=5'd23;

always @(posedge clk, posedge rst) begin
    if(rst) c_state <= WAIT;
    else    c_state <= n_state;
end

assign scoring_end = (c_state == SCORINGEND) ? 1 : 0;
// always @(*) begin
//     case (c_state)
//         SCOREEND:begin scoring_end=1; end
//         default: begin scoring_end=0; end
//     endcase
// end
always @(*) begin
    case (c_state)
        WAIT:    begin if(calc_trigger) n_state=ORDERSTART; else n_state=WAIT; end
        ORDERSTART:begin n_state=ORDER0; end
        ORDER0:  begin n_state=ORDER1; end
        ORDER1:  begin n_state=ORDER2; end
        ORDER2:  begin n_state=ORDER3; end
        ORDER3:  begin n_state=ORDER4; end
        ORDER4:  begin n_state=ORDEREND; end
        ORDEREND:begin n_state=MAX0; end

        MAX0:    begin n_state=MAX1; end
        MAX1:    begin n_state=MAX2; end
        MAX2:    begin n_state=MAX3; end
        MAX3:    begin n_state=MAX4; end
        MAX4:    begin n_state=MAX5; end
        MAX5:    begin n_state=MAXEND; end
        MAXEND:  begin n_state=SCOREA0; end

        SCOREA0: begin if(order[0]%2==0 && max_count>=0) n_state=SCOREA1; else n_state=SCOREB0; end
        SCOREA1: begin if(order[1]%2==0 && max_count>=1) n_state=SCOREA2; else n_state=SCOREEND;end
        SCOREA2: begin if(order[2]%2==0 && max_count>=2) n_state=SCOREEND;else n_state=SCOREEND;end
        SCOREB0: begin if(order[0]%2==1 && max_count>=0) n_state=SCOREB1; else n_state=SCOREEND;end
        SCOREB1: begin if(order[1]%2==1 && max_count>=1) n_state=SCOREB2; else n_state=SCOREEND;end
        SCOREB2: begin if(order[2]%2==1 && max_count>=2) n_state=SCOREEND;else n_state=SCOREEND;end
        SCOREEND:begin n_state=SCOREEND2; end
        SCOREEND2:begin n_state=SCORINGEND; end
        SCORINGEND:begin n_state=WAIT; end

        default: begin n_state=WAIT; end
    endcase
end

//wait ?? ?? <=?? ???? ??? ??
//---ORDER---ORDER---ORDER---ORDER---ORDER---ORDER---ORDER---ORDER---ORDER---ORDER---ORDER---
ranker ranker_inst(.clk(clk), .rst(rst), .start_pulse(calc_trigger), .c_state(c_state),
    .a(d_a1), .b(d_a2), .c(d_a3), .d(d_b1), .e(d_b2), .f(d_b3), 
    .order_1_result(order_end_a1), .order_2_result(order_end_a2), .order_3_result(order_end_a3), 
    .order_4_result(order_end_b1), .order_5_result(order_end_b2), .order_6_result(order_end_b3));


//---MAX---MAX---MAX---MAX---MAX---MAX---MAX---MAX---MAX---MAX---MAX---MAX---MAX---MAX---MAX---MAX---
always @(posedge clk, posedge rst) begin
    if(rst) begin
        max_count<=0;
    end
    else begin
        case (c_state)
            // WAIT:    begin end
            // ORDER0:  begin end
            // ORDER1:  begin end
            // ORDER2:  begin end
            // ORDER3:  begin end
            // ORDER4:  begin end
            ORDEREND:begin max_count <= 0; end

            MAX0:    begin if((target_r + stone_r) * (target_r + stone_r) > d_a1) max_count <= max_count + 1; end
            MAX1:    begin if((target_r + stone_r) * (target_r + stone_r) > d_a2) max_count <= max_count + 1; end
            MAX2:    begin if((target_r + stone_r) * (target_r + stone_r) > d_a3) max_count <= max_count + 1; end
            MAX3:    begin if((target_r + stone_r) * (target_r + stone_r) > d_b1) max_count <= max_count + 1; end
            MAX4:    begin if((target_r + stone_r) * (target_r + stone_r) > d_b2) max_count <= max_count + 1; end
            MAX5:    begin if((target_r + stone_r) * (target_r + stone_r) > d_b3) max_count <= max_count + 1; end
            // MAXEND:  begin end

            // SCOREA0: begin end
            // SCOREA1: begin end
            // SCOREA2: begin end
            // SCOREB0: begin end
            // SCOREB1: begin end
            // SCOREB2: begin end
            // SCOREEND:begin end
            // SCOREEND2:begin end
            // SCORINGEND:begin end

            // default: begin end
        endcase
    end
end 

//---ORDER---ORDER---ORDER---ORDER---ORDER---ORDER---ORDER---ORDER---ORDER---ORDER---ORDER---ORDER---ORDER---
always @(posedge clk, posedge rst) begin
    if(rst) begin
        order[0]<=0;
        order[1]<=0;
        order[2]<=0;
        order[3]<=0;
        order[4]<=0;
        order[5]<=0;
    end
    else begin
        case (c_state)
            WAIT:    begin end
            ORDER0:  begin end
            ORDER1:  begin end
            ORDER2:  begin end
            ORDER3:  begin end
            ORDER4:  begin end

            ORDEREND:begin end
            MAX0:begin 
                case(order_end_a1)
                0: order[0]<=0;
                1: order[1]<=0;
                2: order[2]<=0;
                3: order[3]<=0;
                4: order[4]<=0;
                5: order[5]<=0;
                endcase
            end
            MAX1:    begin 
                case(order_end_a2)
                0: order[0]<=2;
                1: order[1]<=2;
                2: order[2]<=2;
                3: order[3]<=2;
                4: order[4]<=2;
                5: order[5]<=2;
                endcase end
            MAX2:    begin 
                case(order_end_a3)
                0: order[0]<=4;
                1: order[1]<=4;
                2: order[2]<=4;
                3: order[3]<=4;
                4: order[4]<=4;
                5: order[5]<=4;
                endcase end
            MAX3:    begin 
                case(order_end_b1)
                0: order[0]<=1;
                1: order[1]<=1;
                2: order[2]<=1;
                3: order[3]<=1;
                4: order[4]<=1;
                5: order[5]<=1;
                endcase end
            MAX4:    begin 
                case(order_end_b2)
                0: order[0]<=3;
                1: order[1]<=3;
                2: order[2]<=3;
                3: order[3]<=3;
                4: order[4]<=3;
                5: order[5]<=3;
                endcase end
            MAX5:    begin 
                case(order_end_b3)
                0: order[0]<=5;
                1: order[1]<=5;
                2: order[2]<=5;
                3: order[3]<=5;
                4: order[4]<=5;
                5: order[5]<=5;
                endcase end
            // MAXEND:  begin end

            // SCOREA0: begin end
            // SCOREA1: begin end
            // SCOREA2: begin end
            // SCOREB0: begin end
            // SCOREB1: begin end
            // SCOREB2: begin end
            // SCOREEND:begin end
            // SCOREEND2:begin end
            // SCORINGEND:begin end

            // default: begin end
        endcase
    end
end 

// always @(posedge clk, posedge rst) begin//gong   sun seo dae ro   gong bern ho rel   nut neun da

// end

//---SCORE---SCORE---SCORE---SCORE---SCORE---SCORE---SCORE---SCORE---SCORE---SCORE---SCORE---SCORE---
always @(posedge clk, posedge rst) begin
    if(rst) begin
        score_red <= 0;
        score_blue <= 0;
    end
    else if(c_state == SCOREEND) begin
        score_red <= score_a;
        score_blue <= score_b;
    end
end

always @(posedge clk, posedge rst) begin
    if(rst) begin
        score_a <= 0;
        score_b <= 0;
    end
    else begin
        case (c_state)
            //WAIT:begin  end
            //MAX5:    begin score_a <= 0; score_b <= 0; end
            MAXEND:  begin score_a <= 0; score_b <= 0; end
            SCOREA0: begin if(order[0]%2==0 && max_count>0) score_a <= score_a + 1; end
            SCOREA1: begin if(order[1]%2==0 && max_count>1) score_a <= score_a + 1; end
            SCOREA2: begin if(order[2]%2==0 && max_count>2) score_a <= score_a + 1; end

            SCOREB0: begin if(order[0]%2==1 && max_count>0) score_b <= score_b + 1; end
            SCOREB1: begin if(order[1]%2==1 && max_count>1) score_b <= score_b + 1; end
            SCOREB2: begin if(order[2]%2==1 && max_count>2) score_b <= score_b + 1; end

            // SCOREEND:begin end
            // SCOREEND2:begin end
            // SCORINGEND:begin end
            default:begin end
        endcase
    end
end

endmodule
