module momentumGO(CLOCK_50, PS2_CLK, PS2_DAT, KEY, SW, VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N, VGA_R, VGA_G, VGA_B, HEX0, HEX1, HEX2, HEX3);
    input CLOCK_50;
    input PS2_CLK;
    input PS2_DAT;
    input [3:0] KEY;
    input [9:0] SW;
    
    output VGA_CLK;						//	VGA Clock
    output VGA_HS;							//	VGA H_SYNC
    output VGA_VS;							//	VGA V_SYNC
    output VGA_BLANK_N;						//	VGA BLANK
    output VGA_SYNC_N;						//	VGA SYNC
    output [7:0] VGA_R;   						//	VGA Red[9:0]
    output [7:0] VGA_G;	 						//	VGA Green[9:0]
    output [7:0] VGA_B;

    output [6:0] HEX0;
    output [6:0] HEX1;
    output [6:0] HEX2;
    output [6:0] HEX3;

    wire [10:0] positionXred;
    wire [10:0] positionYred;
    wire directionUP;
    wire directionDOWN;
    wire directionLEFT;
    wire directionRIGHT;
    wire somethingPressed;
    wire doneDraw;
    wire plot_enable = 1;
    wire [2:0] colour;
    wire [10:0] x;
    wire [10:0] y;

    // vga_adapter VGA(
    //         .resetn(resetn),
    //         .clock(CLOCK_50),
    //         .colour(colour),
    //         .x(x),
    //         .y(y),
    //         .plot(plot_enable),
    //         /* Signals for the DAC to drive the monitor. */
    //         .VGA_R(VGA_R),
    //         .VGA_G(VGA_G),
    //         .VGA_B(VGA_B),
    //         .VGA_HS(VGA_HS),
    //         .VGA_VS(VGA_VS),
    //         .VGA_BLANK(VGA_BLANK_N),
    //         .VGA_SYNC(VGA_SYNC_N),
    //         .VGA_CLK(VGA_CLK));
    //     defparam VGA.RESOLUTION = "320x240";
    //     defparam VGA.MONOCHROME = "FALSE";
    //     defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
    //     defparam VGA.BACKGROUND_IMAGE = "background.mif";
        
    // assign resetn = SW[0];

    
    // our data comes from PS2 keyboard, load in data from it, get out a direction button pushed
    // PS2Input p1(PS2_CLK, PS2_DAT, directionUP, directionDOWN, directionLEFT, directionRIGHT);

    // if for whatever reason, PS2 does not want to work, we use keys 0 to 3 to act as directional inputs
    assign directionUP = !KEY[3];
    assign directionDOWN = !KEY[2];
    assign directionLEFT = !KEY[1];
    assign directionRIGHT = !KEY[0];

    // hex_decoder u0(positionXred[3:0], HEX0);
    // hex_decoder u1(positionXred[7:4], HEX1);
    // hex_decoder u2(positionXred[10:8], HEX2);

    

    // game logic
    playerFSM redPlayer(.clk(CLOCK_50), .reset(!resetn), .directionUP(directionUP), .directionDOWN(directionDOWN), .directionLEFT(directionLEFT), .directionRIGHT(directionRIGHT), .positionXred(positionXred), .positionYred(positionYred), .somethingPressed(somethingPressed));
    // playerFSM bluePlayer(CLOCK_50, directionUP, directionDOWN, directionLEFT, directionRIGHT, positionXblue, positionYblue);

    // draws the current state of the players
    drawer drawRed(.clk(CLOCK_50), .reset(!resetn), .somethingPressed(somethingPressed), .initX(positionXred), .initY(positionYred), .positionXred(x), .positionYred(y), .color(colour));

    // wire it together to the vga display output

endmodule

// module PS2Input(PS2_CLK, PS2_DAT, directionUP, directionDOWN, directionLEFT, directionRIGHT);
//     input PS2_CLK;
//     input PS2_DAT;

//     output directionUP;
//     output directionDOWN;
//     output directionLEFT;
//     output directionRIGHT;

