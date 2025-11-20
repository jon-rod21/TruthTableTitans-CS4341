//=================================================================
//
// SixteenBitXNOR
//
// Inputs
// inputA, a 16-bit integer
// inputB, a 16-bit integer
//
// Output
// outputC, a 16-bit integer
//
//==================================================================

module SixteenBitXNOR(inputA,inputB,outputC);
parameter k=16;
input  [k-1:0] inputA;
input  [k-1:0] inputB;
output [k-1:0] outputC;
wire   [k-1:0] inputA;
wire   [k-1:0] inputB;
reg    [k-1:0] outputC;

reg    [k-1:0] result;

always@(*)
begin
	result=~(inputA^inputB);
	outputC=result;
end
 
endmodule

