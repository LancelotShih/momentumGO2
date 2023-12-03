

module buffer(clk, reset, enable, done);

	input clk, reset, enable;
	output reg done = 0;

	reg [40:0] buffer_counter = 0;

	always@(posedge clk)
	begin: wait_time
		if(reset)
		begin
			done <= 0;
			buffer_counter <= 0;
		end 

		else if(enable)
		begin
			if(buffer_counter == 5000/120 - 1) //60Hz = 50000000 / 60 - 1
			begin
				done <= 1;
				buffer_counter <= 0;
			end
			else begin
			done <= 0;
			buffer_counter <= buffer_counter + 1;
			end
		end
	end
endmodule


module buffer_short(clk, reset, enable, done);

	input clk, reset, enable;
	output reg done;

	reg [5:0] buffer_counter = 0;

	always@(posedge clk)
	begin: pulse_time
		if(reset)
		begin
			done <= 0;
			buffer_counter <= 0;
		end 

		else if(enable)
		begin
			if(buffer_counter == 20)
			begin
				done <= 1;
				buffer_counter <= 0;
			end
			else begin
			done <= 0;
			buffer_counter <= buffer_counter + 1;
			end
		end
	end
endmodule