//     // 40'b1001\0001\0111\0000\0111\0001\1011\0001\1000\1000;
//     reg [39:0] redButtons  = 40'b1001000101110000011100011011000110001000;
//     reg [7:0] stop = 8'b00011111;

//     reg [31:0] keyboard = 0;
//     reg [4:0] counter = 8;

//     reg sendEnable;

//     always @(negedge PS2_CLK) begin
//         keyboard = (keyboard << 1) | PS2_DAT;
//         if (counter == 0) begin
//             sendEnable <= 1;
//             counter <= 19;
//         end
//         else begin
//             sendEnable <= 0;
//             counter <= counter - 1;
//         end
//     end

//     always@(posedge clk) begin
//         if (keyboard[19:12] == stop && sendEnable) begin
//             directionLeft <= 0;
//             directionRight <= 0;
//             directionUp <= 0;
//             directionDown <= 0; 
//         end
//         else if (keyboard[8:1] == colorButtons[31:24] && sendEnable) begin // insert bit representation here for LEFT
//             directionLeft <= 1;
//             directionRight <= 0;
//             directionUp <= 0;
//             directionDown <= 0; 
//         end
//         else if (keyboard[8:1] == colorButtons[23:16] && sendEnable) begin // insert bit representation here for RIGHT
//             directionLeft <= 0;
//             directionRight <= 1;
//             directionUp <= 0;
//             directionDown <= 0;
//         end
//         else if (keyboard[8:1] == colorButtons[15:8] && sendEnable) begin// insert bit representation here for UP
//             directionLeft <= 0;
//             directionRight <= 0;
//             directionUp <= 1;
//             directionDown <= 0;
//         end
//         else if (keyboard[8:1] == colorButtons[7:0] && sendEnable) begin// insert bit representation here for DOWN
//             directionLeft <= 0;
//             directionRight <= 0;
//             directionUp <= 0;
//             directionDown <= 1;
//         end
//         else begin// resets if direction input to be 0 otherwise
//             directionLeft <= 0;
//             directionRight <= 0;
//             directionUp <= 0;
//             directionDown <= 0;
//             bombButton <= 0;
//         end
//     end

// endmodule

// module playerFSM(clk, reset, directionUP, directionDOWN, directionLEFT, directionRIGHT, positionXred, positionYred, somethingPressed);
//     input clk;
//     input reset;
//     input directionUP;
//     input directionDOWN;
//     input directionLEFT;
//     input directionRIGHT;
//     //input doneWire;

//     output reg [10:0] positionXred = 0;
//     output reg [10:0] positionYred = 0;
//     output reg somethingPressed = 0;

//     reg [5:0] current_state, next_state;
    
//     localparam 
//         stationary    = 5'd0,
//         moveUP        = 5'd1,
//         moveUPwait    = 5'd2,
//         moveDOWN      = 5'd3,
//         moveDOWNwait  = 5'd4,
//         moveLEFT      = 5'd5,
//         moveLEFTwait  = 5'd6,
//         moveRIGHT     = 5'd7,
//         moveRIGHTwait = 5'd8;

//     // encode the direction inputs for the FSM to use
//     reg [3:0] dpad;
//     always@(*) begin
//         if(directionUP == 1)
//             dpad <= 4'b0001; // 1
//         else if(directionDOWN == 1)
//             dpad <= 4'b0010; // 2
//         else if(directionLEFT == 1)
//             dpad <= 4'b0100; // 4
//         else if(directionRIGHT == 1)
//             dpad <= 4'b1000; // 8
//         else 
//             dpad <= 4'b0000;
//     end

//     // always@(*) begin
//     //     if(doneWire)
//     //         somethingPressed = 0;
//     // end


