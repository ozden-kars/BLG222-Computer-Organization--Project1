`timescale 1ns / 1ps
module ArithmeticLogicUnit(A, B,FunSel, WF, Clock, ALUOut, FlagsOut);
    input wire [15:0] A;
    input wire [15:0] B;
    input wire [4:0] FunSel;
    input wire WF;
    input wire Clock;
    output reg [15:0] ALUOut;
    output reg [3:0] FlagsOut;

 // Internal signals
    reg [16:0] temp; // To handle overflow
    reg Zero = 1'b0;
    reg Negative = 1'b0;
    reg Carry = 1'b0;
    reg Overflow = 1'b0;
    wire [7:0] A_8bit;
    wire [7:0] B_8bit;
    assign A_8bit = A[7:0];
    assign B_8bit = B[7:0];
    
    always @(*) begin
        if(FunSel[4] == 0) begin
        case(FunSel)
            5'b00000: begin // A
                temp[7:0] = A_8bit;
                temp[15:8] = 8'd0;
                Zero = (temp[7:0] == 0);
                Negative = temp[7];
            end
            5'b00001: begin // B
                temp[7:0] = B_8bit;
                temp[15:8] = 8'd0;
                Zero = (temp[7:0] == 0);
                Negative = temp[7];
            end
            5'b00010: begin // A NOT
                temp[7:0] = ~A_8bit;
                temp[15:8] = 8'd0;
                Zero = (temp[7:0] == 0);
                Negative = temp[7];

            end
            5'b00011: begin // B NOT
                temp[7:0] = ~B_8bit;
                temp[15:8] = 8'd0;
                Zero = (temp[7:0] == 0);
                Negative = temp[7];
            end
            5'b00100: begin // ADD
                 temp[8:0] = A_8bit + B_8bit;
                 Zero = (temp[7:0] == 0);
                 Negative = temp[7];
                 Carry = (temp[8] == 1);
                 Overflow = (A_8bit[7] == B_8bit[7] && temp[7] != A_8bit[7]);
                 temp[15:8] = 8'd0;
            end
            5'b00101: begin // ADD WITH CARRY
                temp[8:0] = A_8bit + B_8bit + FlagsOut[2];
                Zero = (temp[7:0] == 0);
                Negative = temp[7];
                Carry = (temp[8] == 1);
                Overflow = (A_8bit[7] == B_8bit[7] && temp[7] != A_8bit[7]);
                temp[15:8] = 8'd0;
            end
            5'b00110: begin // SUBSTRACT
                 temp[8:0] = A_8bit + ~B_8bit + 1'b1;
                 Zero = (temp[7:0] == 0);
                 Negative = temp[7];
                 Carry = (temp[8] == 0); // 0 carry 1 borrow (Carry value is actually borrow in substraction))
                 Overflow = (A_8bit[7] != B_8bit[7] && temp[7] != A_8bit[7]);
                 temp[15:8] = 8'd0;
            end
            5'b00111: begin //AND
                 temp[7:0] = A_8bit & B_8bit;
                 temp[15:8] = 8'd0;
                 Zero = (temp[7:0] == 0);
                 Negative = temp[7];
            end
            5'b01000: begin // OR
                 temp[7:0] = A_8bit | B_8bit;
                 temp[15:8] = 8'd0;
                 Zero = (temp[7:0] == 0);
                 Negative = temp[7];
             end
            5'b01001: begin // XOR
                temp[7:0] = A_8bit ^ B_8bit;
                temp[15:8] = 8'd0;
                Zero = (temp[7:0] == 0);
                Negative = temp[7];
              end
            5'b01010: begin // NAND
                temp[7:0] = ~(A_8bit & B_8bit);
                temp[15:8] = 8'd0;
                Zero = (temp[7:0] == 0);
                Negative = temp[7];
              end
            5'b01011: begin // LSLA
                Carry = A_8bit[7];
                temp[7:0] = A_8bit[7:0] << 1;
                temp[15:8] = 8'd0;
                Zero = (temp[7:0] == 0);
                Negative = temp[7];
              end
            5'b01100: begin // LSRA
                Carry = A_8bit[0];
                temp[7:0] = A_8bit[7:0] >> 1;
                temp[15:8] = 8'd0;
                Zero = (temp[7:0] == 0);
                Negative = temp[7];
             end
            5'b01101: begin // ASRA
                 Carry = A_8bit[0];
                 temp[7:0] = {A_8bit[7], A_8bit[7:1]};
                 temp[15:8] = 8'd0;
                 Zero = (temp[7:0] == 0);
              end
             5'b01110: begin // CSLA
                temp[7:0] = {A_8bit[6:0], A_8bit[6]}; // Shift left and take MSB to LSB
                temp[15:8] = 8'd0;
                Zero = (temp[7:0] == 0);
                Negative = temp[7];
                Carry = A_8bit[7]; // Carry is the MSB before shift
               end
             5'b01111: begin // CSRA
                  temp[7:0] = {A_8bit[0], A_8bit[7:1]}; // Shift right and take LSB to MSB
                  temp[15:8] = 8'd0;
                  Zero = (temp[7:0] == 0);
                  Negative = temp[7];
                  Carry = A_8bit[0]; // Carry is the MSB before shift
                 end                  
            default: begin // Default case
                temp = 16'd1;
                Zero = 1'b0;
                Negative = 1'b0;
                Carry = 1'b0;
                Overflow = 1'b0;
            end
        endcase
        end
        else begin
        case(FunSel)
            5'b10000: begin // A
                temp[15:0] = A;
                Zero = (temp[15:0] == 0);
                Negative = temp[15];
            end
            5'b10001: begin // B
                temp[15:0] = B;
                Zero = (temp[15:0] == 0);
                Negative = temp[15];
            end
            5'b10010: begin // A NOT
                temp[15:0] = ~A;
                Zero = (temp[15:0] == 0);
                Negative = temp[15];

            end
            5'b10011: begin // B NOT
                temp[15:0] = ~B;
                Zero = (temp[15:0] == 0);
                Negative = temp[7];
            end
            5'b10100: begin // ADD
                 temp[16:0] = A + B;
                 Zero = (temp[15:0] == 0);
                 Negative = temp[15];
                 Carry = (temp[16] == 1);
                 Overflow = (A[15] == B[15] && temp[15] != A[15]);
            end
            5'b10101: begin // ADD WITH CARRY
                temp[16:0] = A + B + FlagsOut[2];
                Zero = (temp[15:0] == 0);
                Negative = temp[15];
                Carry = (temp[16] == 1);
                Overflow = (A[15] == B[15] && temp[15] != A[15]);
            end
            5'b10110: begin // SUBSTRACTION
                 temp[16:0] = A + ~B + 1'b1;
                 Zero = (temp[15:0] == 0);
                 Negative = temp[15];
                 Carry = (temp[16] == 0); // 0 carry 1 borrow (Carry value is actually borrow in substraction))
                 Overflow = (A[15] != B[15] && temp[15] != A[15]);
            end
            5'b10111: begin // AND
                 temp[15:0] = A & B;
                 Zero = (temp[15:0] == 0);
                 Negative = temp[15];
            end
            5'b11000: begin // OR
                 temp[15:0] = A | B;
                 Zero = (temp[15:0] == 0);
                 Negative = temp[15];
             end
            5'b11001: begin // XOR
                temp[15:0] = A ^ B;
                Zero = (temp[15:0] == 0);
                Negative = temp[15];
              end
            5'b11010: begin // NAND
                temp[15:0] = ~(A & B);
                Zero = (temp[15:0] == 0);
                Negative = temp[15];
              end
            5'b11011: begin // LSLA
                Carry = A[15];
                temp[15:0] = A[15:0] << 1;
                Zero = (temp[15:0] == 0);
                Negative = temp[15];
              end
            5'b11100: begin // LSRA
                Carry = A[0];
                temp[15:0] = A[15:0] >> 1;
                Zero = (temp[15:0] == 0);
                Negative = temp[15];
             end
            5'b11101: begin // ASRA
                 Carry = A[0];
                 temp[15:0] = {A[15], A[15:1]};
                 Zero = (temp[15:0] == 0);
              end
             5'b11110: begin // CSLA
                temp[15:0] = {A[14:0], A[14]}; // Shift left and take MSB to LSB
                Zero = (temp[15:0] == 0);
                Negative = temp[15];
                Carry = A[15]; // Carry is the MSB before shift
               end
             5'b11111: begin // CSRA
                  temp[15:0] = {A[0], A[15:1]}; // Shift right and take LSB to MSB
                  Zero = (temp[15:0] == 0);
                  Negative = temp[15];
                  Carry = A[0]; // Carry is the MSB before shift
                 end                  
            default: begin // Default case
                temp = 16'd1;
                Zero = 1'b0;
                Negative = 1'b0;
                Carry = 1'b0;
                Overflow = 1'b0;
            end
        endcase
         ALUOut = temp[15:0]; 
       end
    end

    always @(posedge Clock) begin
    if(WF)begin
            FlagsOut[3] = Zero; // Z flag
            FlagsOut[2] = Carry; // C flag
            FlagsOut[1] = Negative; // N flag
            FlagsOut[0] = Overflow; // O flag      
           end 
    end 

endmodule