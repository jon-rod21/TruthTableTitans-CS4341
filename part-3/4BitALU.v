
//=================================================
//Breadboard
//=================================================
module breadboard(clk,rst,A,B,C,opcode,error);
//----------------------------------
parameter k=16;
input clk; 
input rst;
input [k-1:0] A;
input [k-1:0] B;
input [3:0] opcode;
wire clk;
wire rst;
wire [k-1:0] A;
wire [k-1:0] B;
wire [3:0] opcode;

output [1:0]error;
reg [1:0]error;
//----------------------------------
output [(k*2-1):0] C;
reg [(k*2-1):0] C;
//----------------------------------

//Decoder

//Multiplexer
wire [15:0][(k*2-1):0]channels;
wire [15:0] select;
wire [(k*2-1):0] b;

//Logic
wire [(k-1):0] outputAND; //changed
wire [(k-1):0] outputXOR;
wire [(k-1):0] outputOR;
wire [(k-1):0] outputNOT;
wire [(k-1):0] outputNAND;
wire [(k-1):0] outputXNOR;
wire [(k-1):0] outputNOR;
wire [(k-1):0] outputBUFFER;

//Math
reg mode;
wire lastcarry;
wire [(k-1):0] outputADDSUB;
wire [(k-1):0] outputDIV;
wire [(k-1):0] outputMOD;


wire [(k*2-1):0] outputMULT;


wire AddError;
wire ZeroError;

reg [(k-1):0] regA;
reg [(k-1):0] regB;

reg  [(k*2-1):0] next;
wire [(k*2-1):0] cur;

//----------------------------------------------
DFF ACC1 [31:0] (clk,next,cur);//Accumulator Register
Dec4x16          dec1(opcode,select);
Mux32x16          mux1(channels,select,b);
//----------------------------------------------
SixteenBitMul      mult1(regB,regA,outputMULT);
SixteenBitAddSub addsub1(regB,regA,mode,/**/lastcarry,outputADDSUB,ADDerror);
SixteenBitDiv       div1(regB,regA,outputDIV,ZeroError);
SixteenBitMod       mod1(regB,regA,outputMOD,ZeroError);
//--------------------------------------------
SixteenBitBuffer    buf1(regB,outputBUFFER);
SixteenBitNOT       not1(regB,outputNOT);
//--------------------------------------------
SixteenBitAND       and1(regB,regA,outputAND);
SixteenBitNAND     nand1(regB,regA,outputNAND);
//--------------------------------------------
SixteenBitOR         or1(regB,regA,outputOR);
SixteenBitNOR       nor1(regB,regA,outputNOR);
//--------------------------------------------
SixteenBitXOR       xor1(regB,regA,outputXOR);
SixteenBitXNOR     xnor1(regB,regA,outputXNOR);
//----------------------------------------------
/*
OpCodes
0000 Buffer/NO-OP
0001 Reset/Clear
0010 Addition	 	B+A 
0011 Subtraction	B-A
0100 Multiply		B*A
0101 Divide         B/A
0110 Modulus        B%A    
0111 AND			B&A				
1000 OR             B|A
1001 NOT            !B
1010 XOR			B^A
1011 NAND           !(B&A)
1100 NOR            !(B|A)
1101 XNOR           !(B^A)
1110 Unused         Shift B Left
1111 Unused         Shift B Right
*/

assign channels[ 0]={{k{outputBUFFER[k-1]}},outputBUFFER};
assign channels[ 1]=0;//RESET
assign channels[ 2]={{k{outputADDSUB[k-1]}},outputADDSUB};
assign channels[ 3]={{k{outputADDSUB[k-1]}},outputADDSUB};
assign channels[ 4]=outputMULT;
assign channels[ 5]={{k{outputDIV[k-1]}},outputDIV};
assign channels[ 6]={{k{outputMOD[k-1]}},outputMOD};

