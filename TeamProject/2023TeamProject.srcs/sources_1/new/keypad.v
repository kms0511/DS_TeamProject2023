`timescale 1ns / 1ps

module keypad (clk, rst, row, col, keypad_out); 
    input clk, rst; 
    input [3:0] row; 
    output reg [3:0] col; 
    output reg [4:0] keypad_out; 

    reg [31:0] sclk; 
    reg pressed;
    
    parameter CLK_KHZ = 25175; 

    always @(posedge clk, posedge rst) begin
        if (rst) begin
		      sclk <= 0; 
		      col <= 0; 
		      keypad_out <= 0;
		      pressed <= 0;
		end  
		else begin
			// 1ms
			if (sclk == CLK_KHZ) begin    // 1ms
				col <= 4'b0111;	//C1
				sclk <= sclk+1;
		    end
			// check row pins
			else if (sclk == CLK_KHZ+8) begin	 // 1ms + 8clk
				if (row == 4'b0111) begin //R1
					keypad_out <= 5'b10001;	//1
                    pressed <= 1; 
				end 
				else if (row == 4'b1011) begin //R2
					keypad_out <= 5'b10100; //4
                    pressed <= 1;				
                end	
				else if (row == 4'b1101) begin //R3
					keypad_out <= 5'b10111; //7
                    pressed <= 1;					
				end
				else if (row == 4'b1110) begin //R4
					keypad_out <= 5'b10000; //0
                    pressed <= 1;					
				end
				sclk <= sclk+1;
		    end 
			else if (sclk == CLK_KHZ*2) begin	 // 2ms
				col<= 4'b1011; //C2
				sclk <= sclk+1;
			end
			// check row pins
			else if (sclk == CLK_KHZ*2+8) begin	 // 2ms + 8clk
				if (row == 4'b0111) begin //R1		
					keypad_out <= 5'b10010; //2
                    pressed <= 1;
                end					
				else if (row == 4'b1011) begin //R2
					keypad_out <= 5'b10101; //5
                    pressed <= 1;					
				end
				else if (row == 4'b1101) begin //R3
					keypad_out <= 5'b11000; //8
                    pressed <= 1;					
				end
				else if (row == 4'b1110) begin //R4
					keypad_out <= 5'b11111; //F
                    pressed <= 1;					
				end
				sclk <= sclk+1;
		    end	
			else if (sclk == CLK_KHZ*3) begin // 3ms
				col <= 4'b1101; //C3
				sclk <= sclk+1;
		    end
			// check row pins
			else if (sclk == CLK_KHZ*3+8) begin // 3ms + 8clk
				if (row == 4'b0111) begin //R1
					keypad_out <= 5'b10011; //3
                    pressed <= 1;
                end					
				else if (row == 4'b1011) begin //R2
					keypad_out <= 5'b10110; //6
                    pressed <= 1;
                end					
				else if (row == 4'b1101) begin //R3
					keypad_out <= 5'b11001; //9
                    pressed <= 1;
                end					
				else if (row == 4'b1110) begin //R4
					keypad_out <= 5'b11110; //E
                    pressed <= 1;
                end					
				sclk <= sclk+1;
		    end
			else if (sclk == CLK_KHZ*4) begin // 4ms
				col <= 4'b1110; //C4
				sclk <= sclk+1;
		    end
			// check row pins
			else if (sclk == CLK_KHZ*4+8) begin  // 4ms + 8clk
				if (row == 4'b0111) begin //R1
					keypad_out <= 5'b11010; //A
                    pressed <= 1;
                end					
				else if (row == 4'b1011) begin //R2
					keypad_out <= 5'b11011; //B
                    pressed <= 1;
                end					
				else if (row == 4'b1101) begin //R3
					keypad_out <= 5'b11100; //C
                    pressed <= 1;
                end					
				else if (row == 4'b1110) begin //R4
					keypad_out <= 5'b11101; //D
                    pressed <= 1;
                end					
				sclk <= sclk+1;
		    end
			else if (sclk == CLK_KHZ*4+9) begin  // 4ms + 9clk            
                if (pressed == 0) keypad_out <= 0;  
				pressed <= 0;
				sclk <= 0;
			end
			else
				sclk <= sclk+1;
         end
     end
endmodule