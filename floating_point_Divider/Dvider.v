`timescale 1ns / 1ps

module Divider
(
	input CLK, St,
    input [7:0] dividend,
    input [7:0] divisor,
    output [7:0] quotient, 
    output [7:0] remainder, 
    output Done 
);

integer i;
reg [7:0] diff; 

reg [7:0] qu;
reg [7:0] rem;

assign remainder [7:0] = rem[7:0];
assign quotient [7:0] = qu[7:0];

always @(posedge CLK) begin
	rem [7:0] = 8'b0; 
	qu [7:0] = dividend[7:0]; 
	
	for (i=0;i<=7;i=i+1)
	begin
		rem = rem<<1;
		rem[0] = qu[7];
		qu = qu<<1;
		qu[0] = 1'b0;
	
		if ( rem >= divisor) 
		begin
			rem = rem-divisor;
			qu[0] = 1'b1;
		end
	end
end 

endmodule
