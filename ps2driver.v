// use first PS2Input for showcase on the hexdecoder and LEDs, use the second PS2Input for the FSM wires

// module PS2Input(CLOCK_50, PS2_CLK, PS2_DAT, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR);
//     input CLOCK_50;
//     input PS2_CLK;
//     input PS2_DAT;
//     // input color;
//     output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
//     output [9:0] LEDR;
//     // output directionUP, directionDOWN, directionLEFT, directionRIGHT, bombButton;


//         //reg [39:0] blueButtons = 40'b1001 1001 1000 0101 1000 0100 1010 0101 1011 1000
//     reg [39:0] blueButtons = 40'b1001100110000101100001001010010110111000;
//         //reg [39:0] redButtons  = 40'b1001 0001 1011 0001 0111 0001 1000 1000 0111 0000
//     reg [39:0] redButtons  = 40'b1001000110110001011100011000100001110000;

//     reg [7:0] stop = 8'b00011111;

//     reg [32:0] keyboard = 0;
//     reg [4:0] counter = 10;
//     reg [4:0] bigCounter = 10000;
//     reg sendEnable;
//     reg sendChecker = 0;
//     // output [7:0] recievedData;
//     // output recievedEnable;

//     always @(negedge PS2_CLK) begin
//         keyboard = (keyboard << 1) | PS2_DAT;
//         if (counter == 2 && keyboard[8:1] != stop) begin
//             sendEnable <= 1;
//             counter <= counter - 1;
//         end
//         else if (counter == 0) begin
//             counter <= 10;
//         end
//         else begin
//             sendEnable <= 0;
//             counter <= counter - 1;
//         end
//     end

//     always @(posedge sendEnable) begin
//         sendChecker <= !sendChecker;
//     end

//     // always @(negedge PS2_CLK) begin
//     //     keyboard = (keyboard << 1) | PS2_DAT;
//     // end

//     // PS2_Controller u0(CLOCK_50, 0, keyboard[7:0], sendEnable, PS2_CLK, PS2_DAT, receivedData, recievedEnable);
//     //wire w1, w2, w3, w4;

//     hex_decoder u1(keyboard[4:1], HEX0);
//     hex_decoder u2(keyboard[8:5], HEX1);
//     hex_decoder u3(keyboard[15:12], HEX2);
//     hex_decoder u4(keyboard[19:16], HEX3);
//     hex_decoder u5(keyboard[26:23], HEX4);
//     hex_decoder u6(keyboard[30:27], HEX5); // we want to make sure that this is the one we read

//     // PS2decoder u7(CLOCK_50, keyboard, blueButtons, stop, directionLEFT, directionRIGHT, directionUP, directionDOWN, bombButton);
//     // PS2decoder u8(CLOCK_50, keyboard, redButtons, stop, directionLEFT, directionRIGHT, directionUP, directionDOWN, bombButton);
//     PS2decoder u7(sendEnable, CLOCK_50, keyboard, blueButtons, stop, LEDR[0], LEDR[1], LEDR[2], LEDR[3], LEDR[4]);
//     //PS2decoder u8(sendEnable, CLOCK_50, keyboard, redButtons, stop, LEDR[5], LEDR[6], LEDR[7], LEDR[8], LEDR[9]);
//     assign LEDR[9] = sendChecker;


// endmodule


