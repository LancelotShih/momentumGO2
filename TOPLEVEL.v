//module TOPLEVEL
//	(
//		CLOCK_50,						//	On Board 50 MHz
//		// Your inputs and outputs here
//		KEY,							// On Board Keys
//		// The ports below are for the VGA output.  Do not change.
//		VGA_CLK,   						//	VGA Clock
//		VGA_HS,							//	VGA H_SYNC
//		VGA_VS,							//	VGA V_SYNC
//		VGA_BLANK_N,						//	VGA BLANK
//		VGA_SYNC_N,						//	VGA SYNC
//		VGA_R,   						//	VGA Red[9:0]
//		VGA_G,	 						//	VGA Green[9:0]
//		VGA_B,   						//	VGA Blue[9:0]
//		LEDR,
//		HEX0,
//		
//	);
//
//	input			CLOCK_50;				//	50 MHz
//	input	[3:0]	KEY;					
//	// Declare your inputs and outputs here
//	// Do not change the following outputs
//	output			VGA_CLK;   				//	VGA Clock
//	output			VGA_HS;					//	VGA H_SYNC
//	output			VGA_VS;					//	VGA V_SYNC
//	output			VGA_BLANK_N;				//	VGA BLANK
//	output			VGA_SYNC_N;				//	VGA SYNC
//	output	[7:0]	VGA_R;   				//	VGA Red[7:0] Changed from 10 to 8-bit DAC
//	output	[7:0]	VGA_G;	 				//	VGA Green[7:0]
//	output	[7:0]	VGA_B;   				//	VGA Blue[7:0]
//	output [9:0]LEDR;
//	output [6:0]HEX0;
//
//	wire resetn;
//	assign resetn = KEY[0];
//
//	// Create the colour, x, y and writeEn wires that are inputs to the controller.
//
//	wire [2:0] colour;
//	wire [9:0] x;
//	wire [8:0] y;
//	
//
//	// Create an Instance of a VGA controller - there can be only one!
//	// Define the number of colours as well as the initial background
//	// image file (.MIF) for the controller.
//	vga_adapter VGA(
//			.resetn(resetn),
//			.clock(CLOCK_50),
//			.colour(colour),
//			.x(x),
//			.y(y),
//			.plot(gated_plot_enable),
//			/* Signals for the DAC to drive the monitor. */
//			.VGA_R(VGA_R),
//			.VGA_G(VGA_G),
//			.VGA_B(VGA_B),
//			.VGA_HS(VGA_HS),
//			.VGA_VS(VGA_VS),
//			.VGA_BLANK(VGA_BLANK_N),
//			.VGA_SYNC(VGA_SYNC_N),
//			.VGA_CLK(VGA_CLK));
//		defparam VGA.RESOLUTION = "320x240";
//		defparam VGA.MONOCHROME = "FALSE";
//		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
//		defparam VGA.BACKGROUND_IMAGE = "white.mif";
//		
//	////////////////////////////////////
//	wire [2:0] loadColour;
//	wire readMemory, writeMemory;
//	wire[8:0] address_a, box_address, address100;
//	wire draw_enable_background, draw_enable_foreground;
//	wire reset_draw_background, reset_draw_foreground;
//	wire finished;
//	wire plot_enable;
//	wire ANDplot_enable;
//	wire gated_plot_enable;
//	/////////////////////////////////////
//
//
//	/////////////////////////////////////
//
//	wire[3:0] positionX, positionY;
// 	wire[9:0] pixelX, pixelX2;
//    wire[8:0] pixelY, pixelY2;
//
//	wire[9:0] x1, x2;
//	wire[8:0] y1, y2;
//	/////////////////////////////////////
//
//
//	reg[3:0] red_X = 1;
//	reg[3:0] red_Y = 1;
//	reg[3:0] blue_X = 4;
//	reg[3:0] blue_Y = 3;
//
//	
//	/////////////////////////////////////
//
//	always@(negedge KEY[3]) begin
//		red_X <= red_X + 1;
//	end 
//	
//	always@(negedge KEY[2]) begin
//		red_Y <= red_Y + 1;
//	end
//
//		/////////////////////////////////////
//
//
//	wire clock25;
//		
//	rateDivider rD1(.clock50(CLOCK_50), .clock25(clock25));
//		
//	hex_decoder hexMOD(.c(red_X), .display(HEX0)); 
//
//	gameBoardFSM GB1(.clock(clock25), .reset(!KEY[0]), .LEDR(LEDR), .red_X(red_X), .red_Y(red_Y), .blue_X(blue_X), .blue_Y(blue_Y), .finished(finished), .loadColour(loadColour), .plot_enable(plot_enable), 
//	.writeMemory(writeMemory), .readMemory(readMemory), .address_a(address_a), .box_address(box_address), .draw_enable_background(draw_enable_background), .draw_enable_foreground(draw_enable_foreground), 
//	.reset_draw_background(reset_draw_background), .reset_draw_foreground(reset_draw_foreground));
//
//	BRAM B1(.address_a(address_a), .address_b(box_address), .clock(clock25), .data_a(loadColour), .rden_b(readMemory), .wren_a(writeMemory), .q_b(colour2));
//
//	addressToPosition ATP1(.address(box_address), .positionX(positionX), .positionY(positionY));
//	addressToPosition ATP2_note_position_is_pixel(.address(address100), .positionX(pixelX2), .positionY(pixelY2));
//
//	positionToPixel PTP1(.positionX(positionX), .positionY(positionY), .pixelX(pixelX), .pixelY(pixelY));
//
//	draw_Back D1(.clock(clock25), .reset(reset_draw_background), .enable_draw(draw_enable_background), .initial_xPosition(pixelX), .initial_yPosition(pixelY), .xOutput(x2), .yOutput(y2), .finished(finished) );
//
//    draw_Animation DA1(.clock(clock25), .reset(reset_draw_foreground), .enable_draw(draw_enable_foreground), .initial_xPosition(pixelX2), .initial_yPosition(pixelY2), .xOutput(x1), .yOutput(y1), .ANDplot_enable(ANDplot_enable));
//
//	colourGate CG1 (.x1(x1), .x2(x2), .y1(x1), .y2(y2), .colour1(colour1), .colour2(colour2), .oX(x), .oY(y), .oColour(colour), 
//	.backgroundSelect(draw_enable_background), .foregroundSelect(draw_enable_foreground), .ANDplot_enable(ANDplot_enable), .plot_enable(plot_enable), .gated_plot_enable(gated_plot_enable));
//
//	
//endmodule


