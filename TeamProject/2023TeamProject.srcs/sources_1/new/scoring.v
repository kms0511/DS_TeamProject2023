`timescale 1ns / 1ps

module scoring(
input signed [10:0] target_x, target_y, target_r, 

input signed [10:0] ball_x_a1, ball_y_a1,
input signed [10:0] ball_x_a2, ball_y_a2,
input signed [10:0] ball_x_a3, ball_y_a3,

input signed [10:0] ball_x_b1, ball_y_b1,
input signed [10:0] ball_x_b2, ball_y_b2,
input signed [10:0] ball_x_b3, ball_y_b3,

input signed [10:0] ball_r,

input [3:0] on_track_count,
output [7:0] score_a, score_b
);
// ball - target distance
wire [19:0] d_a1, d_a2, d_a3, d_b1, d_b2, d_b3; //d=distance
reg [3:0] order_a1,order_a2,order_a3,order_b1,order_b2,order_b3;
// ball - target distance calculate
// all distance is (dist)^2 ed
distance_t distance_t_a1(.target_x(target_x), .target_y(target_y), .ball_x(ball_x_a1), .ball_y(ball_y_a1), .distance_sq(d_a1));
distance_t distance_t_a2(.target_x(target_x), .target_y(target_y), .ball_x(ball_x_a2), .ball_y(ball_y_a2), .distance_sq(d_a2));
distance_t distance_t_a3(.target_x(target_x), .target_y(target_y), .ball_x(ball_x_a3), .ball_y(ball_y_a3), .distance_sq(d_a3));

distance_t distance_t_b1(.target_x(target_x), .target_y(target_y), .ball_x(ball_x_b1), .ball_y(ball_y_b1), .distance_sq(d_b1));
distance_t distance_t_b2(.target_x(target_x), .target_y(target_y), .ball_x(ball_x_b2), .ball_y(ball_y_b2), .distance_sq(d_b2));
distance_t distance_t_b3(.target_x(target_x), .target_y(target_y), .ball_x(ball_x_b3), .ball_y(ball_y_b3), .distance_sq(d_b3));

always @* begin
    if (d_a1 > d_a2 && d_a1 > d_a3 && d_a1 > d_b1 && d_a1 > d_b2 && d_a1 > d_b3) order_a1 = 1;
    else if (d_a2 > d_a3 && d_a2 > d_b1 && d_a2 > d_b2 && d_a2 > d_b3) order_a1 = 2;
    else if (d_a3 > d_b1 && d_a3 > d_b2 && d_a3 > d_b3) order_a1 = 3;
    else if (d_b1 > d_b2 && d_b1 > d_b3) order_a1 = 4;
    else if (d_b2 > d_b3) order_a1 = 5;
    else order_a1 = 6;
end
always @* begin
    if (d_a2 > d_a1 && d_a2 > d_a3 && d_a2 > d_b1 && d_a2 > d_b2 && d_a2 > d_b3) order_a2 = 1;
    else if (d_a1 > d_a3 && d_a1 > d_b1 && d_a1 > d_b2 && d_a1 > d_b3) order_a2 = 2;
    else if (d_a3 > d_b1 && d_a3 > d_b2 && d_a3 > d_b3) order_a2 = 3;
    else if (d_b1 > d_b2 && d_b1 > d_b3) order_a2 = 4;
    else if (d_b2 > d_b3) order_a2 = 5;
    else order_a2 = 6;
end
always @* begin
    if (d_a3 > d_a1 && d_a3 > d_a2 && d_a3 > d_b1 && d_a3 > d_b2 && d_a3 > d_b3) order_a3 = 1;
    else if (d_a1 > d_a2 && d_a1 > d_b1 && d_a1 > d_b2 && d_a1 > d_b3) order_a3 = 2;
    else if (d_a2 > d_b1 && d_a2 > d_b2 && d_a2 > d_b3) order_a3 = 3;
    else if (d_b1 > d_b2 && d_b1 > d_b3) order_a3 = 4;
    else if (d_b2 > d_b3) order_a3 = 5;
    else order_a3 = 6;
end
always @* begin
    if (d_b1 > d_a1 && d_b1 > d_a2 && d_b1 > d_a3 && d_b1 > d_b2 && d_b1 > d_b3) order_b1 = 1;
    else if (d_a1 > d_a2 && d_a1 > d_a3 && d_a1 > d_b2 && d_a1 > d_b3) order_b1 = 2;
    else if (d_a2 > d_a3 && d_a2 > d_b2 && d_a2 > d_b3) order_b1 = 3;
    else if (d_a3 > d_b2 && d_a3 > d_b3) order_b1 = 4;
    else if (d_b2 > d_b3) order_b1 = 5;
    else order_b1 = 6;
end
always @* begin
    if (d_b2 > d_a1 && d_b2 > d_a2 && d_b2 > d_a3 && d_b2 > d_b1 && d_b2 > d_b3) order_b2 = 1;
    else if (d_a1 > d_a2 && d_a1 > d_a3 && d_a1 > d_b1 && d_a1 > d_b3) order_b2 = 2;
    else if (d_a2 > d_a3 && d_a2 > d_b1 && d_a2 > d_b3) order_b2 = 3;
    else if (d_a3 > d_b1 && d_a3 > d_b3) order_b2 = 4;
    else if (d_b1 > d_b3) order_b2 = 5;
    else order_b2 = 6;
end
always @* begin
    if (d_b3 > d_a1 && d_b3 > d_a2 && d_b3 > d_a3 && d_b3 > d_b1 && d_b3 > d_b2) order_b3 = 1;
    else if (d_a1 > d_a2 && d_a1 > d_a3 && d_a1 > d_b1 && d_a1 > d_b2) order_b3 = 2;
    else if (d_a2 > d_a3 && d_a2 > d_b1 && d_a2 > d_b2) order_b3 = 3;
    else if (d_a3 > d_b1 && d_a3 > d_b2) order_b3 = 4;
    else if (d_b1 > d_b2) order_b3 = 5;
    else order_b3 = 6;
end

endmodule
