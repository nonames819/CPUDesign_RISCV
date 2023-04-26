`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/29 10:03:52
// Design Name: 
// Module Name: controller
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


module controller( 
    input   wire        rst_n,
    input   wire[6: 0]  func7,
    input   wire[2: 0]  func3,
    input   wire[6: 0]  opcode,
    input   wire        breq_i,
    input   wire        brlt_i,
    output  reg         pcsel_o,
    output  wire [2:0]  immsel_o,
    output  reg         regwen_o,
    output  reg         asel_o,
    output  reg         bsel_o,
    output  reg [3:0]   alusel_o,
    output  reg         memrw_o,
    output  reg [1:0]   wbsel_o     
);

localparam  I = 3'b000,
            S = 3'b001,
            B = 3'b010,
            U = 3'b011,
            J = 3'b100,
            R = 3'b101;
      
localparam  ADD = 4'b0000,
            SUB = 4'b00001,
            AND = 4'b0010,
            OR  = 4'b0011,
            XOR = 4'b0100,
            SLL = 4'b0101,
            SRL = 4'b0110,
            SRA = 4'b0111,
            LUI = 4'b1000;
            
reg [2:0] optype;

//立即数扩展控制信号
assign immsel_o = optype;

//类型判断
always @ (*) begin
    case (opcode[6:2])
        5'b01100: begin
            optype = R; // R 型
        end
        5'b01101: begin
            optype = U; // U 型
        end
        5'b11011: begin
            optype = J; // J 型
        end
        5'b01000: begin
            optype = S; // S 型
        end
        5'b11000: begin
            optype = B; // B 型
        end
        default: begin
            optype = I; // I 型
        end
    endcase
end

//PC跳转控制信号
always @ (*) begin
    if(optype == B) begin
        case (func3) 
            3'b000: begin
                pcsel_o = (breq_i == 1) ? 1 : 0;
            end
            3'b001: begin
                pcsel_o = (breq_i == 1) ? 0 : 1;
            end
            3'b100: begin
                pcsel_o = (brlt_i == 1) ? 1 : 0;
            end
            3'b101: begin
                pcsel_o = (brlt_i == 1) ? 0 : 1;
            end
            default: begin
                pcsel_o = 0;
            end
        endcase
    end
    else if (optype == J || opcode == 7'b1100111) begin
        pcsel_o = 1;
    end
    else begin
        pcsel_o = 0;
    end
end


//寄存器堆写入控制信号
always @(*) begin
    if (optype == S | optype == B | ~rst_n) begin
        regwen_o = 0;
    end
    else begin
        regwen_o = 1;
    end
end

//A操作数选择信号
always @(*) begin
    if (optype == J | optype == B) begin
        asel_o = 1;     //PC
    end
    else begin
        asel_o = 0;     //data1    
    end
end

//B操作数选择信号
always @(*) begin
    if (optype == R) begin
        bsel_o = 0;     //data2
    end
    else begin
        bsel_o = 1;     //imm  
    end
end

//ALU运算选择信号
always @ (*) begin
    if (optype == U) begin
        alusel_o = LUI;
    end
    else if (optype == R && func3 == 3'b000 && func7[5] == 1'b1) begin
        alusel_o = SUB;
    end 
    else if ((optype == R || optype==I) && func3 == 3'b111) begin
        alusel_o = AND;
    end 
    else if ((optype == R || optype==I) && func3 == 3'b110) begin
        alusel_o = OR;
    end 
    else if ((optype == R || optype==I) && func3 == 3'b100) begin
        alusel_o = XOR;
    end 
    else if ((optype == R || optype==I) && func3 == 3'b001) begin
        alusel_o = SLL;
    end 
    else if ((optype == R || optype==I) && func3 == 3'b101 && func7[5] == 1'b0) begin
        alusel_o = SRL;
    end 
    else if ((optype == R || optype==I) && func3 == 3'b101 && func7[5] == 1'b1) begin
        alusel_o = SRA;
    end
    else begin
        alusel_o = ADD;
    end
end

//RAM读写控制信号
always @(*) begin
    if (~rst_n) begin
        memrw_o = 0;
    end
    else if (optype == S) begin
        memrw_o = 1;     //写
    end
    else begin
        memrw_o = 0;     //读  
    end
end

//WB模块写回选择信号           
always @(*) begin
    if (~rst_n) begin
        wbsel_o = 2'b01;
    end
    else if (opcode == 7'b0000011) begin
        wbsel_o = 2'b10;    //MEM
    end
    else if (optype == J || opcode == 7'b1100111) begin
        wbsel_o = 2'b00;    //PC+4
    end
    else begin 
        wbsel_o = 2'b01;    //ALU
    end
end



endmodule
