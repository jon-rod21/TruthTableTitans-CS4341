
//=================================================
//Breadboard
//=================================================
module breadboard(clk,rst,A,B,C,opcode,error);
//----------------------------------
parameter k=4;
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
wire [(k-1):0] outputAND;
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
DFF ACC1 [7:0] (clk,next,cur);//Accumulator Register
Dec4x16          dec1(opcode,select);
Mux16x8          mux1(channels,select,b);
//----------------------------------------------
FourBitMul      mult1(regB,regA,outputMULT);
FourBitAddSub addsub1(regB,regA,mode,/**/lastcarry,outputADDSUB,ADDerror);
FourBitDiv       div1(regB,regA,outputDIV,ZeroError);
FourBitMod       mod1(regB,regA,outputMOD,ZeroError);
//----------------------------------------------
FourBitBuffer    buf1(regB,outputBUFFER);
FourBitNOT       not1(regB,outputNOT);
//----------------------------------------------
FourBitAND       and1(regB,regA,outputAND);
FourBitNAND     nand1(regB,regA,outputNAND);
//----------------------------------------------
FourBitOR         or1(regB,regA,outputOR);
FourBitNOR       nor1(regB,regA,outputNOR);
//----------------------------------------------
FourBitXOR       xor1(regB,regA,outputXOR);
FourBitXNOR     xnor1(regB,regA,outputXNOR);
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

assign channels[ 7]={4'b0000,outputAND};
assign channels[ 8]={4'b0000,outputOR};
assign channels[ 9]={4'b0000,outputNOT};
assign channels[10]={4'b0000,outputXOR};
assign channels[11]={4'b0000,outputNAND};
assign channels[12]={4'b0000,outputNOR};
assign channels[13]={4'b0000,outputXNOR};
assign channels[14]=0;//Not connected, Shift B Left
assign channels[15]=0;//Not connected, Shift B Right 


always @(*)
begin
 mode=0;
 regA= A;
 regB= cur[k-1:0]; //to get the lower bits...

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
   parameter k=4;
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
//Add 2+2
//========================================
	
 	//---------------------------------
	inputA=4'b0000;
	opcode=4'b0001;//RESET
	#10
	//---------------------------------	
	inputA=4'b0010;
	opcode=4'b0010;//ADD
	#10;
	//---------------------------------	
	inputA=4'b0010;
	opcode=4'b0010;//ADD
	#10

//========================================	
//Subtract 5 from 3
//========================================
	opcode=4'b0001;//RESET
	#10;
	inputA=4'b0011;//Add 3
	opcode=4'b0010;
	#10;
	inputA=4'b0101;//Sub 5
	opcode=4'b0011;
	#10;

//========================================	
//Multiply 5x3
//========================================
	opcode=4'b0001;//RESET
	#10;
	inputA=4'b0101;//Add 5
	opcode=4'b0010;
	#10;
	inputA=4'b0011;//Mult by 3
	opcode=4'b0100;
	#10;
	
//========================================	
//Divide 7 by 3
//========================================
	opcode=4'b0001;//RESET
	#10;
	inputA=4'b0111;//Add 5
	opcode=4'b0010;
	#10;
	inputA=4'b0011;//Div by 3
	opcode=4'b0101;
	#10;
	
//========================================	
//Mod 7 by 3
//========================================
	opcode=4'b0001;//RESET
	#10;
	inputA=4'b0111;//Add 5
	opcode=4'b0010;
	#10;
	inputA=4'b0011;//Div by 3
	opcode=4'b0110;
	#10;
	
//========================================	
//AND 1010 and 1110
//========================================
	opcode=4'b001;//REST
	#10;
	inputA=4'b1010;
	opcode=4'b0010;//add 1010
	#10
	inputA=4'b1111;
	opcode=4'b0111;//AND 1111
	#10;
	
//========================================	
//AND 1010 and 1110
//========================================
	opcode=4'b001;//RESET
	#10;
	inputA=4'b1010;
	opcode=4'b0010;//add 1010
	#10
	inputA=4'b1111;
	opcode=4'b1000;//OR 1111
	#10;
	
//========================================	
//OR 1010 and 1110
//========================================
	opcode=4'b001;//RESET
	#10;
	inputA=4'b1010;
	opcode=4'b0010;//add 1010
	#10
	inputA=4'b1111;
	opcode=4'b1000;//OR 1111
	#10;

//========================================
//NOT
//========================================
	opcode=4'b001;//RESET
	#10;
	inputA=4'b1010;
	opcode=4'b0010;//add 1010
	#10
	opcode=4'b1001;//NOT
	#10;
	
//========================================	
//NAND
//========================================
	opcode=4'b001;//RESET
	#10;
	inputA=4'b1010;
	opcode=4'b0010;//add 1010
	#10
	inputA=4'b1111;
	opcode=4'b1010;//XOR
	#10;

//========================================
//NAND
//========================================
	opcode=4'b001;//RESET
	#10;
	inputA=4'b1010;
	opcode=4'b0010;//add 1010
	#10
	inputA=4'b0000;
	opcode=4'b1011;//NAND
	#10;
	
//========================================
//NOR
//========================================
	opcode=4'b001;//RESET
	#10;
	inputA=4'b1010;
	opcode=4'b0010;//add 1010
	#10
	inputA=4'b1111;
	opcode=4'b1100;//NOR
	#10;
	
//========================================	
//XNOR
//========================================
	opcode=4'b001;//RESET
	#10;
	inputA=4'b1010;
	opcode=4'b0010;//add 1010
	#10
	inputA=4'b1010;
	opcode=4'b1101;//XNOR
	#10;				
//========================================	
//Divide by Zero
//========================================
 
	opcode=4'b001;//RESET
	#10;
	inputA=4'b0111;
	opcode=4'b0010;//add 1010
	#10
	inputA=4'b0000;
	opcode=4'b0101;//Divide
	#10;
 
//========================================	
//Overflow
//========================================
	opcode=4'b0001;//RESET
	#10;
	inputA=4'b0111;
	opcode=4'b0010;//Add
	#10
	inputA=4'b0111;
	opcode=4'b0010;//ADD
	#10;				
							
	$finish;
	end

endmodule
