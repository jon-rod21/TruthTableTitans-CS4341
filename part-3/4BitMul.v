module SixteenBitMul(inputA,inputB,result);
parameter k=16;

input [k-1:0]inputA;
input [k-1:0]inputB;
wire [k-1:0] inputA;
wire [k-1:0] inputB;

output [((k)*2-1):0]result;
reg    [((k)*2-1):0] result;

//This module is behavioral, which means I can use if statements and built-in math operations.

always@(*)
begin
 
result=32'b00000000000000000000000000000000;
   result=inputA*inputB;//behavioral multiplier
   
 end

endmodule
