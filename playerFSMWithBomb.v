// module playerFSMToplevelTest(CLOCK_50, SW, KEY, LEDR, HEX0, HEX1, HEX2, HEX3);
//     input CLOCK_50;
//     input [9:0] SW;
//     input [3:0] KEY;
//     output [9:0] LEDR; 
//     output [6:0] HEX0; // player 1
//     output [6:0] HEX1; 
//     output [6:0] HEX2; // player 2
//     output [6:0] HEX3;
//     wire reset;
//     assign reset = SW[0];

//     wire [3:0] p1x;
//     wire [3:0] p1y;
//     wire p1b;

//     wire [3:0] p2x;
//     wire [3:0] p2y;
//     wire p2b;

//     wire stunRedEnable;
//     wire stunBlueEnable;

//     playerFSM p1(.clk(CLOCK_50), .reset(reset), .bombDropper(SW[1]), .color(3'b100), .stunnedStateWire(stunRedEnable), .directionUP(!KEY[3]), .directionDOWN(!KEY[2]), .directionLEFT(!KEY[1]), .directionRIGHT(!KEY[0]), .positionX(p1x), .positionY(p1y), .somethingPressed(LEDR[9]), .bombExploded(p1b), stunOtherGuyEnable(stunBlueEnable));
//     // not enough inputs, so test with onboard switches for now, and uncomment this when PS2 is hooked up
//     // playerFSM p2(.clk(CLOCK_50), .reset(reset), .bombDropper(SW[1]), .color(3'b100), .stunnedStateWire(stunRedEnable), .directionUP(!KEY[3]), .directionDOWN(!KEY[2]), .directionLEFT(!KEY[1]), .directionRIGHT(!KEY[0]), .positionX(p1x), .positionY(p1y), .somethingPressed(LEDR[9]), stunOtherGuyEnable(stunBlueEnable));
//     bombFSM b0(.clk(CLOCK_50), .RbombPosX(p1x), .RbombPosY(p1y), .RbombButton(p1b), .BbombPosX(p2x), .BbombPosY(p2y), .BbombButton(p2b), .redPosX(p1x), .bluePosX(p2x), .redPosY(p1y), .bluePosY(p2y), .redStunEnable(stunRedEnable), .blueStunEnable(stunBlueEnable));

//     hex_decoder h1(p1x, HEX0);
//     hex_decoder h2(p1y, HEX1);
//     hex_decoder h3(p2x, HEX2);
//     hex_decoder h4(p2y, HEX3);

// endmodule


module playerFSM #(parameter N = 500) (clk, reset, bombDropper, color, stunnedStateWire, directionUP, directionDOWN, directionLEFT, directionRIGHT, positionX, positionY, somethingPressed, bombExploded);
    input clk;
    input reset;
    input directionUP;
    input directionDOWN;
    input directionLEFT;
    input directionRIGHT;
    input bombDropper;
    input [2:0] color;
    input stunnedStateWire;
    //input doneWire;

    output reg [3:0] positionX = 0;
    output reg [3:0] positionY = 0;
    output reg somethingPressed;
    output reg bombExploded;


    reg [5:0] current_state, next_state;
    //reg [25:0] bufferCounter = 50000000 / 120;
    
    localparam 
        stationary       = 5'd0,
        moveUP           = 5'd1,
        moveUPwait       = 5'd2,
        moveDOWN         = 5'd3,
        moveDOWNwait     = 5'd4,
        moveLEFT         = 5'd5,
        moveLEFTwait     = 5'd6,
        moveRIGHT        = 5'd7,
        moveRIGHTwait    = 5'd8,
        stunned          = 5'd9,
        droppingBomb     = 5'd10,
        droppingBombWait = 5'd11;

    // create a bomb cooldown timer 
    reg bombCooldown = 0; // 1 means ready to use, 0 means its on cooldown
    reg [27:0] cooldownCounter = (N * 5) - 1; // 5 second cooldown, 2 second stun, initial condition provided so players don't just immediately stun eachother
    
    always@(posedge clk) begin
        if(cooldownCounter == 0) begin
            bombCooldown <= 1;
        end
        else
            cooldownCounter <= cooldownCounter - 1; 
    end

    // encode the direction inputs for the FSM to use
    reg [3:0] dpad;
    reg dpadEnable;

    always@(posedge clk) begin
        if(stunnedStateWire) begin
            // do nothing
        end
        else begin
            //dpadEnable = 0;
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
            else if(bombDropper && bombCooldown) begin // dpad can only be set to bomb state if the cooldown is finished
                dpad = 5;
                bombCooldown <= 0;
                cooldownCounter <= (N * 5) - 1; // dropping a bomb resets the cooldown 
            end
            else 
                dpad = 0;
            //dpadEnable = 1;
        end
    end



    // Next state logic aka our state table
    always@(posedge clk)
    begin: state_table
        //if(dpadEnable) begin
            case(current_state)
                stationary: next_state = (dpad == 1) ? moveUP : (dpad == 2) ? moveDOWN : (dpad == 3) ? moveLEFT : (dpad == 4) ? moveRIGHT : (dpad == 5) ? droppingBomb : (dpad == 0) ? stationary : stationary;
                moveUP: next_state = (dpad == 1) ? moveUPwait : stationary;
                moveUPwait: next_state = (dpad == 1) ? moveUPwait : stationary;
                moveDOWN: next_state = (dpad == 2) ? moveDOWNwait : stationary;
                moveDOWNwait: next_state = (dpad == 2) ? moveDOWNwait : stationary;
                moveLEFT: next_state = (dpad == 3) ? moveLEFTwait : stationary;
                moveLEFTwait: next_state = (dpad == 3) ? moveLEFTwait : stationary;
                moveRIGHT: next_state = (dpad == 4) ? moveRIGHTwait : stationary;
                moveRIGHTwait: next_state = (dpad == 4) ? moveRIGHTwait : stationary;
                stunned: next_state = (stunnedStateWire) ? stunned : stationary;
                droppingBomb: next_state = (dpad == 5) ? droppingBombWait : stationary;
                droppingBombWait: next_state = (dpad == 5) ? droppingBombWait : stationary;
                default: next_state = stationary;
            endcase
        //end
    end

    // output logic aka all of our datapath control signals
    always@(posedge clk) // you can change the pixel range you want the player to move in here
    begin: enable_signals
        bombExploded <= 0;
        if(reset) begin
            positionX <= 0;
            positionY <= 0;
            bombExploded <= 0;
        end
        else begin
            case (current_state)
                stationary: begin
                    somethingPressed <= 0;
                    bombExploded <= 0;
                end
                moveUP: begin
                    if(positionY > 0 && positionY <= 4'b1111) begin
                        positionY <= positionY - 1; 
                        somethingPressed <= 1;
                    end
                end
                moveDOWN: begin
                    if(positionY >= 0 && positionY < 4'b1111) begin
                        positionY <= positionY + 1;
                        somethingPressed <= 1;
                    end
                end
                moveLEFT: begin
                    if(positionX > 0 && positionX <= 4'b1111) begin
                        positionX <= positionX - 1;
                        somethingPressed <= 1;
                    end
                end
                moveRIGHT: begin
                    if(positionX >= 0 && positionX < 4'b1111) begin
                        positionX <= positionX + 1;
                        somethingPressed <= 1;
                    end
                end
                droppingBomb: begin
                    bombExploded <= 1;
                end
            endcase
        end
        // possibly a default case is needed?
    end
    

    // current_state registers
    always@(*)
    begin: state_FFs
        if(reset)
            current_state <= stationary;
        else 
            current_state <= next_state;
    end

endmodule
