module Breadboard (w, x, y, z, r0, r1, r2, r3, r4, r5, r6, r7, r8, r9); 
input w, x, y, z;                                                       
output r0, r1, r2, r3, r4, r5, r6, r7, r8, r9;                          
reg r0, r1, r2, r3, r4, r5, r6, r7, r8, r9;                       
wire w, x, y, z;

always @ ( w, x, y, z, r0, r1, r2, r3, r4, r5, r6, r7, r8, r9) begin    

// y
r0 = (y);

// yz + w'x'z + w'xy + wx'y + wxz + wxy' + wy'z' + xy'z'
r1 = (y&z) | ((~w)&(~x)&z) | ((~w)&x&y) | (w&(~x)&y) | (w&x&z) | (w&x&(~y)) | (w&(~y)&(~z)) | (x&(~y)&(~z));

// xy'z + xyz' + x'y'z' + x'yz
r2 = (x&(~y)&z) | (x&y&(~z)) | ((~x)&(~y)&(~z)) | ((~x)&y&z);

// w + x
r3 = (w) | (x);

// w'y' + x'y'z' + w'x'z'
r4 = (~(w)&(~y)) | ((~x)&(~y)&(~z)) | ((~w)&(~x)&(~z));

// w'z + x'z + w'x
r5 = ((~w)&z) | ((~x)&z) | ((~w)&x);

// w' + xyz
r6 = (~w) | (x&y&z);

// w'z + w'y + w'x'
r7 = ((~w)&z) | ((~w)&y) | ((~w)&(~x));

// w'x'y + w'xy'
r8 = ((~w)&(~x)&y) | ((~w)&x&(~y));

// w'x'y'z' + w'x'yz + wxy'z' + wxyz + wx'y'z
r9 = ((~w)&(~x)&(~y)&(~z)) | ((~w)&(~x)&y&z) | (w&x&(~y)&(~z)) | (w&x&y&z) | (w&(~x)&(~y)&z);

end

endmodule                                 

// Using Iverlog/Icarus on NeoVim
module testbench();

  reg [4:0] i;
  reg  w; // 8
  reg  x; // 4
  reg  y; // 2
  reg  z; // 1
  
  wire  f0, f1, f2, f3, f4, f5, f6, f7, f8, f9;

  // Invoke breadboard module for equations
  Breadboard bb8(w, x, y, z, f0, f1, f2, f3, f4, f5, f6, f7, f8, f9);
  
  initial begin
   	
  $display ("|##|w|x|y|z|f0|f1|f2|f3|f4|f5|f6|f7|f8|f9|");
  $display ("|==+=+=+=+=+==+==+==+==+==+==+==+==+==+==|");
  
	for (i = 0; i <= 15; i = i + 1) 
	begin
		w = (i/8) % 2;
		x = (i/4) % 2;
		y = (i/2) % 2;
		z = (i/1) % 2;
		 
		// Time delay 
		#5;
		 	
		$display ("|%2d|%1d|%1d|%1d|%1d| %1d| %1d| %1d| %1d| %1d| %1d| %1d| %1d| %1d| %1d|",i , w, x, y, z, f0, f1, f2, f3, f4, f5, f6, f7, f8, f9);
		if(i % 4 == 3) 
		 $write ("|--+-+-+-+-+--+--+--+--+--+--+--+--+--+--|\n"); 

	end
 
	#10; 
	$finish;
  end 
  
endmodule
