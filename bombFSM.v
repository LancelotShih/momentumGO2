module bombFSM #(parameter N = 500) (clk, RbombPosX, RbombPosY, RbombButton, BbombPosX, BbombPosY, BbombButton, redPosX, bluePosX, redPosY, bluePosY, redStunEnable, blueStunEnable);
    input clk;
    
    input [3:0] RbombPosX, RbombPosY;
    input RbombButton;
    input [3:0] BbombPosX, BbombPosY;
    input BbombButton;
    input [3:0] redPosX, redPosY;
    input [3:0] bluePosX, bluePosY;

    // technically you don't need the positions of the players, but for my brain its easier to work with

    // input bombExploded;

    output reg redStunEnable = 0;
    output reg blueStunEnable = 0;
    // output stunIndicator = 0;

    reg [27:0] counterR = (N * 2) - 1;
    reg [27:0] counterB = (N * 2) - 1;

    wire redStunWire;
    wire blueStunWire;

    always @(posedge redStunWire, posedge blueStunWire) begin
        redStunEnable <= redStunWire;
        blueStunEnable <= blueStunWire;
    end
    
// handle blue stun timer
    always @(posedge clk) begin
        if(counterB == 0) begin
            blueStunEnable <= 0;
            counterB <= (N * 5) - 1;
        end
        else if (blueStunEnable) begin
            counterB <= counterB - 1;
        end
        else begin
            counterB <= (N * 5) - 1;
        end
    end

// handle red stun timer
    always @(posedge clk) begin
        if(counterR == 0) begin
            redStunEnable <= 0;
            counterR <= (N * 5) - 1;
        end
        else if (redStunEnable) begin
            counterR <= counterR - 1;
        end
        else begin
            counterR <= (N * 5) - 1;
        end

    end 

    checkStun R1(.clk(clk), .bombButton(BbombButton), .bombPosX(BbombPosX), .bombPosY(BbombPosY), .pPosX(redPosX), .pPosY(redPosY), .StunEnable(redStunWire));
    checkStun B1(.clk(clk), .bombButton(RbombButton), .bombPosX(RbombPosX), .bombPosY(RbombPosY), .pPosX(bluePosX), .pPosY(bluePosY), .StunEnable(blueStunWire));

endmodule

module checkStun(clk, bombButton, bombPosX, bombPosY, pPosX, pPosY, StunEnable);
    input clk;
    input bombButton;
    input [3:0] bombPosX;
    input [3:0] bombPosY;
    input [3:0] pPosX;
    input [3:0] pPosY;

    output reg StunEnable = 0;
    // 9 cases for 3x3 blast radius
    always @(posedge clk) begin
        StunEnable <= 0;
        if(bombButton) begin
            if( (pPosX == bombPosX && pPosY == bombPosY) ||  (pPosX == bombPosX && pPosY == bombPosY + 1) || (pPosX == bombPosX && pPosY == bombPosY - 1) ) begin
                StunEnable <= 1; // checks middle column
            end
            else if ( (pPosX - 1 == bombPosX && pPosY == bombPosY) ||  (pPosX - 1 == bombPosX && pPosY == bombPosY + 1) || (pPosX - 1 == bombPosX && pPosY == bombPosY - 1) ) begin
                StunEnable <= 1; // checks left column
            end
            else if ( (pPosX + 1 == bombPosX && pPosY == bombPosY) ||  (pPosX + 1 == bombPosX && pPosY == bombPosY + 1) || (pPosX + 1 == bombPosX && pPosY == bombPosY - 1) ) begin
                StunEnable <= 1; // checks right column
            end
        end

    end


    // note there is no turn off redStunEnable here, that is done through the counter
    // stunEnable either remains off, or turns on until turned off by the counter

endmodule