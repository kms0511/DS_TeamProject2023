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
            SCOREB0=5'd18,SCOREB1=5'd19,SCOREB2=5'd20,SCOREEND=5'd21;

reg [2:0] order_1, order_2, order_3, order_4, order_5, order_6;

always @(*) begin
    case (c_state)
      ORDERSTART:begin order_1 = 0; end
      ORDER0:   begin if(a>b) order_1 = order_1 + 1; end
      ORDER1:   begin if(a>c) order_1 = order_1 + 1; end
      ORDER2:   begin if(a>d) order_1 = order_1 + 1; end
      ORDER3:   begin if(a>e) order_1 = order_1 + 1; end
      ORDER4:   begin if(a>f) order_1 = order_1 + 1; end
      ORDEREND: begin end
      default: begin end
    endcase
end
always @(*) begin
    case (c_state)
       ORDERSTART:begin order_2 = 0; end
        ORDER0:   begin if(b>a) order_2 = order_2 + 1; end
        ORDER1:   begin if(b>c) order_2 = order_2 + 1; end
        ORDER2:   begin if(b>d) order_2 = order_2 + 1; end
        ORDER3:   begin if(b>e) order_2 = order_2 + 1; end
        ORDER4:   begin if(b>f) order_2 = order_2 + 1; end
        ORDEREND: begin end
        default:begin end
    endcase
end
always @(*) begin
    case (c_state)
        ORDERSTART:begin order_3 = 0; end
        ORDER0:   begin if(c>a) order_3 = order_3 + 1; end
        ORDER1:   begin if(c>b) order_3 = order_3 + 1; end
        ORDER2:   begin if(c>d) order_3 = order_3 + 1; end
        ORDER3:   begin if(c>e) order_3 = order_3 + 1; end
        ORDER4:   begin if(c>f) order_3 = order_3 + 1; end
        ORDEREND: begin end
        default:begin end
    endcase
end
always @(*) begin
    case (c_state)
        ORDERSTART:begin order_4 = 0; end
        ORDER0:   begin if(d>a) order_4 = order_4 + 1; end
        ORDER1:   begin if(d>b) order_4 = order_4 + 1; end
        ORDER2:   begin if(d>c) order_4 = order_4 + 1; end
        ORDER3:   begin if(d>e) order_4 = order_4 + 1; end
        ORDER4:   begin if(d>f) order_4 = order_4 + 1; end
        ORDEREND: begin end
        default:begin end
    endcase
end
always @(*) begin
    case (c_state)
        ORDERSTART:begin order_5 = 0; end
        ORDER0:   begin if(e>a) order_5 = order_5 + 1; end
        ORDER1:   begin if(e>b) order_5 = order_5 + 1; end
        ORDER2:   begin if(e>c) order_5 = order_5 + 1; end
        ORDER3:   begin if(e>d) order_5 = order_5 + 1; end
        ORDER4:   begin if(e>f) order_5 = order_5 + 1; end
        ORDEREND: begin end
        default:begin end
    endcase
end
always @(*) begin
    case (c_state)
        ORDERSTART:begin order_6 = 0; end
        ORDER0:   begin if(f>a) order_6 = order_6 + 1; end
        ORDER1:   begin if(f>b) order_6 = order_6 + 1; end
        ORDER2:   begin if(f>c) order_6 = order_6 + 1; end
        ORDER3:   begin if(f>d) order_6 = order_6 + 1; end
        ORDER4:   begin if(f>e) order_6 = order_6 + 1; end
        ORDEREND: begin end
        default:begin end
    endcase
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
    else if(c_state==ORDER4) begin
    order_1_result <= order_1;
    order_2_result <= order_2;
    order_3_result <= order_3;
    order_4_result <= order_4;
    order_5_result <= order_5;
    order_6_result <= order_6;
    end
end
endmodule


