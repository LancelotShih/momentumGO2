module playerFSMToplevelTest(CLOCK_50, SW, KEY, LEDR, HEX0, HEX1, HEX2, HEX3);
    input CLOCK_50;
    input [9:0] SW;
    input [3:0] KEY;
    output [9:0] LEDR; 
    output [6:0] HEX0; // player 1
    output [6:0] HEX1; 
    output [6:0] HEX2; // player 2
    output [6:0] HEX3;

    wire reset;
    assign reset = SW[0];

    wire [3:0] p1x;
    wire [3:0] p2x;
    wire [3:0] p1y;
    wire [3:0] p2y;

    playerFSM p1(.clk(CLOCK_50), .reset(reset), .directionUP(!KEY[3]), .directionDOWN(!KEY[2]), .directionLEFT(!KEY[1]), .directionRIGHT(!KEY[0]), .positionX(p1x), .positionY(p1y), .somethingPressed(LEDR[9]));
    
    hex_decoder h1(p1x, HEX0);
    hex_decoder h2(p1y, HEX1);
    hex_decoder h3(p2x, HEX2);
    hex_decoder h4(p2y, HEX3);

endmodule

module playerFSM(clk, reset, directionUP, directionDOWN, directionLEFT, directionRIGHT, positionX, positionY, somethingPressed);
    input clk;
    input reset;
    input directionUP;
    input directionDOWN;
    input directionLEFT;
    input directionRIGHT;
    //input doneWire;

    output reg [3:0] positionX = 0;
    output reg [3:0] positionY = 0;
    output reg somethingPressed;

    reg [5:0] current_state, next_state;
    //reg [25:0] bufferCounter = 50000000 / 120;
    
    localparam 
        stationary    = 5'd0,
        moveUP        = 5'd1,
        moveUPwait    = 5'd2,
        moveDOWN      = 5'd3,
        moveDOWNwait  = 5'd4,
        moveLEFT      = 5'd5,
        moveLEFTwait  = 5'd6,
        moveRIGHT     = 5'd7,
        moveRIGHTwait = 5'd8;


    // always@(*) begin
    //     if(reset) begin
    //         positionX <= 0;
    //         positionY <= 0;
    //         somethingPressed <= 0;
    //     end
    // end

    // encode the direction inputs for the FSM to use
    reg [3:0] dpad;
    reg dpadEnable;
    always@(posedge clk) begin
        dpadEnable = 0;
        if(reset) begin
            dpad = 0;
        end
        else if(directionUP == 1 && directionDOWN == 0 && directionLEFT == 0 && directionRIGHT == 0)
            dpad = 1; // 1
        else if(directionUP == 0 && directionDOWN == 1 && directionLEFT == 0 && directionRIGHT == 0)
            dpad = 2; // 2
        else if(directionUP == 0 && directionDOWN == 0 && directionLEFT == 1 && directionRIGHT == 0)
            dpad = 3; // 4
        else if(directionUP == 0 && directionDOWN == 0 && directionLEFT == 0 && directionRIGHT == 1)
            dpad = 4; // 8
        else 
            dpad = 0;
        dpadEnable = 1;
    end

    // Next state logic aka our state table
    always@(posedge clk)
    begin: state_table
        if(dpadEnable) begin
            case(current_state)
                stationary: next_state = (dpad == 1) ? moveUP : (dpad == 2) ? moveDOWN : (dpad == 3) ? moveLEFT : (dpad == 4) ? moveRIGHT : (dpad == 0) ? stationary : stationary;
                moveUP: next_state = (dpad == 1) ? moveUPwait : stationary;
                moveUPwait: next_state = (dpad == 1) ? moveUPwait : stationary;
                moveDOWN: next_state = (dpad == 2) ? moveDOWNwait : stationary;
                moveDOWNwait: next_state = (dpad == 2) ? moveDOWNwait : stationary;
                moveLEFT: next_state = (dpad == 3) ? moveLEFTwait : stationary;
                moveLEFTwait: next_state = (dpad == 3) ? moveLEFTwait : stationary;
                moveRIGHT: next_state = (dpad == 4) ? moveRIGHTwait : stationary;
                moveRIGHTwait: next_state = (dpad == 4) ? moveRIGHTwait : stationary;
                default: next_state = stationary;
            endcase
        end
    end



    // always@(*)
    // begin: state_table
    //     case(current_state)
    //         stationary: next_state = (dpad == 4'b0001) ? moveUP : (dpad == 4'b0010) ? moveDOWN : (dpad == 4'b0100) ? moveLEFT : (dpad == 4'b1000) ? moveRIGHT : stationary;
    //         moveUP: next_state = (dpad == 4'b0001) ? moveUPwait : stationary;
    //         moveUPwait: next_state = (dpad == 4'b0001) ? moveUPwait : buffer;
    //         moveDOWN: next_state = (dpad == 4'b0010) ? moveDOWNwait : stationary;
    //         moveDOWNwait: next_state = (dpad == 4'b0010) ? moveDOWNwait : buffer;
    //         moveLEFT: next_state = (dpad == 4'b0100) ? moveLEFTwait : stationary;
    //         moveLEFTwait: next_state = (dpad == 4'b0100) ? moveLEFTwait : buffer;
    //         moveRIGHT: next_state = (dpad == 4'b1000) ? moveRIGHTwait : stationary;
    //         moveRIGHTwait: next_state = (dpad == 4'b1000) ? moveRIGHTwait : buffer;
    //         buffer: next_state = bufferFinish ? stationary : buffer;
    //         default: next_state = stationary;
    //     endcase
    // end

    // output logic aka all of our datapath control signals
    always@(posedge clk) // you can change the pixel range you want the player to move in here
    begin: enable_signals
        if(reset) begin
            positionX <= 0;
            positionY <= 0;
        end
        else begin
            case (current_state)
                stationary: begin
                    somethingPressed = 0;
                end
                moveUP: begin
                    if(positionY > 0 && positionY <= 4'b1111) begin
                        positionY <= positionY - 1; 
                        somethingPressed = 1;
                    end
                end
                moveDOWN: begin
                    if(positionY >= 0 && positionY < 4'b1111) begin
                        positionY <= positionY + 1;
                        somethingPressed = 1;
                    end
                end
                moveLEFT: begin
                    if(positionX > 0 && positionX <= 4'b1111) begin
                        positionX <= positionX - 1;
                        somethingPressed = 1;
                    end
                end
                moveRIGHT: begin
                    if(positionX >= 0 && positionX < 4'b1111) begin
                        positionX <= positionX + 1;
                        somethingPressed = 1;
                    end
                end
            endcase
        end
        // possibly a default case is needed?
    end
    
    // wire bufferEnable, bufferDone;
    // buffer(.clk(clk), .reset(reset), .enable(bufferEnable), .done(bufferDone));

    // always@(*) // you can change the pixel range you want the player to move in here
    // begin: enable_signals
    //     bufferEnable = 0;
    //     case (current_state)
    //         stationary: begin
    //             positionX = positionX;
    //             positionY = positionY;
    //             somethingPressed = 0;
    //         end
    //         moveUP: begin
    //             if(positionY > 0) begin
    //                 positionY = positionY - 1; // moves player up by 10 pixels
    //                 somethingPressed = 1;
    //             end
    //         end
    //         moveDOWN: begin
    //             if(positionY < 16) begin
    //                 positionY = positionY + 1;
    //                 somethingPressed = 1;
    //             end
    //         end
    //         moveLEFT: begin
    //             if(positionX > 0) begin
    //                 positionX = positionX - 1;
    //                 somethingPressed = 1;
    //             end
    //         end
    //         moveRIGHT: begin
    //             if(positionX < 16) begin
    //                 positionX = positionX + 1;
    //                 somethingPressed = 1;
    //             end
    //         end
    //         buffer: begin
    //             bufferEnable = 1;
    //         end
    //     endcase
        
    //     // possibly a default case is needed?
    //     end

    // current_state registers
    always@(*)
    begin: state_FFs
        if(reset)
            current_state <= stationary;
        else 
            current_state <= next_state;
    end

endmodule



// ************************************** SUPPLEMENTARY MODULES ***************************************************
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
			if(buffer_counter == 50000000/120 - 1) //60Hz = 50000000 / 60 - 1
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
