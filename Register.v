`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.03.2024 14:28:08
// Design Name: 
// Module Name: Register
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


module Register(I,E,FunSel,Clock,Q);
    input wire [15:0] I;
    input wire E;
    input wire [2:0] FunSel;
    input wire Clock;
    output reg [15:0] Q;
    
    //reg [15:0] reg_data;
    always @ (posedge Clock)
    
    begin
    if(E)
    begin 
    case(FunSel)
        3'b000: Q <= Q - 16'd1; // Function 0: Decrement
        3'b001: Q <= Q + 16'd1; // Function 1: Increment
        3'b010: Q <= I;      // Function 2: Load
        3'b011: Q <= 16'b0;        // Function 3: Clear
        3'b100: begin
                    Q[15:8] <= 8'b0;
                    Q[7:0] <= I[7:0];
           // Function 4: Clear Q(15-0)
           end
        3'b101: begin
                    Q[7:0] <= I[7:0]; // Write low byte
                    Q[15:8] <= Q[15:8]; // Preserve high byte
                 end
        3'b110: begin
                    Q[7:0] <= Q[7:0]; // Preserve low byte
                    Q[15:8] <= I[7:0]; // Write high byte
                 end
        3'b111: begin
                    Q[15:8] <= {8{I[7]}}; // Sign extend I(7) to Q(15:8)
                    Q[7:0] <= I[7:0]; // Write low byte
                end
   default : Q[15:0] = Q[15:0]; 
   endcase
   end
   else
   begin
   Q[15:0] = Q[15:0];
  end
 end
 
 //assign Q = reg_data;
  
endmodule