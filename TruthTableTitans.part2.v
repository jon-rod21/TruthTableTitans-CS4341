module seven_seg_display(input a, b, c, d, e, f, g);
    always @(*) begin
        #5;

        $display("In SevenSegment, the segments are       : [%b%b%b%b%b%b%b]\n", a, b, c, d, e, f, g); 
        
        if (a)
            $display("   #####");
        else
            $display("        ");

        $display(" %s    %s", f ? "##" : " ", b ? " ##" : " ");
        $display(" %s    %s", f ? "##" : " ", b ? " ##" : " ");
        $display(" %s    %s", f ? "##" : " ", b ? " ##" : " ");



        if (g)
            $display("   #####");
        else
            $display("        ");

        $display(" %s    %s", e ? "##" : " ", c ? " ##" : " ");
        $display(" %s    %s", e ? "##" : " ", c ? " ##" : " ");
        $display(" %s    %s", e ? "##" : " ", c ? " ##" : " ");

        if (d)
            $display("   #####");
        else
            $display("        \n");
    end

endmodule

module d416(input [3:0] in, output [15:0] out);
    wire [3:0] n;

    not not0(n[0], in[0]);
    not not1(n[1], in[1]);
    not not2(n[2], in[2]);
    not not3(n[3], in[3]);


    and and0(out[0], n[3], n[2], n[1], n[0]);
    and and1(out[1], n[3], n[2], n[1], in[0]);
    and and2(out[2], n[3], n[2], in[1], n[0]);
    and and3(out[3], n[3], n[2], in[1], in[0]);
    and and4(out[4], n[3], in[2], n[1], n[0]);
    and and5(out[5], n[3], in[2], n[1], in[0]);
    and and6(out[6], n[3], in[2], in[1], n[0]);
    and and7(out[7], n[3], in[2], in[1], in[0]);
    and and8(out[8], in[3], n[2], n[1], n[0]);
    and and9(out[9], in[3], n[2], n[1], in[0]);
    and and10(out[10], in[3], n[2], in[1], n[0]);
    and and11(out[11], in[3], n[2], in[1], in[0]);
    and and12(out[12], in[3], in[2], n[1], n[0]);
    and and13(out[13], in[3], in[2], n[1], in[0]);
    and and14(out[14], in[3], in[2], in[1], n[0]);
    and and15(out[15], in[3], in[2], in[1], in[0]);

endmodule

module Breadboard(input [3:0] i);
    wire [15:0] onehot;
    wire a, b, c, d, e, f, g;

    d416 decoder(i, onehot);
   
    seven_seg_display display(a, b, c, d, e, f, g);
    
    assign a = onehot[0] | onehot[2] | onehot[3] | onehot[5] | onehot[6] | onehot[7] | onehot[8] | onehot[9] | onehot[10] | onehot[14] | onehot[15];
    assign b = onehot[0] | onehot[1] | onehot[2] | onehot[3] | onehot[4] | onehot[7] | onehot[8] | onehot[9] | onehot[10] | onehot[13];
    assign c = onehot[0] | onehot[1] | onehot[3] | onehot[4] | onehot[5] | onehot[6] | onehot[7] | onehot[8] | onehot[9] | onehot[10] | onehot[11] | onehot[13];
    assign d = onehot[0] | onehot[2] | onehot[3] | onehot[5] | onehot[6] | onehot[8] | onehot[9] | onehot[11] | onehot[12] | onehot[13] | onehot[14];
    assign e = onehot[0] | onehot[2] | onehot[6] | onehot[8] | onehot[10] | onehot[11] | onehot[12] | onehot[13] | onehot[14] | onehot[15];
    assign f = onehot[0] | onehot[4] | onehot[5] | onehot[6] | onehot[8] | onehot[9] | onehot[10] | onehot[11] | onehot[14] | onehot[15];
    assign g = onehot[2] | onehot[3] | onehot[4] | onehot[5] | onehot[6] | onehot[8] | onehot[9] | onehot[10] | onehot[11] | onehot[12] | onehot[13] | onehot[14] | onehot[15];

    always @(*) begin
        #5;
        $display("In Breadboard, decimal number is      : %0d", i);
        $display("In Breadboard, binary number is       : %04b", i);
        $display("In Breadboard, one hot number is      : %016b", onehot);
        $display("In Breadboard, the segments are       : [%b%b%b%b%b%b%b]", a, b, c, d, e, f, g);
    end


endmodule

module testbench();
    reg [3:0] i;
    integer j;

    Breadboard bb(i);

    initial begin

        for (j = 0; j <= 15; j = j + 1) 
        begin
            i = j;
            #60;
        end
        #10;
        $finish;
    end
  
endmodule
