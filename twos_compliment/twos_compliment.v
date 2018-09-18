module twos_compliment
(
	input CMC,
	input[7:0] signal_in,
	output [7:0] signal_out
);

assign signal_out = (CMC)? (~signal_in)+1'b1: signal_in;

endmodule
