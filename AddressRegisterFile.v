`timescale 1ns / 1ps
module AddressRegisterFile(I, OutCSel, OutDSel, FunSel, RegSel, Clock, OutC, OutD);
    input wire [15:0] I;
    input wire [1:0] OutCSel;
    input wire [1:0] OutDSel;
    input wire [2:0] FunSel;
    input wire [2:0] RegSel;
    input wire Clock;
    output reg [15:0] OutC;
    output reg [15:0] OutD;

    wire [15:0] Q = 16'b0;

    Register  AR(.I(I),.E(~RegSel[1]),.FunSel(FunSel),.Clock(Clock),.Q(Q));
    Register  PC(.I(I),.E(~RegSel[2]),.FunSel(FunSel),.Clock(Clock),.Q(Q));
    Register  SP(.I(I),.E(~RegSel[0]),.FunSel(FunSel),.Clock(Clock),.Q(Q));
    always @(*) begin   
                // Assign output C based on selection signals
            case(OutCSel)
                2'b00: OutC = PC.Q;
                2'b01: OutC = PC.Q;
                2'b10: OutC = AR.Q;
                2'b11: OutC = SP.Q; 
            endcase
            
            // Assign output D based on selection signals
            case(OutDSel)
                2'b00: OutD = PC.Q;
                2'b01: OutD = PC.Q;
                2'b10: OutD = AR.Q;
                2'b11: OutD = SP.Q; 
            endcase
    end


endmodule
