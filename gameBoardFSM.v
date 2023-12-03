

 module topLevel(CLOCK_50, KEY, LEDR, red_X, red_Y, blue_X , blue_Y, x, y, colour, plot_enable);

	output wire [2:0] colour;
	output wire [9:0] x;
	output wire [8:0] y;
	output [3:0] LEDR;
 output plot_enable;

	
	input CLOCK_50;
	input [3:0] KEY;
	input [3:0]red_X, red_Y, blue_X, blue_Y;

     wire [2:0] loadColour;
     wire readMemory, writeMemory;
     wire[8:0] address_a, box_address;
     wire draw_enable_background, draw_enable_foreground;
     wire reset_draw_background, reset_draw_foreground;
     wire finished;


     wire[3:0] positionX, positionY;
     wire[10:0] pixelX;
     wire[10:0] pixelY;

    wire filler, filler2;
    wire [2:0] colourfiller, colourfiller2;


     gameBoardFSM GB1(.clock(CLOCK_50), .reset(!KEY[0]), .trigger(!KEY[3]), .red_X(red_X), .red_Y(red_Y), .blue_X(blue_X), .blue_Y(blue_Y), .finished(finished), .loadColour(loadColour), .plot_enable(plot_enable), 
     .writeMemory(writeMemory), .readMemory(readMemory), .address_a(address_a), .box_address(box_address), .draw_enable_background(draw_enable_background), .draw_enable_foreground(draw_enable_foreground), 
     .reset_draw_background(reset_draw_background), .reset_draw_foreground(reset_draw_foreground));

     BRAM B1(.address_a(address_a), .address_b(box_address), .clock(CLOCK_50), .data_a(loadColour), .data_b( colourfiller), .rden_a( filler), .rden_b(readMemory), .wren_a(writeMemory), .wren_b(filler2 ), .q_a(colourfiller2 ), .q_b(colour));

     addressToPosition ATP1(.address(box_address), .positionX(positionX), .positionY(positionY));

     positionToPixel PTP1(.positionX(positionX), .positionY(positionY), .pixelX(pixelX), .pixelY(pixelY));

     draw_Back D1(.clock(CLOCK_50), .reset(reset_draw_background), .enable_draw(draw_enable_background), .initial_xPosition(pixelX), .initial_yPosition(pixelY), .xOutput(x), .yOutput(y), .finished(finished) );

endmodule


module gameBoardFSM(
                    clock, reset, trigger, LEDR,
                    red_X, red_Y, blue_X, blue_Y, 
                    finished,
                   
                    loadColour, plot_enable,

                    writeMemory, readMemory, 
                    address_a, box_address,

                    draw_enable_background, draw_enable_foreground, //these shall enable their respective draw counters and MUX to the VGA. Foreground things will communicate directly with bomb module and playerFSM
                    reset_draw_background, reset_draw_foreground
                    );

input clock, reset, trigger;
input [3:0] red_X, red_Y, blue_X, blue_Y;
input finished;
output reg [9:0] LEDR;

output reg [2:0] loadColour = 0;
output reg plot_enable = 0;

//BRAM/////////////////
output reg writeMemory = 0;
output reg readMemory= 0;
output reg [8:0]address_a = 0;
wire [8:0]red_address, blue_address; 
//BRAM (.address_a(address_a),.address_b(box_address),.clock(clock),.data_a(loadColour), .data_b(NULL), .rden_a(NULL), .rden_b(readMemory), .wren_a(writeMemory), .wren_b(NULL), .q_a(NULL), .q_b(SEND TO VGA));
positionToAddress RedPosToAddress(red_X, red_Y, red_address);
positionToAddress BluePosToAddress(blue_X, blue_Y, blue_address);

//since when we read it, we need an address port, we can only use one so that the other can be for write
// [ ADDRESS PORT A: WRITING PORT | ADDRESS PORT B: READING PORT ]
////////////////////////


//DRAW///
output reg draw_enable_background, reset_draw_background;

///