module PS2Input(CLOCK_50, PS2_CLK, PS2_DAT, RdirectionUP, RdirectionDOWN, RdirectionLEFT, RdirectionRIGHT, RbombButton, BdirectionUP, BdirectionDOWN, BdirectionLEFT, BdirectionRIGHT, BbombButton);
    input CLOCK_50;
    input PS2_CLK;
    input PS2_DAT;
    // input color;
    // output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    // output [9:0] LEDR;
    output RdirectionUP, RdirectionDOWN, RdirectionLEFT, RdirectionRIGHT, RbombButton;
    output BdirectionUP, BdirectionDOWN, BdirectionLEFT, BdirectionRIGHT, BbombButton;


    // 1001 0001 1010 0101 1011 1000 1000 0101 1000 0100 (bomb right left down up) (read as up down left right bomb)
    reg [39:0] blueButtons = 40'b1001000110100101101110001000010110000100;
    // 1001 0001 1000 1000 0111 0000 1011 0001 0111 0001 (bomb right left down up) (read as up down left right bomb)
    reg [39:0] redButtons  = 40'b1001000110001000011100001011000101110001;

    reg [7:0] stop = 8'b00011111;

    reg [32:0] keyboard = 0;
    reg [4:0] counter = 11;
    reg [4:0] bigCounter = 10000;
    reg sendEnable;
    reg sendChecker = 0;
    // output [7:0] recievedData;
    // output recievedEnable;

    always @(negedge PS2_CLK) begin
        keyboard = (keyboard << 1) | PS2_DAT;
        if (counter == 2 && keyboard[8:1] != stop) begin
            sendEnable <= 1;
            counter <= counter - 1;
        end
        else if (counter == 0) begin
            counter <= 10;
        end
        else begin
            sendEnable <= 0;
            counter <= counter - 1;
        end
    end

    always @(posedge sendEnable) begin
        sendChecker <= !sendChecker; // a latch that checks whether or not our keyboard is being read at steady intervals
    end

    // always @(negedge PS2_CLK) begin
    //     keyboard = (keyboard << 1) | PS2_DAT;
    // end

    // PS2_Controller u0(CLOCK_50, 0, keyboard[7:0], sendEnable, PS2_CLK, PS2_DAT, receivedData, recievedEnable);
    //wire w1, w2, w3, w4;

    // hex_decoder u1(keyboard[4:1], HEX0);
    // hex_decoder u2(keyboard[8:5], HEX1);
    // hex_decoder u3(keyboard[15:12], HEX2);
    // hex_decoder u4(keyboard[19:16], HEX3);
    // hex_decoder u5(keyboard[26:23], HEX4);
    // hex_decoder u6(keyboard[30:27], HEX5); // we want to make sure that this is the one we read

    // PS2decoder u7(CLOCK_50, keyboard, blueButtons, stop, directionLEFT, directionRIGHT, directionUP, directionDOWN, bombButton);
    // PS2decoder u8(CLOCK_50, keyboard, redButtons, stop, directionLEFT, directionRIGHT, directionUP, directionDOWN, bombButton);
    PS2decoder r1(.sendEnable(sendEnable), .clk(CLOCK_50), .keyboard(keyboard), .colorButtons(redButtons) , .stop(stop), .directionUp(RdirectionUP), .directionDown(RdirectionDOWN), .directionLeft(RdirectionLEFT), .directionRight(RdirectionRIGHT), .bombButton(RbombButton));
    PS2decoder b1(.sendEnable(sendEnable), .clk(CLOCK_50), .keyboard(keyboard), .colorButtons(blueButtons), .stop(stop), .directionUp(BdirectionUP), .directionDown(BdirectionDOWN), .directionLeft(BdirectionLEFT), .directionRight(BdirectionRIGHT), .bombButton(BbombButton));
    
    // assign LEDR[9] = sendChecker;


endmodule


// module PS2Input(CLOCK_50, PS2_CLK, PS2_DAT, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR[9:0]);
//     input CLOCK_50;
//     input PS2_CLK;
//     input PS2_DAT;
//     output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
//     output [9:0] LEDR;

//     //reg [39:0] blueButtons = 40'b0101\0001\1010\1100\0101\1101\0101\1100\1001\1101;
//     reg [39:0] blueButtons = 40'b0101000110101100010111010101110010011101;
//     reg [7:0] stop = 8'b00011111;
//     //reg [39:0] redButtons  = 40'b1001000101110000011100011011000110001000;
//     reg [39:0] redButtons  = 40'b1001000101110000011100011011000110001000;

//     reg [31:0] keyboard = 0;
//     reg [4:0] counter = 8;
//     reg sendEnable;
//     // output [7:0] recievedData;
//     // output recievedEnable;

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

//     // always @(negedge PS2_CLK) begin
//     //     keyboard = (keyboard << 1) | PS2_DAT;
//     // end

