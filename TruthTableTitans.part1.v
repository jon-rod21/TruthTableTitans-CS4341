// Using Icarus/IVerilog on NeoVim

module Breadboard	(w, x, y, z, r0, r1, r2, r3, r4, r5, r6, r7, r8, r9);  //Module Header
input w, x, y, z;                           //Specify inputs
output r0, r1, r2, r3, r4, r5, r6, r7, r8, r9;                       //Specify outputs
reg r0, r1, r2, r3, r4, r5, r6, r7, r8, r9;                       
wire w, x, y, z;

always @ ( w, x, y, z, r0, r1, r2, r3, r4, r5, r6, r7, r8, r9) begin       //Create a set of code that works line by line 
                                         //when these variables are used

//y
r0 = (y);

//yz + w'x'z + w'xy + wx'y + wxz + wxy' + wy'z' + xy'z'
r1 = (y&z) | ((~w)&(~x)&z) | ((~w)&x&y) | (w&(~x)&y) | (w&x&z) | (w&x&(~y)) | (w&(~y)&(~z)) | (x&(~y)&(~z));

//xy'z + xyz' + x'y'z' + x'yz
r2 = (x&(~y)&z) | (x&y&(~z)) | ((~x)&(~y)&(~z)) | ((~x)&y&z);

//w + x
r3 = (w) | (x);

//w'y' + x'y'z' + w'x'z'
r4 = (~(w)&(~y)) | ((~x)&(~y)&(~z)) | ((~w)&(~x)&(~z));

//w'z + x'z + w'x
r5 = ((~w)&z) | ((~x)&z) | ((~w)&x);

//w' + xyz
r6 = (~w) | (x&y&z);

//w'z + w'y + w'x'
r7 = ((~w)&z) | ((~w)&y) | ((~w)&(~x));

//w'x'y + w'xy'
r8 = ((~w)&(~x)&y) | ((~w)&x&(~y));

//w'x'y'z' + w'x'yz + wxy'z' + wxyz + wx'y'z
r9 = ((~w)&(~x)&(~y)&(~z)) | ((~w)&(~x)&y&z) | (w&x&(~y)&(~z)) | (w&x&y&z) | (w&(~x)&(~y)&z);

end                                       // Finish the Always block

endmodule                                 //Module End

//----------------------------------------------------------------------
module testbench();

  //Registers act like local variables
  reg [4:0] i; //A loop control for 16 rows of a truth table.
  reg  w;//Value of 2^3
  reg  x;//Value of 2^2
  reg  y;//Value of 2^1
  reg  z;//Value of 2^0
  
  //A wire can hold the return of a function
  wire  f0, f1, f2, f3, f4, f5, f6, f7, f8, f9;
  //Modules can be either functions, or model chips. 
  //They are instantiated like an object of a class, 
  //with a constructor with parameters.  They are not invoked,
  //but operate like a thread.
  Breadboard bb8(w, x, y, z, f0, f1, f2, f3, f4, f5, f6, f7, f8, f9);
 
     
	 
  //Initial means "start," like a Main() function.
  //Begin denotes the start of a block of code.	
  initial begin
   	
  //$display acts like a java System.println command.
  
  
  $display ("|##|w|x|y|z|f0|f1|f2|f3|f4|f5|f6|f7|f8|f9|");
  $display ("|==+=+=+=+=+==+==+==+==+==+==+==+==+==+==|");
  
    //A for loop, with register i being the loop control variable.
	for (i = 0; i <= 15; i = i + 1) 
	begin//Open the code block of the for loop
		w = (i/8) % 2;//High bit
		x = (i/4) % 2;
		y = (i/2) % 2;
		z = (i/1) % 2;//Low bit	
		 
		//Oh, Dr. Becker, do you remember what belongs here? 
		#5;
 
		 	
		$display ("|%2d|%1d|%1d|%1d|%1d| %1d| %1d| %1d| %1d| %1d| %1d| %1d| %1d| %1d| %1d|",i , w, x, y, z, f0, f1, f2, f3, f4, f5, f6, f7, f8, f9);
		if(i % 4 == 3) //Every fourth row of the table, put in a marker for easier reading.
		 $write ("|--+-+-+-+-+--+--+--+--+--+--+--+--+--+--|\n");//Write acts a bit like a java System.print

	end//End of the for loop code block
 
	#10; //A time delay of 10 time units. Hashtag Delay
	$finish;//A command, not unlike System.exit(0) in Java.
  end  //End the code block of the main (initial)
  
endmodule //Close the testbench module




























//Dr. Becker's cheat sheet of what is wrong in the code.
//The loop control variable can never reach 16, it is only 4 bits. Add another bit
//There needs to be a time dealy, such a #5, inside the for loop
