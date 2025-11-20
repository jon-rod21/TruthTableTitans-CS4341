module SixteenBitDiv(inputA,inputB,result,err);
parameter k=16;

input [k-1:0]inputA;
input [k-1:0]inputB;
wire [k-1:0] inputA;
wire [k-1:0] inputB;

output [k-1:0]result;
output err;
reg [k-1:0] result;
reg err;

//This module is behavioral, which means I can use if statements and built-in math operations.

always@(*)
begin
 
   assign err=0;

   if (inputB==0)
      begin
	     assign err=1;
      end
 
   result=inputA/inputB;//behavioral divisor
   
 end

endmodule