assign channels[ 7]={16'b0000000000000000,outputAND};
assign channels[ 8]={16'b0000000000000000,outputOR};
assign channels[ 9]={16'b0000000000000000,outputNOT};
assign channels[10]={16'b0000000000000000,outputXOR};
assign channels[11]={16'b0000000000000000,outputNAND};
assign channels[12]={16'b0000000000000000,outputNOR};
assign channels[13]={16'b0000000000000000,outputXNOR};
assign channels[14]=0;//Not connected, Shift B Left
assign channels[15]=0;//Not connected, Shift B Right 


always @(*)
begin
 mode=0;
 regA= A;
 regB= cur[k-1:0]; //to get the lower bits... //changed here too

if (opcode==3)
mode=1;
else 
mode=0;
  
begin
error={ZeroError,AddError};
end
 
 
  if (opcode==4'b0001)
 begin
   error[0]=0;
   error[1]=0;
 end
 

 assign C=b; 
 assign next=b;
end

endmodule


//=================================================
//TEST BENCH
//=================================================
module testbench();
   parameter k=16;
//Local Variables
   reg  clk;
   reg  rst;
   reg  [k-1:0] inputA;
   reg  [k-1:0] inputB;
   wire [(k*2-1):0] outputC;
   reg  [3:0] opcode;
   reg [15:0] count;
   wire [1:0] error;

// create breadboard
breadboard bb8(clk,rst,inputA,inputB,outputC,opcode,error);


//=================================================
 //CLOCK Thread
 //=================================================
   initial begin //Start Clock Thread
     forever //While TRUE
        begin //Do Clock Procedural
		
		
		
		
          clk=0; //square wave is low
          #5; //half a wave is 5 time units
          clk=1;//square wave is high
          #5; //half a wave is 5 time units
		  $display("Tick");
   
/*   
	$display("ACC.out            %b",
	{
	bb8.ACC1[7].out,
	bb8.ACC1[6].out,
	bb8.ACC1[5].out,
	bb8.ACC1[4].out,
	bb8.ACC1[3].out,
	bb8.ACC1[2].out,
	bb8.ACC1[1].out,
	bb8.ACC1[0].out
	});
	
	$display("ACC.in            %b",
	{
	bb8.ACC1[7].in,
	bb8.ACC1[6].in,
	bb8.ACC1[5].in,
	bb8.ACC1[4].in,
	bb8.ACC1[3].in,
	bb8.ACC1[2].in,
	bb8.ACC1[1].in,
	bb8.ACC1[0].in
	});
	
	
	//regB,regA,mode,lastcarry,outputADDSUB,ADDerror
	
	$display("next        %b",bb8.next);
	$display("cur         %b",bb8.cur);
	$display("regB         %b",bb8.regB);
	$display("regA         %b",bb8.regA);
	$display("mode         %b",bb8.mode);
	$display("outputADDSUB %b",bb8.outputADDSUB);
	$display("channel[2] %b",bb8.channels[2]);
    $display("==================================================");
*/	
	   end
    end



//=================================================
// Display Thread
//=================================================
    initial begin //Start Output Thread
	forever
         begin
 
		 case (opcode)
		 0: $display("%8b ==>  %8b         , NO-OP",bb8.cur,bb8.b);
		 1: $display("%8b ==>  %8b         , RESET",4'b0000,bb8.b);
		 2: $display("%8b  +   %8b  = %8b  , ADD"  ,bb8.cur,inputA,bb8.b);
         3: $display("%8b  -   %8b  = %8b  , SUB"  ,bb8.cur,inputA,bb8.b);
		 4: $display("%8b  *   %8b  = %8b  , MULT"  ,bb8.cur,inputA,bb8.b);
		 5: $display("%8b  /   %8b  = %8b  , DIV"  ,bb8.cur,inputA,bb8.b);
 		 6: $display("%8b  %%   %8b  = %8b , MOD"  ,bb8.cur,inputA,bb8.b);
         7: $display("%8b AND  %8b  = %8b  , AND"  ,bb8.cur,inputA,bb8.b);
         8: $display("%8b OR   %8b  = %8b  , OR"  ,bb8.cur,inputA,bb8.b);
		 9: $display("%8b NOT       = %8b  , NOT"  ,bb8.cur,     bb8.b);
		 10:$display("%8b XOR  %8b  = %8b  , XOR"  ,bb8.cur,inputA,bb8.b);
		 11:$display("%8b NAND %8b  = %8b  , NAND"  ,bb8.cur,inputA,bb8.b);
         12:$display("%8b NOR  %8b  = %8b  , NOR"  ,bb8.cur,inputA,bb8.b);
         13:$display("%8b XNOR %8b  = %8b  , XNOR"  ,bb8.cur,inputA,bb8.b);
         14:$display("Placeholder");
         15:$display("Placeholder");
		 endcase
		 
		 $write("[%b]",error);
		 case (error)
		 0: $display("No Error");
		 1: $display("[Overflow]");
		 2: $display("[Divide by Zero]");
		 3: $display("[Divide by Zero][Overflow]");
		 default: $display("[Bug]");
		 endcase
		 
		 #10;
		 end
	end
	

//=================================================
//STIMULOUS Thread
//=================================================
	initial begin//Start Stimulous Thread
	#6;


//========================================	
//Kinetic Energy: K = 1/2 * m * v * v
//m = 10 , v = 20
//K = 2000
//========================================
	
 	//---------------------------------
	inputA=16'b0000000000000000;
	opcode=4'b0001;//RESET
	#10
	//---------------------------------	
	inputA=16'd20; // v
	opcode=4'b0010;//ADD
	#10;
	//---------------------------------	
	inputA=16'd20; // v
	opcode=4'b0100;//MULTIPLY v * v
	#10
    //---------------------------------
    inputA=16'd10; // m
    opcode=4'b0100;//MULTIPLY m * v * v
    #10
    //---------------------------------
    inputA=16'd2;  // divide by 2
    opcode=4'b0101;//DIVIDE
    #10

//========================================	
//Area of Trapezoid: A = 1/2 * (base1 + base2) * height
//base1 = 30, base2 = 50, height = 26
//A = 96
//========================================
	opcode=4'b0001;//RESET
	#10;
    //---------------------------------
    inputA=16'd30; // base1
	opcode=4'b0010;//ADD
	#10;
    //---------------------------------
    inputA=16'd50; // base2
	opcode=4'b0010;//ADD
	#10;
    //---------------------------------
    inputA=16'd26; // height
	opcode=4'b0100; //MULTIPLY
	#10;
    //---------------------------------
    inputA=16'd2; // divide by 2
	opcode=4'b0101; //DIVIDE
	#10;

//========================================	
//Final Velocity: V = u - at
//u = 12345, a = 293, t = 7
//V = 10294
//========================================
	opcode=4'b0001;//RESET
	#10;
    //---------------------------------
	inputA=16'b0000000100100101; // a
	opcode=4'b0010;//ADD
	#10;
    //---------------------------------
	inputA=16'b0000000000000111;   // t
	opcode=4'b0100;//MULTIPLY
	#10;
    //---------------------------------
	opcode=4'b1001;//NOT
	#10;
    //---------------------------------
    inputA=16'd1;
	opcode=4'b0010;//ADD
	#10;
    //---------------------------------
	inputA=16'b0011000000111001;// u
	opcode=4'b0010;//ADD
	#10;
	
//========================================	
//Perimeter of Rectangle: P = 2(l + w)
//l = 125, w = 87
//========================================
    opcode=4'b0001;//RESET
    #10;
    inputA=16'd125; // l
    opcode=4'b0010;//ADD
    #10;
    inputA=16'd87; // w
    opcode=4'b0010;//ADD 
    #10;
    inputA=16'd2;
    opcode=4'b0100;//MULTIPLY (Result: 424)
    #10;	
//========================================	
//Mod 42381 % 9257 - 33
//========================================
	opcode=4'b0001;//RESET
	#10;
	inputA=16'b1010010110001101;//Add 42381
	opcode=4'b0010;
	#10;
	inputA=16'b0010010000101001;//Mod by 9257
	opcode=4'b0110;
	#10;
	inputA=16'b0000000000100001;//Subtract 33
	opcode=4'b0011;//SUB
	#10;
	
//========================================	
//AND 50250 and 15807
//========================================
	opcode=4'b001;//RESET
	#10;
	inputA=16'b1100010001001010;
	opcode=4'b0010;
	#10
	inputA=16'b0011110110111111;
	opcode=4'b0111;//AND
	#10;
	
	
//========================================	
//OR 50250 and 15807
//========================================
	opcode=4'b001;//RESET
	#10;
	inputA=16'b1100010001001010;
	opcode=4'b0010;
	#10
	inputA=16'b0011110110111111;
	opcode=4'b1000;//OR 1111
	#10;

//========================================
//NOT 50250 and 15807
//========================================
	opcode=4'b001;//RESET
	#10;
	inputA=16'b1100010001001010;
	opcode=4'b0010;
	#10
	opcode=4'b1001;//NOT
	#10;
	
//========================================	
//XOR 50250 and 15807
//========================================
	opcode=4'b001;//RESET
	#10;
	inputA=16'b1100010001001010;
	opcode=4'b0010;
	#10
	inputA=16'b0011110110111111;
	opcode=4'b1010;//XOR
	#10;

//========================================
//NAND 50250 and 15807
//========================================
	opcode=4'b001;//RESET
	#10;
	inputA=16'b1100010001001010;
	opcode=4'b0010;
	#10
	inputA=16'b0011110110111111;
	opcode=4'b1011;//NAND
	#10;
	
//========================================
//NOR 50250 and 15807
//========================================
	opcode=4'b001;//RESET
	#10;
	inputA=16'b1100010001001010;
	opcode=4'b0010;
	#10
	inputA=16'b0011110110111111;
	opcode=4'b1100;//NOR
	#10;
	
//========================================	
//XNOR 50250 and 15807
//========================================
	opcode=4'b001;//RESET
	#10;
	inputA=16'b1100010001001010;
	opcode=4'b0010;
	#10
	inputA=16'b0011110110111111;
	opcode=4'b1101;//XNOR
	#10;				
//========================================	
//Divide by Zero
//========================================
 
	opcode=4'b001;//RESET
	#10;
	inputA=16'b1100010001001010;
	opcode=4'b0010;
	#10
	inputA=16'b0000000000000000;
	opcode=4'b0101;//Divide
	#10;
 
//========================================	
//Overflow
//========================================
	opcode=4'b0001;//RESET
	#10;
	inputA=16'b0111111111111111;
	opcode=4'b0010;
	#10
	inputA=16'b0111111111111111;
	opcode=4'b0010;
	#10;				
							
	$finish;
	end

endmodule