//BUFFER////////////////////////////////////////////////
wire doneWriting, doneBuffer; //corresponding to short buffer and buffer respectively
reg reset_buffer, buffer_enable;
reg reset_short_buffer, short_buffer_enable;
buffer_short BS1(.clk(clock), .reset(reset_short_buffer), .enable(short_buffer_enable), .done(doneWriting));
buffer B1(.clk(clock), .reset(reset_buffer), .enable(buffer_enable), .done(doneBuffer));
//////////////////////////////////////////////////////////

//Counter100//////////////////////////////////////////////
output reg reset_draw_foreground, draw_enable_foreground;
wire done100Count;
addressCounter100 AC100(.clk(clock), .reset(reset_draw_foreground), .enable(draw_enable_foreground), .doneAll(done100Count));


/////////////////////////////////////////////////////////


//Counter255/////////////////////////////////////////////
reg reset_counter255, count255_enable;  
output [8:0] box_address;
wire doneBackground;

addressCounter AC1(.clock(clock), .reset(reset_counter255), .enable(count255_enable), .done(finished), .address(box_address), .doneAll(doneBackground));
////////////////////////////////////////////////////////////

 //foreground last frame tracker
    reg [3:0] lastFrame = 0;
//


// FSM STATES //////////////////////////
localparam Idle = 10'd0,
            StartWritingRed = 10'd1,
            WriteRed = 10'd2,
            StartWritingBlue = 10'd3,
            WriteBlue = 10'd4 ,
            StartDrawBackground = 10'd5 ,
            ResetBackgroundDraw = 10'd6 ,
            DrawBackground = 10'd7,
            StartDrawForeground = 10'd8 ,
            drawP1 = 10'd9,
            reset100counter = 10'd10 , 
            drawP2 = 10'd11,
            SelectFrame = 10'd12,
            frame1 = 10'd13,
            frame2 = 10'd14,
            frame3 = 10'd15,
            frame4 = 10'd16,
            frame5 = 10'd17;


reg [10:0] current_state = 0;
reg [10:0] next_state = 0;
///////////////////////////////////////////

