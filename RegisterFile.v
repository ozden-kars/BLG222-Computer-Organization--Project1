`timescale 1ns / 1ps

module RegisterFile(I, OutASel, OutBSel, FunSel, RegSel, ScrSel, Clock, OutA, OutB);
    input wire [15:0] I;
    input wire [2:0] OutASel;
    input wire [2:0] OutBSel;
    input wire [2:0] FunSel;
    input wire [3:0] RegSel;
    input wire [3:0] ScrSel;
    input wire Clock;
    output reg [15:0] OutA;
    output reg [15:0] OutB;
    
    wire [15:0] Q = 16'b0;


            Register  R1(.I(I),.E(~RegSel[3]),.FunSel(FunSel),.Clock(Clock),.Q(Q));
            Register  R2(.I(I),.E(~RegSel[2]),.FunSel(FunSel),.Clock(Clock),.Q(Q));
            Register  R3(.I(I),.E(~RegSel[1]),.FunSel(FunSel),.Clock(Clock),.Q(Q));
            Register  R4(.I(I),.E(~RegSel[0]),.FunSel(FunSel),.Clock(Clock),.Q(Q));
            Register  S1(.I(I),.E(~ScrSel[3]),.FunSel(FunSel),.Clock(Clock),.Q(Q));
            Register  S2(.I(I),.E(~ScrSel[2]),.FunSel(FunSel),.Clock(Clock),.Q(Q));
            Register  S3(.I(I),.E(~ScrSel[1]),.FunSel(FunSel),.Clock(Clock),.Q(Q));
            Register  S4(.I(I),.E(~ScrSel[0]),.FunSel(FunSel),.Clock(Clock),.Q(Q));
            always @(*) begin
            case(OutASel)
                3'b000: OutA <= R1.Q;
                3'b001: OutA <= R2.Q;
                3'b010: OutA <= R3.Q;
                3'b011: OutA <= R4.Q;
                3'b100: OutA <= S1.Q;
                3'b101: OutA <= S2.Q;
                3'b110: OutA <= S3.Q;
                3'b111: OutA <= S4.Q;
            endcase
            case(OutBSel)
                 3'b000: OutB <= R1.Q;
                 3'b001: OutB <= R2.Q;
                 3'b010: OutB <= R3.Q;
                 3'b011: OutB <= R4.Q;
                 3'b100: OutB <= S1.Q;
                 3'b101: OutB <= S2.Q;
                 3'b110: OutB <= S3.Q;
                 3'b111: OutB <= S4.Q;                 
             endcase
       end
  

endmodule