module hex_decoder(c, display);

	input [3:0] c;
	output [6:0] display;

	assign display[0] = (!c[3] & !c[2] & !c[1] & c[0]) + (!c[3] & c[2] & !c[1] & !c[0]) + (c[3] & !c[2] & c[1] & c[0])  +  (c[3] & c[2] & !c[1] & c[0]);
	assign display[1] = (!c[3] & c[2] & !c[1] & c[0]) + (!c[3] & c[2] & c[1] & !c[0]) + (c[3] & !c[2] & c[1] & c[0]) + (c[3] & c[2] & !c[1] & !c[0]) + (c[3] & c[2] & c[1] & !c[0]) + (c[3] & c[2] & c[1] & c[0]);
	assign display[2] = (!c[3] & !c[2] & c[1] & !c[0]) + (c[3] & c[2] & !c[1] & !c[0]) + (c[3] & c[2] & c[1] & !c[0]) + (c[3] & c[2] & c[1] & c[0]);
	assign display[3] = (!c[3] & !c[2] & !c[1] & c[0]) + (!c[3] & c[2] & !c[1] & !c[0]) + (!c[3] & c[2] & c[1] & c[0])+ (c[3] & !c[2] & c[1] & !c[0])+ (c[3] & c[2] & c[1] & c[0]);
	assign display[4] = (!c[3] & !c[2] & !c[1] & c[0]) + (!c[3] & !c[2] & c[1] & c[0]) + (!c[3] & c[2] & !c[1] & !c[0]) + (!c[3] & c[2] & !c[1] & c[0]) + (!c[3] & c[2] & c[1] & c[0]) + (c[3] & !c[2] & !c[1] & c[0]);
	assign display[5] = (!c[3] & !c[2] & !c[1] & c[0]) + (!c[3] & !c[2] & c[1] & !c[0]) + (!c[3] & !c[2] & c[1] & c[0]) + (!c[3] & c[2] & c[1] & c[0]) + (c[3] & c[2] & !c[1] & c[0]);
	assign display[6] = (!c[3] & !c[2] & !c[1] & !c[0]) + (!c[3] & !c[2] & !c[1] & c[0]) + (!c[3] & c[2] & c[1] & c[0]) + (c[3] & c[2] & !c[1] & !c[0]);