always@(*)
begin: state_transition_table
    case (current_state)
        Idle: begin
				if(doneWriting)
            next_state <= StartWritingRed;
				else
				next_state <= Idle;
        end

        /////////////////////////////////////////////////////////////////////////////////
        StartWritingRed: begin
            next_state <= WriteRed;
        end
        WriteRed: begin
            if(doneWriting) //need to have a condition for doneWriting 
            next_state <= StartWritingBlue;
            else
            next_state <= WriteRed;
        end

        StartWritingBlue: begin
            next_state <= WriteBlue;
        end


        WriteBlue: begin
            if(doneWriting)
            next_state <= StartDrawBackground;
            else
            next_state <= WriteBlue;
        end
        /////////////////////////////////////////////////////////////////////////////////

        StartDrawBackground:begin
            next_state <= ResetBackgroundDraw;
        end

        ResetBackgroundDraw: begin
            next_state <= DrawBackground;
        end

        DrawBackground: begin
            // note that the frames must hold their done signal up and the next state needs to turn it off
            
            if(doneBackground)
            next_state <= StartDrawForeground; // all boxes drawn
            else if(finished)
            next_state <= ResetBackgroundDraw; //1 box drawn
            else 
            next_state <= DrawBackground;
        end
        /////////////////////////////////////////////////////////////////////////////////

        StartDrawForeground: begin
            next_state <= drawP1; 
        end

        drawP1: begin
            if(done100Count)
            next_state <= reset100counter;
            else
            next_state <= drawP1;
        end

        reset100counter: begin
            next_state <= drawP2;
        end

        drawP2: begin
            if(done100Count)
            next_state <= SelectFrame;
            else
            next_state <= drawP2;
        end

        SelectFrame: begin
            
            case(lastFrame)
             0: begin next_state <= frame1; end

             1: begin next_state <= frame2; end

             2: begin next_state <= frame3; end

             3: begin next_state <= frame4; end

             4: begin next_state <= frame5; end
    
            endcase
        end

        frame1: begin
            if(doneBuffer)
            next_state <= StartDrawBackground;
            else 
            next_state <= frame1;
        end

        frame2:begin
            if(doneBuffer)
            next_state <= StartDrawBackground;
            else 
            next_state <= frame2;
        end

        frame3: begin
            if(doneBuffer)
            next_state <= StartDrawBackground;
            else 
            next_state <= frame3;
        end

        frame4: begin
            if(doneBuffer)
            next_state <= StartDrawBackground;
            else 
            next_state <= frame4;
        end

        frame5: begin
            if(doneBuffer)
            next_state <= Idle;
            else 
            next_state <= frame5;
        end
        endcase
    end

    always @(*)
    begin: output_logic
        
        address_a = 0;
        loadColour = 3'b000;
		  
        writeMemory = 0;
		
        plot_enable = 0;
		  
        reset_counter255 = 0;
        reset_short_buffer = 0;
        reset_buffer = 0;
        reset_draw_background = 0;
        reset_draw_foreground = 0;
		  
		  LEDR[0] = 0;
		  LEDR[1] = 0;

        case (current_state)

            //writing states //////////////////////////////////////////////////////////
				Idle: begin
					short_buffer_enable = 1;
					LEDR[0] = 1;
				end
				
            StartWritingRed: begin
                lastFrame = 0;
                writeMemory = 1;
                reset_short_buffer = 1;
            end

            WriteRed: begin
                writeMemory = 1;
                short_buffer_enable = 1;
                address_a = red_address; 

                if(red_address == blue_address)begin
                    
                    loadColour = 3'b111; 
                end
                else begin
                    loadColour = 3'b100;
                end
            end

            StartWritingBlue: begin
                writeMemory = 1;
                reset_short_buffer = 1;
               
                
            end

            WriteBlue: begin
                writeMemory = 1;
                short_buffer_enable = 1;
                address_a = blue_address;
                
                if(red_address == blue_address)begin
                    
                    loadColour = 3'b111;
                end
                else begin
                    loadColour = 3'b001;
                end
            end
            ////////////////////////////////////////////////////////////////////////////


            //drawing background states /////////////////////////////////////////////////////////////
            StartDrawBackground: begin
                //prepares to start the counter from 0-255
                short_buffer_enable = 0;
                reset_counter255 = 1;
                writeMemory = 0;
                readMemory = 1; // there should be one read port with its corresponding address. 
                plot_enable = 1;
            end

            ResetBackgroundDraw: begin
                //goes to this state upon receiving finished. Always sends back to Drawbackground.
                reset_draw_background = 1;
                draw_enable_background = 0;
            end

            DrawBackground: begin //either goes to Reset or goes to foreground if done all is high
                count255_enable = 1;
                plot_enable = 1; 
                draw_enable_background = 1;
            end
            /////////////////////////////////////////////////////////////////////////////////


            //drawing foreground frames//////////////////////////////////////////////////////
                StartDrawForeground: begin
                    draw_enable_background = 0;
                    reset_draw_foreground = 1;
                    count255_enable = 0;
                    readMemory = 0; 
                end

                drawP1: begin
                    //enables counter for character
                    draw_enable_foreground = 1; 
                end

                reset100counter: begin
                    reset_draw_foreground = 1;
                end

                drawP2: begin
                    draw_enable_foreground = 1;
                end

                SelectFrame: begin
                    reset_buffer = 1;
                end
                
                frame1: begin
                    buffer_enable = 1;
                    lastFrame = 1;
                    draw_enable_foreground = 1;
					LEDR[1] = 1;
                end

                frame2: begin
                    buffer_enable = 1;
                    lastFrame = 2;
                    draw_enable_foreground = 1;
                    
                end

                frame3: begin
                    buffer_enable = 1;
                    lastFrame = 3;
                    draw_enable_foreground = 1;
                    
                end

                frame4: begin
                    buffer_enable = 1;
                    lastFrame = 4;
                    draw_enable_foreground = 1;
                    
                end

                frame5: begin
                    buffer_enable = 1;
                    lastFrame = 5;
                    draw_enable_foreground = 1;
                    
                end
            /////////////////////////////////////////////////////////////////////////////////
        endcase
    end 


        // current_state registers
        always@(posedge clock)
        begin: state_FFs
            if(reset) begin
                current_state <= Idle;
            end
            else
                current_state <= next_state;
        end // state_FFS
    