//     // PS2_Controller u0(CLOCK_50, 0, keyboard[7:0], sendEnable, PS2_CLK, PS2_DAT, receivedData, recievedEnable);
//     //wire w1, w2, w3, w4;

//     hex_decoder u1(keyboard[4:1], HEX0);
//     hex_decoder u2(keyboard[8:5], HEX1);
//     hex_decoder u3(keyboard[15:12], HEX2);
//     hex_decoder u4(keyboard[19:16], HEX3);
//     hex_decoder u5(keyboard[26:23], HEX4);
//     hex_decoder u6(keyboard[30:27], HEX5); // we want to make sure that this is the one we read

//     PS2decoder u7(CLOCK_50, keyboard, blueButtons, stop, LEDR[0], LEDR[1], LEDR[2], LEDR[3], LEDR[4]);
//     PS2decoder u8(CLOCK_50, keyboard, redButtons, stop, LEDR[5], LEDR[6], LEDR[7], LEDR[8], LEDR[9]);
//     // PS2decoder u7(sendEnable, CLOCK_50, keyboard, blueButtons, stop, LEDR[0], LEDR[1], LEDR[2], LEDR[3], LEDR[4]);
//     // PS2decoder u8(sendEnable, CLOCK_50, keyboard, redButtons, stop, LEDR[5], LEDR[6], LEDR[7], LEDR[8], LEDR[9]);


// endmodule

// module hex_decoder(c, display);
// 	input [3:0] c;
// 	output [6:0] display;
	
// 	assign display[0] = (c[0] & !c[1] & !c[2] & !c[3]) + (!c[0] & !c[1] & c[2] & !c[3]) + (c[0] & c[1] & !c[2] & c[3]) + (c[0] & !c[1] & c[2] & c[3]);
// 	assign display[1] = (c[0] & !c[1] & c[2] & !c[3]) + (!c[0] & c[1] & c[2] & !c[3]) + (c[0] & c[1] & !c[2] & c[3]) + (!c[0] & !c[1] & c[2] & c[3]) + (!c[0] & c[1] & c[2] & c[3]) + (c[0] & c[1] & c[2] & c[3]);
// 	assign display[2] = (!c[0] & c[1] & !c[2] & !c[3]) + (!c[0] & !c[1] & c[2] & c[3]) + (!c[0] & c[1] & c[2] & c[3]) + (c[0] & c[1] & c[2] & c[3]);
// 	assign display[3] = (c[0] & !c[1] & !c[2] & !c[3]) + (!c[0] & !c[1] & c[2] & !c[3]) + (c[0] & c[1] & c[2] & !c[3]) + (!c[0] & c[1] & !c[2] & c[3]) + (c[0] & c[1] & c[2] & c[3]);
// 	assign display[4] = (c[0] & !c[1] & !c[2] & !c[3]) + (c[0] & c[1] & !c[2] & !c[3]) + (!c[0] & !c[1] & c[2] & !c[3]) + (c[0] & !c[1] & c[2] & !c[3]) + (c[0] & c[1] & c[2] & !c[3]) + (c[0] & !c[1] & !c[2] & c[3]);
// 	assign display[5] = (c[0] & !c[1] & !c[2] & !c[3]) + (!c[0] & c[1] & !c[2] & !c[3]) + (c[0] & c[1] & !c[2] & !c[3]) + (c[0] & c[1] & c[2] & !c[3]) + (c[0] & !c[1] & c[2] & c[3]);
// 	assign display[6] = (!c[0] & !c[1] & !c[2] & !c[3]) + (c[0] & !c[1] & !c[2] & !c[3]) + (c[0] & c[1] & c[2] & !c[3]) + (!c[0] & !c[1] & c[2] & c[3]);
	
// endmodule

// module PS2decoder(sendEnable, clk, keyboard, colorButtons, stop, directionLeft, directionRight, directionUp, directionDown, bombButton);
//     input sendEnable;
//     input clk;  
//     input [31:0] keyboard;
//     input [39:0] colorButtons;
//     input [7:0] stop;