endmodule

module TOPLEVEL(CLOCK_50, KEY);

	input			CLOCK_50;				//	50 MHz
	input	[3:0]	KEY;	
	
	wire [2:0] colour;
	wire [9:0] x;
	wire [8:0] y;

	////////////////////////////////////
	wire [2:0] loadColour;
	wire readMemory, writeMemory;
	wire[8:0] address_a, box_address, address100;
	wire draw_enable_background, draw_enable_foreground;
	wire reset_draw_background, reset_draw_foreground;
	wire finished;
	wire plot_enable;
	wire ANDplot_enable;
	wire gated_plot_enable;
	/////////////////////////////////////


	/////////////////////////////////////

	wire[3:0] positionX, positionY;
 	wire[9:0] pixelX, pixelX2;
    wire[8:0] pixelY, pixelY2;

	wire[9:0] x1, x2;
	wire[8:0] y1, y2;
	/////////////////////////////////////


	reg[3:0] red_X = 1;
	reg[3:0] red_Y = 1;
	reg[3:0] blue_X = 4;
	reg[3:0] blue_Y = 3;

	
	/////////////////////////////////////

	always@(negedge KEY[3]) begin
		red_X <= red_X + 1;
	end 
	
	always@(negedge KEY[2]) begin
		red_Y <= red_Y + 1;
	end

		/////////////////////////////////////


	wire clock25;
		
	rateDivider rD1(.clock50(CLOCK_50), .clock25(clock25));
		
	hex_decoder hexMOD(.c(red_X), .display(HEX0)); 

	gameBoardFSM GB1(.clock(clock25), .reset(!KEY[0]), .LEDR(LEDR), .red_X(red_X), .red_Y(red_Y), .blue_X(blue_X), .blue_Y(blue_Y), .finished(finished), .loadColour(loadColour), .plot_enable(plot_enable), 
	.writeMemory(writeMemory), .readMemory(readMemory), .address_a(address_a), .box_address(box_address), .draw_enable_background(draw_enable_background), .draw_enable_foreground(draw_enable_foreground), 
	.reset_draw_background(reset_draw_background), .reset_draw_foreground(reset_draw_foreground));

	BRAM B1(.address_a(address_a), .address_b(box_address), .clock(clock25), .data_a(loadColour), .rden_b(readMemory), .wren_a(writeMemory), .q_b(colour2));

	addressToPosition ATP1(.address(box_address), .positionX(positionX), .positionY(positionY));
	addressToPosition ATP2_note_position_is_pixel(.address(address100), .positionX(pixelX2), .positionY(pixelY2));

	positionToPixel PTP1(.positionX(positionX), .positionY(positionY), .pixelX(pixelX), .pixelY(pixelY));

	draw_Back D1(.clock(clock25), .reset(reset_draw_background), .enable_draw(draw_enable_background), .initial_xPosition(pixelX), .initial_yPosition(pixelY), .xOutput(x2), .yOutput(y2), .finished(finished) );

    draw_Animation DA1(.clock(clock25), .reset(reset_draw_foreground), .enable_draw(draw_enable_foreground), .initial_xPosition(pixelX2), .initial_yPosition(pixelY2), .xOutput(x1), .yOutput(y1), .ANDplot_enable(ANDplot_enable));

	colourGate CG1 (.x1(x1), .x2(x2), .y1(x1), .y2(y2), .colour1(colour1), .colour2(colour2), .oX(x), .oY(y), .oColour(colour), 
	.backgroundSelect(draw_enable_background), .foregroundSelect(draw_enable_foreground), .ANDplot_enable(ANDplot_enable), .plot_enable(plot_enable), .gated_plot_enable(gated_plot_enable));

endmodule