`timescale 1ns / 1ps
module ArithmeticLogicUnitSystem(RF_OutASel, RF_OutBSel, RF_FunSel, RF_RegSel, RF_ScrSel, ALU_FunSel,ALU_WF, ARF_OutCSel,ARF_OutDSel, ARF_FunSel, ARF_RegSel,IR_LH, IR_Write,Mem_WR, Mem_CS, MuxASel, MuxBSel, MuxCSel, Clock);
input wire [2:0] RF_OutASel;
input wire [2:0] RF_OutBSel;
input wire [2:0] RF_FunSel;
input wire [3:0] RF_RegSel;
input wire [3:0] RF_ScrSel;
input wire [4:0] ALU_FunSel;
input wire ALU_WF;
input wire [1:0] ARF_OutCSel;
input wire [1:0] ARF_OutDSel;
input wire [2:0] ARF_FunSel;
input wire [2:0] ARF_RegSel;
input wire IR_LH;
input wire IR_Write;
input wire Mem_WR;
input wire Mem_CS;
input wire [1:0] MuxASel;
input wire [1:0] MuxBSel;
input wire MuxCSel;
input wire Clock;


    wire [15:0] OutA;
    wire [15:0] OutB;
    wire [15:0] ALUOut;
    wire [7:0] MemOut;
    wire [15:0] IROut;
    wire [3:0] Flags;
    reg [15:0] MuxAOut;
    reg [15:0] MuxBOut;
    reg [7:0] MuxCOut;
    wire [15:0] Address;
    wire [15:0] OutC;
    
    
    RegisterFile RF(MuxAOut,RF_OutASel,RF_OutBSel,RF_FunSel, RF_RegSel,RF_ScrSel,Clock,OutA,OutB);
    ArithmeticLogicUnit ALU(OutA, OutB, ALU_FunSel, ALU_WF, Clock, ALUOut,Flags);
    Memory MEM(Address, MuxCOut, Mem_WR, Mem_CS, Clock,MemOut);
    InstructionRegister IR(MemOut,IR_Write,IR_LH,Clock,IROut);
    AddressRegisterFile ARF(MuxBOut,ARF_OutCSel,ARF_OutDSel,ARF_FunSel,ARF_RegSel,Clock,OutC,Address);

        
    always @(*)begin
        case(MuxASel)
            2'b00: MuxAOut = ALUOut;
            2'b01: MuxAOut = OutC;
            2'b10:begin
            MuxAOut[7:0] = MemOut;
            MuxAOut[15:8] = 8'd0;
            end
            2'b11:begin
            MuxAOut[7:0] = IROut[7:0];
            MuxAOut[15:8] = 8'd0;
            end
        endcase
        case(MuxBSel)
            2'b00: MuxBOut = ALUOut;
            2'b01: MuxBOut = OutC;
            2'b10: MuxBOut = MemOut;
            2'b11: MuxBOut = IROut;
        endcase
        case(MuxCSel)
            1'b0: MuxCOut = ALUOut[7:0];
            1'b1: MuxCOut = OutC[15:8];
 
         endcase
    end

endmodule