module test_16;

reg inst;
reg [15:0] A, B, C, a, b;
reg add_sub;
reg [7:0] shift;
reg [7:0] shift_c;
reg [3:0] shift_sub;
reg sign_a, sign_b, sign_c, sign; 
reg [7:0] exp_a, exp_b, exp_c;
reg [9:0] sig_a, sig_b, sig_c;
reg [6:0] sig_cc;

  initial 
    begin
    inst = 0; 
     A = 16'b 0011111000101000;
     B = 16'b 0011111100110100;
    end
  
  always @(*) begin
  
  //////////// Add or Sub //////////	
	add_sub = (inst == 1)? 1:0;
  
  
  //////////// Assign bigger number to a //////////
  {a, b, sign} = (A[14:0] > B[14:0])? {A, B, 1'b 0}: {B, A,  1'b 1};
  sign_a = a[15];
	exp_a = a[14:7];
	sig_a = {2'b 01,a[6:0], 1'b 0};

	sign_b = b[15];
	exp_b = b[14:7];
	sig_b = {2'b 01,b[6:0], 1'b 0};
	shift = (a[14:7] == b[14:7])? 0: (a[14:7] - b[14:7]);
	sig_b = sig_b >> shift;
	
	//////////// Add //////////
	if (add_sub == 1) begin 
	  if (b == 16'b 0000000000000000)
	    C = a;
	  else begin
	    sig_c = sig_a + sig_b;
	    shift_c = (sig_c[9] == 1)? 1:0;
	    sig_c = sig_c >> (shift_c);
	    sig_cc = (sig_c[0] == 1)? ((sig_c[1] == 1)? sig_c[7:1] + 1:sig_c[7:1]) : sig_c[7:1];
	    sign_c = sign_a;
	    exp_c = exp_a + shift_c;
	    C = {sign_c, exp_c, sig_cc};
	  end
	 end 
	 //////////// Sub //////////
	if (add_sub == 0) begin 
		sign_c = (sign == 0)? sign_a: 1'b 1;
		 if (b == 16'b 0000000000000000)
	        C = {sign_c, a[14:0]};
	    else begin
		    sig_c = sig_a - sig_b;
		if (sig_c[8:1] == 8'b 00000000) shift_sub = 8;
		else if (sig_c[8:1] == 8'b 00000001) shift_sub = 7;
		else if (sig_c[8:2] == 7'b 0000001) shift_sub = 6;
		else if (sig_c[8:3] == 6'b 000001) shift_sub = 5;
		else if (sig_c[8:4] == 5'b 00001) shift_sub = 4;
		else if (sig_c[8:5] == 4'b 0001) shift_sub = 3;
		else if (sig_c[8:6] == 3'b 001) shift_sub = 2;
		else if (sig_c[8:7] == 2'b 01) shift_sub = 1;
		else shift_sub = 0;
	    	/*case (sig_c[7:1])
		    	7'b 0000000 : shift_sub = 7;
			    7'b 0000001 : shift_sub = 6;
			    7'b 000001x : shift_sub = 5;
			    7'b 00001xx : shift_sub = 4;
			    7'b 0001xxx : shift_sub = 3;
			    7'b 001xxxx : shift_sub = 2;
			    7'b 01xxxxx : shift_sub = 1;
			    7'b 1xxxxxx : shift_sub = 0;
			    default : shift_sub = 0; 
		    endcase
		    shift_sub = (sig_c[8] == 0)? shift_sub + 1: shift_sub;*/
		    sig_c = sig_c << shift_sub;
		    sig_cc = (sig_c[0] == 1)? ((sig_c[1] == 1)? sig_c[7:1] + 1:sig_c[7:1]) : sig_c[7:1];
		    exp_c = exp_a - shift_sub;
		    C = {sign_c, exp_c, sig_cc};
		end
	end
	
  $display("sig_c = %b, sig_b = %b, C = %b, shift = %d, shift_sub = %d", sig_c, sig_b, C, shift, shift_sub);
  
  end
  
endmodule 