/*
module ranker(
  input clk, rst,
  input wire [21:0] data_in_0,
  input wire [21:0] data_in_1,
  input wire [21:0] data_in_2,
  input wire [21:0] data_in_3,
  input wire [21:0] data_in_4,
  input wire [21:0] data_in_5,
  output wire [21:0] sorted_data_out_0,
  output wire [21:0] sorted_data_out_1,
  output wire [21:0] sorted_data_out_2,
  output wire [21:0] sorted_data_out_3,
  output wire [21:0] sorted_data_out_4,
  output wire [21:0] sorted_data_out_5
);
  reg [21:0] sorted_data_0, sorted_data_1, sorted_data_2, sorted_data_3, sorted_data_4, sorted_data_5;
  reg [21:0] temp;
  integer i, j;

  // 초기화
  always @(posedge clk, posedge rst) begin
    if(rst) begin
    sorted_data_0 <= data_in_0;
    sorted_data_1 <= data_in_1;
    sorted_data_2 <= data_in_2;
    sorted_data_3 <= data_in_3;
    sorted_data_4 <= data_in_4;
    sorted_data_5 <= data_in_5;
    end
  end

  // 버블 정렬
  always @* begin
    // sorted_data_0 정렬
    for (i = 0; i < 5; i = i + 1) begin
      for (j = 0; j < 5 - i; j = j + 1) begin
        if (sorted_data_0[j] > sorted_data_0[j + 1]) begin
          temp = sorted_data_0[j];
          sorted_data_0[j] = sorted_data_0[j + 1];
          sorted_data_0[j + 1] = temp;
        end
      end
    end

    // sorted_data_1 정렬
    for (i = 0; i < 5; i = i + 1) begin
      for (j = 0; j < 5 - i; j = j + 1) begin
        if (sorted_data_1[j] > sorted_data_1[j + 1]) begin
          temp = sorted_data_1[j];
          sorted_data_1[j] = sorted_data_1[j + 1];
          sorted_data_1[j + 1] = temp;
        end
      end
    end

    // sorted_data_2 정렬
    for (i = 0; i < 5; i = i + 1) begin
      for (j = 0; j < 5 - i; j = j + 1) begin
        if (sorted_data_2[j] > sorted_data_2[j + 1]) begin
          temp = sorted_data_2[j];
          sorted_data_2[j] = sorted_data_2[j + 1];
          sorted_data_2[j + 1] = temp;
        end
      end
    end

    // sorted_data_3 정렬
    for (i = 0; i < 5; i = i + 1) begin
      for (j = 0; j < 5 - i; j = j + 1) begin
        if (sorted_data_3[j] > sorted_data_3[j + 1]) begin
          temp = sorted_data_3[j];
          sorted_data_3[j] = sorted_data_3[j + 1];
          sorted_data_3[j + 1] = temp;
        end
      end
    end

    // sorted_data_4 정렬
    for (i = 0; i < 5; i = i + 1) begin
      for (j = 0; j < 5 - i; j = j + 1) begin
        if (sorted_data_4[j] > sorted_data_4[j + 1]) begin
          temp = sorted_data_4[j];
          sorted_data_4[j] = sorted_data_4[j + 1];
          sorted_data_4[j + 1] = temp;
        end
      end
    end

    // sorted_data_5 정렬
    for (i = 0; i < 5; i = i + 1) begin
      for (j = 0; j < 5 - i; j = j + 1) begin
        if (sorted_data_5[j] > sorted_data_5[j + 1]) begin
          temp = sorted_data_5[j];
          sorted_data_5[j] = sorted_data_5[j + 1];
          sorted_data_5[j + 1] = temp;
        end
      end
    end
  end

  // 정렬된 데이터 출력
  assign sorted_data_out_0 = sorted_data_0;
  assign sorted_data_out_1 = sorted_data_1;
  assign sorted_data_out_2 = sorted_data_2;
  assign sorted_data_out_3 = sorted_data_3;
  assign sorted_data_out_4 = sorted_data_4;
  assign sorted_data_out_5 = sorted_data_5;
endmodule
*/
/*
module ranker(
  input clk, rst,
  input wire [21:0] a, b, c, d, e, f,
  output reg [2:0] a_rank, b_rank, c_rank, d_rank, e_rank, f_rank
);
  reg ok;
  reg [21:0] scores [5:0];
  reg [7:0] i, j, min_index;

  always @(posedge clk, posedge rst) begin
    if(rst) begin
    scores[0] <= a;
    scores[1] <= b;
    scores[2] <= c;
    scores[3] <= d;
    scores[4] <= e;
    scores[5] <= f;
    ok <= 1;
    end
    else ok <= 0;
  end



  always @(*) begin
    // 변수를 배열에 저장
  if(ok==0) begin
    // 선택 정렬 알고리즘을 사용하여 변수를 비교하고 순위를 매김
    // 첫 번째로 가장 작은 값을 찾음
    for (i = 0; i < 6; i = i + 1) begin
      min_index = i;
      for (j = i + 1; j < 6; j = j + 1) begin
        if (scores[j] < scores[min_index]) begin
          min_index = j;
        end
      end

      // 값 교환
      scores[i] = scores[i] + scores[min_index];
      scores[min_index] = scores[i] - scores[min_index];
      scores[i] = scores[i] - scores[min_index];

      // 순위 업데이트
      case (min_index)
        0: a_rank = i + 1;
        1: b_rank = i + 1;
        2: c_rank = i + 1;
        3: d_rank = i + 1;
        4: e_rank = i + 1;
        5: f_rank = i + 1;
      endcase
    
    end
  end
  end
endmodule

*/












// always @(posedge clk, posedge rst) begin
//   if(rst) order_1 <= 0;
//   else begin
//     if(a>b) order_1 <= order_1 + 1;
//     if(a>c) order_1 <= order_1 + 1;
//     if(a>d) order_1 <= order_1 + 1;
//     if(a>f) order_1 <= order_1 + 1;
//   end
// end
// always @(posedge clk, posedge rst) begin
//   if(rst) order_2 <= 0;
//   else begin
//     if(b>a) order_2 <= order_2 + 1;
//     if(b>c) order_2 <= order_2 + 1;
//     if(b>d) order_2 <= order_2 + 1;
//     if(b>f) order_2 <= order_2 + 1;
//   end
// end