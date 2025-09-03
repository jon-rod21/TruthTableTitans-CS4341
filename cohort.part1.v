// Using Icarus/IVerilog on Vim

module Breadboard	(w,x,y,z,r1,r2,r3);  //Module Header
input w,x,y,z;                           //Specify inputs
output r1, r2, r3;                       //Specify outputs
reg r1,r2,r3;                            //Output is a memory area.
wire w,x,y,z;

always @ ( w,x,y,z,r1,r2,r3) begin       //Create a set of code that works line by line 
                                         //when these variables are used

//x+y'z                                  //Comment for the formula
r1= (x)|((~y)&z);                        //Bitwise operation of the formula

//Demorgan's							 //Comment for the formula
r2= ~(~(~y&z)&(~x));

//wxyz+w'x'y'z'
r3= (w&x&y&z)|(~w&~x&~y&~z);
	

end                                       // Finish the Always block

endmodule                                 //Module End

//----------------------------------------------------------------------
module testbench();

  //Registers act like local variables
  reg [4:0] i; //A loop control for 16 rows of a truth table.
  reg  a;//Value of 2^3
  reg  b;//Value of 2^2
  reg  c;//Value of 2^1
  reg  d;//Value of 2^0
  
  //A wire can hold the return of a function
  wire  f1,f2,f3;
  
  //Modules can be either functions, or model chips. 
  //They are instantiated like an object of a class, 
  //with a constructor with parameters.  They are not invoked,
  //but operate like a thread.
  Breadboard bb8(a,b,c,d,f1,f2,f3);
 
     
	 
  //Initial means "start," like a Main() function.
  //Begin denotes the start of a block of code.	
  initial begin
   	
  //$display acts like a java System.println command.
  $display ("|##|A|B|C|D|F1|F2|F3|");
  $display ("|==+=+=+=+=+==+==+==|");
  
    //A for loop, with register i being the loop control variable.
	for (i = 0; i <=15; i = i + 1) 
	begin//Open the code block of the for loop
		a=(i/8)%2;//High bit
		b=(i/4)%2;
		c=(i/2)%2;
		d=(i/1)%2;//Low bit	
		 
		//Oh, Dr. Becker, do you remember what belongs here? 
		#5;
 
		 	
		$display ("|%2d|%1d|%1d|%1d|%1d| %1d| %1d| %1d|",i,a,b,c,d,f1,f2,f3);
		if(i%4==3) //Every fourth row of the table, put in a marker for easier reading.
		 $write ("|--+-+-+-+-+--+--+--|\n");//Write acts a bit like a java System.print

	end//End of the for loop code block
 
	#10; //A time delay of 10 time units. Hashtag Delay
	$finish;//A command, not unlike System.exit(0) in Java.
  end  //End the code block of the main (initial)
  
endmodule //Close the testbench module































//Dr. Becker's cheat sheet of what is wrong in the code.
//The loop control variable can never reach 16, it is only 4 bits. Add another bit
//There needs to be a time dealy, such a #5, inside the for loop
