//=================================================================
//
// SixteenBitBuffer
//
// Inputs
// inputA, a 16-bit integer
//
// Output
// outputC, a 16-bit integer
//
//==================================================================

module SixteenBitBuffer(inputA,outputC);
parameter k=16;
input  [k-1:0] inputA;
output [k-1:0] outputC;
wire   [k-1:0] inputA;
reg    [k-1:0] outputC;
reg    [k-1:0] result;

always@(*)
begin
	result= (inputA);
	outputC=result;
end
 
endmodule
