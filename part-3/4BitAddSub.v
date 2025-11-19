module FourBitAddSub(inputA,inputB,mode,carry,sum,overflow);
	parameter k=16;
    input [k-1:0] inputA;
	input [k-1:0] inputB;
    input mode;
	output carry;
    output [k-1:0] sum;
    output overflow;
 

    wire [k-1:0] xorInterface; //XOR Interfaces
	wire [k-1:0] carryInterface; //Carry Interfaces
	
	assign xorInterface={(k){mode}}^inputB;
	
//             A Bit      Flipped Bit      CarryN		 	  Carry N+1          Sum S
FullAdder FA00(inputA[ 0],xorInterface[ 0],              mode,carryInterface[ 0],sum[ 0]);
FullAdder FA01(inputA[ 1],xorInterface[ 1],carryInterface[ 0],carryInterface[ 1],sum[ 1]);
FullAdder FA02(inputA[ 2],xorInterface[ 2],carryInterface[ 1],carryInterface[ 2],sum[ 2]);
FullAdder FA03(inputA[ 3],xorInterface[ 3],carryInterface[ 2],carryInterface[ 3],sum[ 3]);
FullAdder FA04(inputA[ 4],xorInterface[ 4],carryInterface[ 3],carryInterface[ 4],sum[ 4]);
FullAdder FA05(inputA[ 5],xorInterface[ 5],carryInterface[ 4],carryInterface[ 5],sum[ 5]);
FullAdder FA06(inputA[ 6],xorInterface[ 6],carryInterface[ 5],carryInterface[ 6],sum[ 6]);
FullAdder FA07(inputA[ 7],xorInterface[ 7],carryInterface[ 6],carryInterface[ 7],sum[ 7]);
FullAdder FA08(inputA[ 8],xorInterface[ 8],carryInterface[ 7],carryInterface[ 8],sum[ 8]);
FullAdder FA09(inputA[ 9],xorInterface[ 9],carryInterface[ 8],carryInterface[ 9],sum[ 9]);
FullAdder FA10(inputA[ 10],xorInterface[ 10],carryInterface[ 9],carryInterface[ 10],sum[ 10]);
FullAdder FA11(inputA[ 11],xorInterface[ 11],carryInterface[ 10],carryInterface[ 11],sum[ 11]);
FullAdder FA12(inputA[ 12],xorInterface[ 12],carryInterface[ 11],carryInterface[ 12],sum[ 12]);
FullAdder FA13(inputA[ 13],xorInterface[ 13],carryInterface[ 12],carryInterface[ 13],sum[ 13]);
FullAdder FA14(inputA[ 14],xorInterface[ 14],carryInterface[ 13],carryInterface[ 14],sum[ 14]);
FullAdder FA15(inputA[ 15],xorInterface[ 15],carryInterface[ 14],carryInterface[ 15],sum[ 15]);
 
 	
	assign carry=carryInterface[k-1];
	assign overflow=(carryInterface[k-1])^(carryInterface[k-2]);
 	
 
endmodule


 /*
//===============================================
module testbenchAddSub();

reg [3:0] a,b;
reg mode;
wire carry;
wire [3:0] sum;
wire overflow;

FourBitAddSub fbas(a,b,mode,carry,sum,overflow);

initial begin

a=4'b0001;
b=4'b0001;
mode=0;
#10;
$display("%b|%b|%b|%b|%b|%b",a,b,mode,carry,sum,overflow);
	$write(fbas.carryInterface[3]);
	$write(fbas.carryInterface[2]);
	$write(fbas.carryInterface[1]);
	$write(fbas.carryInterface[0]);
	
	$display();
	
a=4'b0001;
b=4'b0001;
mode=1;
#10;

a=4'b0011;
b=4'b0010;
mode=0;
#10;
$display("%b|%b|%b|%b|%b|%b",a,b,mode,carry,sum,overflow);
	$write(fbas.carryInterface[3]);
	$write(fbas.carryInterface[2]);
	$write(fbas.carryInterface[1]);
	$write(fbas.carryInterface[0]);
 
	$display();
	
a=4'b0111;
b=4'b0111;
mode=0;
#10;
$display("%b|%b|%b|%b|%b|%b",a,b,mode,carry,sum,overflow);

	$write(fbas.carryInterface[3]);
	$write(fbas.carryInterface[2]);
	$write(fbas.carryInterface[1]);
	$write(fbas.carryInterface[0]);
 
	$display();
$finish;

end


endmodule
 
*/