endmodule

module rateDivider(clock50, clock25);

    input clock50;
    output reg clock25;

    always @ (posedge clock50)
    begin
        clock25 <= ~clock25;
    end


endmodule


module draw_Animation(clock, reset, enable_draw, initial_xPosition, initial_yPosition, xOutput, yOutput, iColour, oColour, finished, continue );

//draws player model 10x10
// has wire continue which acts as a way to not the plot for areas with MIF = 000
// NOTE: if we want to have it be a different anti-colour we can replace it with that in the MIF. 

    localparam WIDTH = 5'd10; 

    input clock, reset;
	input enable_draw;
	input [9:0]initial_xPosition;
	input [8:0]initial_yPosition;

    input [2:0]iColour;
    output reg [2:0]oColour;

	output [9:0]xOutput;
	output [8:0]yOutput;
	output reg finished = 0;
    output reg continue = 1; 

    reg [20:0]yCounter = 0;
	reg [9:0]movingX = 0;
	reg [8:0]movingY = 0;

	assign xOutput = movingX + initial_xPosition;
	assign yOutput = movingY + initial_yPosition;
	
	//increment X
	always @(posedge clock) begin

		if(reset || finished)begin
			movingX <= 0;
		end
		else if (enable_draw) begin 
			if(movingX == WIDTH - 1) begin //width - 1
				movingX <= 0;
			end 
			else begin
				movingX <= movingX + 1;
			end
			
		end
	end
//
	//increment Y
	always @(posedge clock) begin
		
		if(reset || finished)begin
			movingY <= 0;
			finished <= 0;
			yCounter <= 0;
		end
		else if (enable_draw) begin
			if(yCounter == WIDTH * WIDTH - 1) begin // width * 10 - 1
				yCounter <= 0;
				movingY <= 0;
				finished <= 1;
			end
			else if((yCounter+1) % WIDTH == 0 && yCounter != 0)begin // replace 10 with width
				movingY <= movingY + 1;
				yCounter <= yCounter + 1;
			end
			else begin
				yCounter <= yCounter + 1;
			end
		end
	end

    always @ (posedge clock) begin
        if(iColour == 0) begin
            continue <= 0;
        end
        else begin
            oColour <= iColour;
            continue <= 1;
        end
    end
endmodule

module draw_Back(clock, reset, enable_draw, initial_xPosition, initial_yPosition, xOutput, yOutput, finished );
	
	localparam WIDTH = 10'd10;
	
	input clock, reset;
	input enable_draw;
	input [9:0]initial_xPosition;
	input [8:0]initial_yPosition;

	output [9:0]xOutput;
	output [8:0]yOutput;
	output reg finished = 0;
	
	
	reg [20:0]yCounter = 0;
	reg [9:0]movingX = 0;
	reg [8:0]movingY = 0;

	assign xOutput = movingX + initial_xPosition;
	assign yOutput = movingY + initial_yPosition;
	
	//increment X
	always @(posedge clock) begin

		if(reset || finished)begin
			movingX <= 0;
		end
		else if (enable_draw) begin 
			if(movingX == WIDTH - 1) begin //width - 1
				movingX <= 0;
			end 
			else begin
				movingX <= movingX + 1;
			end
			
		end
	end
//
	//increment Y
	always @(posedge clock) begin
		
		if(reset || finished)begin
			movingY <= 0;
			finished <= 0;
			yCounter <= 0;
		end
		else if (enable_draw) begin
			if(yCounter == WIDTH * WIDTH - 1) begin // width * 10 - 1
				yCounter <= 0;
				movingY <= 0;
				finished <= 1;
			end
			else if((yCounter+1) % WIDTH == 0 && yCounter != 0)begin // replace 10 with width
				movingY <= movingY + 1;
				yCounter <= yCounter + 1;
			end
			else begin
				yCounter <= yCounter + 1;
			end
		end
	end
endmodule


