module mux_2x1(in0,in1,select,out);

input in0, in1, select;
output reg out;


always @(select, in0, in1)
begin
	//case(select)
	if(select) out = in1;
	else out = in0;
	//out = select ? in1 : in0; 
end



endmodule