`timescale 1ns / 1ps

module distance_t(
input signed [10:0] target_x, target_y, target_r, 
input signed [10:0] stone_x, stone_y,
output [21:0] distance_sq
);

assign distance_sq = (((target_x-stone_x)*(target_x-stone_x)) + ((target_y-stone_y)*(target_y-stone_y)));
//assign distance_sq = (distance_t >= target_r * target_r) ? 1000000 : distance_t;

endmodule
