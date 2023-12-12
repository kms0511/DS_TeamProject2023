`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/29 19:53:27
// Design Name: 
// Module Name: ranker
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

module ranker(
input clk, rst, start_pulse,
input [3:0] c_state,
input [21:0] a, b, c, d, e, f,
output reg calculate_end,
output reg [2:0] order_1_result, order_2_result, order_3_result, order_4_result, order_5_result, order_6_result
);
parameter     WAIT=5'd0,  ORDERSTART=5'd1, ORDER0=5'd2,  ORDER1=5'd3,  ORDER2=5'd4, 
            ORDER3=5'd5,  ORDER4=5'd6,  ORDEREND=5'd7,
            MAX0 = 5'd8,  MAX1 = 5'd9,  MAX2 = 5'd10, MAX3 = 5'd11, 
            MAX4 = 5'd12, MAX5 = 5'd13, MAXEND = 5'd14,
            SCOREA0=5'd15,SCOREA1=5'd16,SCOREA2=5'd17,
            SCOREB0=5'd18,SCOREB1=5'd19,SCOREB2=5'd20,
            SCOREEND=5'd21, SCOREEND2=5'd22, SCORINGEND=5'd23;

reg [2:0] order_1, order_2, order_3, order_4, order_5, order_6;

always @(posedge clk, posedge rst) begin
  if(rst) order_1 <= 0;
  else begin
    case (c_state)
      ORDERSTART:begin order_1 <= 0; end
      ORDER0:   begin if(a>b) order_1 <= order_1 + 1; end
      ORDER1:   begin if(a>c) order_1 <= order_1 + 1; end
      ORDER2:   begin if(a>d) order_1 <= order_1 + 1; end
      ORDER3:   begin if(a>e) order_1 <= order_1 + 1; end
      ORDER4:   begin if(a>f) order_1 <= order_1 + 1; end
      // ORDEREND: begin end
      // default: begin end
    endcase
  end
end
always @(posedge clk, posedge rst) begin
  if(rst) order_2 <= 0;
  else begin
    case (c_state)
       ORDERSTART:begin order_2 <= 0; end
        ORDER0:   begin if(b>a) order_2 <= order_2 + 1; end
        ORDER1:   begin if(b>c) order_2 <= order_2 + 1; end
        ORDER2:   begin if(b>d) order_2 <= order_2 + 1; end
        ORDER3:   begin if(b>e) order_2 <= order_2 + 1; end
        ORDER4:   begin if(b>f) order_2 <= order_2 + 1; end
        // ORDEREND: begin end
        // default:begin end
    endcase
  end
end
always @(posedge clk, posedge rst) begin
  if(rst) order_3 <= 0;
  else begin
    case (c_state)
        ORDERSTART:begin order_3 <= 0; end
        ORDER0:   begin if(c>a) order_3 <= order_3 + 1; end
        ORDER1:   begin if(c>b) order_3 <= order_3 + 1; end
        ORDER2:   begin if(c>d) order_3 <= order_3 + 1; end
        ORDER3:   begin if(c>e) order_3 <= order_3 + 1; end
        ORDER4:   begin if(c>f) order_3 <= order_3 + 1; end
        // ORDEREND: begin end
        // default:begin end
    endcase
  end
end
always @(posedge clk, posedge rst) begin
  if(rst) order_4 <= 0;
  else begin
    case (c_state)
        ORDERSTART:begin order_4 <= 0; end
        ORDER0:   begin if(d>a) order_4 <= order_4 + 1; end
        ORDER1:   begin if(d>b) order_4 <= order_4 + 1; end
        ORDER2:   begin if(d>c) order_4 <= order_4 + 1; end
        ORDER3:   begin if(d>e) order_4 <= order_4 + 1; end
        ORDER4:   begin if(d>f) order_4 <= order_4 + 1; end
        // ORDEREND: begin end
        // default:begin end
    endcase
  end
end
always @(posedge clk, posedge rst) begin
  if(rst) order_5 <= 0;
  else begin
    case (c_state)
        ORDERSTART:begin order_5 <= 0; end
        ORDER0:   begin if(e>a) order_5 <= order_5 + 1; end
        ORDER1:   begin if(e>b) order_5 <= order_5 + 1; end
        ORDER2:   begin if(e>c) order_5 <= order_5 + 1; end
        ORDER3:   begin if(e>d) order_5 <= order_5 + 1; end
        ORDER4:   begin if(e>f) order_5 <= order_5 + 1; end
        // ORDEREND: begin end
        // default:begin end
    endcase
  end
end
always @(posedge clk, posedge rst) begin
  if(rst) order_6 <= 0;
  else begin
    case (c_state)
        ORDERSTART:begin order_6 <= 0; end
        ORDER0:   begin if(f>a) order_6 <= order_6 + 1; end
        ORDER1:   begin if(f>b) order_6 <= order_6 + 1; end
        ORDER2:   begin if(f>c) order_6 <= order_6 + 1; end
        ORDER3:   begin if(f>d) order_6 <= order_6 + 1; end
        ORDER4:   begin if(f>e) order_6 <= order_6 + 1; end
        // ORDEREND: begin end
        // default:begin end
    endcase
  end
end

always @(posedge clk, posedge rst) begin
    if(rst) begin
      order_1_result <= 0;
      order_2_result <= 0;
      order_3_result <= 0;
      order_4_result <= 0;
      order_5_result <= 0;
      order_6_result <= 0;
    end
    else if(c_state==ORDEREND) begin
      order_1_result <= order_1;
      order_2_result <= order_2;
      order_3_result <= order_3;
      order_4_result <= order_4;
      order_5_result <= order_5;
      order_6_result <= order_6;
    end
end
endmodule
