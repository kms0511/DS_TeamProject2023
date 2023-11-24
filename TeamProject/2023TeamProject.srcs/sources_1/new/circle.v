module circle(
input [9:0] x, y,
input [9:0] cir_x, cir_y, cir_r,
input [11:0] cir_rgb,
output circle_on
    );

assign distance = (((cir_x-x)*(cir_x-x))+ ((cir_y-y)*(cir_y-y))) ** 1/2;

assign circle_on = (distance < cir_r)? 1 : 0; //wall이 있는 영역

endmodule