//     // Next state logic aka our state table
//     always@(*)
//     begin: state_table
//         case(current_state)
//             stationary: next_state <= (dpad == 4'b0001) ? moveUP : (dpad == 4'b0010) ? moveDOWN : (dpad == 4'b0100) ? moveLEFT : (dpad == 4'b1000) ? moveRIGHT : stationary;
//             moveUP: next_state <= (dpad == 4'b0001) ? moveUPwait : stationary;
//             moveUPwait: next_state <= (dpad == 4'b0001) ? moveUPwait : stationary;
//             moveDOWN: next_state <= (dpad == 4'b0010) ? moveDOWNwait : stationary;
//             moveDOWNwait: next_state <= (dpad == 4'b0010) ? moveDOWNwait : stationary;
//             moveLEFT: next_state <= (dpad == 4'b0100) ? moveLEFTwait : stationary;
//             moveLEFTwait: next_state <= (dpad == 4'b0100) ? moveLEFTwait : stationary;
//             moveRIGHT: next_state <= (dpad == 4'b1000) ? moveRIGHTwait : stationary;
//             moveRIGHTwait: next_state <= (dpad == 4'b1000) ? moveRIGHTwait : stationary;
//             default: next_state <= stationary;
//         endcase
//     end

//     // output logic aka all of our datapath control signals
//     always@(*) // you can change the pixel range you want the player to move in here
//     begin: enable_signals
//         case (current_state)
//             stationary: begin
//                 positionXred <= positionXred;
//                 positionYred <= positionYred;
//                 somethingPressed <= 0;
//             end
//             moveUP: begin
//                 if(positionYred > 9)
//                     positionYred <= positionYred - 4'd10; // moves player up by 10 pixels
//                     somethingPressed <= 1;
//             end
//             moveDOWN: begin
//                 if(positionYred < 231)
//                     positionYred <= positionYred + 4'd10;
//                     somethingPressed <= 1;
//             end
//             moveLEFT: begin
//                 if(positionXred > 9)
//                     positionXred <= positionXred - 4'd10;
//                     somethingPressed <= 1;
//             end
//             moveRIGHT: begin
//                 if(positionXred < 311)
//                     positionXred <= positionXred + 4'd10;
//                     somethingPressed <= 1;
//             end
//         endcase
        
//         // possibly a default case is needed?
//     end
//     // current_state registers
//     always@(posedge clk)
//     begin: state_FFs
//         if(reset)
//             current_state <= stationary;
//         else 
//             current_state <= next_state;
//     end

// endmodule

module drawer(clk, reset, initX, initY, somethingPressed, positionXred, positionYred, color);
    input clk;
    input reset;
    input [10:0] initX;
    input [10:0] initY;
    input somethingPressed;

    output [10:0] positionXred;
    output [10:0] positionYred;
    output reg [2:0] color = 3'b100;

    wire [7:0] addressWire;


    addressCounter a0(.clk(clk), .reset(reset), .enable(somethingPressed), .address(addressWire), .doneAll(doneWire));
    // testSprite2 t0(.address(addressWire), .clock(clk), .q(color)); // get 1 new pixel rgb value per clock --> goes into colour inside FSM
    addressToPosition a1(.address(addressWire), .initX(initX), .initY(initY), .positionX(positionXred), .positionY(positionYred));

endmodule


// ********************************* supplementary modules ******************************//

//
//module addressCounter(clk, reset, enable, address, doneAll); 
//
// 	input clk, reset, enable;
// 	output reg [7:0] address = 0;
//	output reg doneAll; 
//	
//
//	always@(posedge clk) 
//	begin
//		if(reset)
//		begin
//			doneAll <= 0;
//			address <= 0;
//		end
//		else if(enable) //
//		begin
//			if(address == 99) begin
//				doneAll <= 1;
//				address <= 0;
//			end
//			else begin
//				doneAll <= 0;
//				address <= address + 1;
//			end
//		end
//	end
// endmodule
//
//
//module addressToPosition(address, initX, initY, positionX, positionY);
//    input [7:0] address;
//    input [10:0] initX;
//    input [10:0] initY;
//    output [10:0] positionX;
//    output [10:0] positionY;
//
//    assign positionX = (address % 10) + initX;
//    assign positionY = ((address - (address % 10)) / 10) + initY;
//endmodule