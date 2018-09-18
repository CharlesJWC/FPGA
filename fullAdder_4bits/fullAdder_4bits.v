module fullAdder_4bits(sum, c_out, a, b, c_in);

input [3:0] a;
input [3:0] b;
input c_in;
output [3:0] sum;
output c_out;

wire c1, c2, c3;

fullAdder fa0(sum[0], c1, a[0], b[0], c_in);
fullAdder fa1(sum[1], c2, a[1], b[1], c1);
fullAdder fa2(sum[2], c3, a[2], b[2], c2);
fullAdder fa3(sum[3], c_out, a[3], b[3], c3);

endmodule
