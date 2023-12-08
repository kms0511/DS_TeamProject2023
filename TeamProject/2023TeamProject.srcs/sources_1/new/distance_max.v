`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/04 21:14:02
// Design Name: 
// Module Name: distance_max
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module distance_max(
input clk, rst,
input [3:0] c_state,
input signed [10:0] target_r, ball_r,
input [21:0] distsq_a, distsq_b, distsq_c, distsq_d, distsq_e, distsq_f, 
output reg [2:0] max_out);

parameter   IDLE=4'b0, BIT1=4'd1, BIT2=4'd2, BIT3=4'd3, 
            BIT4=4'd4, BIT5=4'd5, WAIT=4'd6, WAIT2=4'd7;

reg [2:0] max;

always @(*) begin
    case (c_state)
        IDLE:   begin if((target_r + ball_r) * (target_r + ball_r) > distsq_a) max = max + 1; end
        BIT1:   begin if((target_r + ball_r) * (target_r + ball_r) > distsq_b) max = max + 1; end
        BIT2:   begin if((target_r + ball_r) * (target_r + ball_r) > distsq_c) max = max + 1; end
        BIT3:   begin if((target_r + ball_r) * (target_r + ball_r) > distsq_d) max = max + 1; end
        BIT4:   begin if((target_r + ball_r) * (target_r + ball_r) > distsq_e) max = max + 1; end
        BIT5:   begin if((target_r + ball_r) * (target_r + ball_r) > distsq_f) max = max + 1; end
        WAIT:   begin end
        WAIT2:  begin max = 0; end
        default:begin max = 0; end
    endcase
end

always @(posedge clk, posedge rst) begin
    if(rst) begin
        max_out <= 0;
        max <= 0;
    end
    else if(c_state==BIT5) begin
        max_out <= max;
    end
end

endmodule