//     output reg directionLeft = 0;
//     output reg directionRight = 0;
//     output reg directionUp = 0;
//     output reg directionDown = 0;
//     output reg bombButton = 0;

//     always@(posedge clk) begin
//         if (keyboard[19:12] == stop && sendEnable) begin
//             directionLeft <= 0;
//             directionRight <= 0;
//             directionUp <= 0;
//             directionDown <= 0; 
//             bombButton <= 0;
//         end
//         else if (keyboard[8:1] == colorButtons[31:24] && sendEnable) begin // insert bit representation here for LEFT
//             directionLeft <= 1;
//             directionRight <= 0;
//             directionUp <= 0;
//             directionDown <= 0; 
//             bombButton <= 0;
//         end
//         else if (keyboard[8:1] == colorButtons[23:16] && sendEnable) begin // insert bit representation here for RIGHT
//             directionLeft <= 0;
//             directionRight <= 1;
//             directionUp <= 0;
//             directionDown <= 0;
//             bombButton <= 0;
//         end
//         else if (keyboard[8:1] == colorButtons[15:8] && sendEnable) begin// insert bit representation here for UP
//             directionLeft <= 0;
//             directionRight <= 0;
//             directionUp <= 1;
//             directionDown <= 0;
//             bombButton <= 0;
//         end
//         else if (keyboard[8:1] == colorButtons[7:0] && sendEnable) begin// insert bit representation here for DOWN
//             directionLeft <= 0;
//             directionRight <= 0;
//             directionUp <= 0;
//             directionDown <= 1;
//             bombButton <= 0;
//         end
//         else if (keyboard[8:1] == colorButtons[39:32] && sendEnable) begin// resets if direction input to be 0 otherwise
//             directionLeft <= 0;
//             directionRight <= 0;
//             directionUp <= 0;
//             directionDown <= 0;
//             bombButton <= 1;
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

module PS2decoder(sendEnable, clk, keyboard, colorButtons, stop, directionUp, directionDown, directionLeft, directionRight, bombButton);
    // reg sendEnable = 1;
    input sendEnable;
    input clk;  
    input [31:0] keyboard;
    input [39:0] colorButtons;
    input [7:0] stop;

    output reg directionLeft = 0;
    output reg directionRight = 0;
    output reg directionUp = 0;
    output reg directionDown = 0;
    output reg bombButton = 0;

    always@(posedge clk) begin
        if (keyboard[19:12] == stop && sendEnable) begin
            directionUp <= 0;
            directionDown <= 0;
            directionLeft <= 0;
            directionRight <= 0;
            bombButton <= 0;
        end
        else if (keyboard[8:1] == colorButtons[7:0] && sendEnable) begin // insert bit representation here for UP
            directionUp <= 1;
            directionDown <= 0;
            directionLeft <= 0;
            directionRight <= 0;
            bombButton <= 0;
        end
        else if (keyboard[8:1] == colorButtons[15:8] && sendEnable) begin // insert bit representation here for DOWN
            directionUp <= 0;
            directionDown <= 1;
            directionLeft <= 0;
            directionRight <= 0;
            bombButton <= 0;
        end
        else if (keyboard[8:1] == colorButtons[23:16] && sendEnable) begin// insert bit representation here for LEFT
            directionUp <= 0;
            directionDown <= 0;
            directionLeft <= 1;
            directionRight <= 0;
            bombButton <= 0;
        end
        else if (keyboard[8:1] == colorButtons[31:24] && sendEnable) begin// insert bit representation here for RIGHT
            directionUp <= 0;
            directionDown <= 0;
            directionLeft <= 0;
            directionRight <= 1;
            bombButton <= 0;
        end
        else if (keyboard[8:1] == colorButtons[39:32] && sendEnable) begin// insert bit representation here for BOMB
            directionLeft <= 0;
            directionRight <= 0;
            directionUp <= 0;
            directionDown <= 0;
            bombButton <= 1;
        end
        else begin// resets if direction input to be 0 otherwise
            directionUp <= 0;
            directionDown <= 0;
            directionLeft <= 0;
            directionRight <= 0;
            bombButton <= 0;
        end
    end

endmodule