

//expecting x1,y1,col1 from foregnd, x2,y2,col2 from backgnd. outputs go to VGAmod. mux selected with backgroundsel, foreground sel, and continue. plot_enable fed through & AND'd to allow for ANTIcolour ignore effect
module colourGate(x1, x2, y1, y2, colour1, colour2, oX, oY, oColour, backgroundSelect, foregroundSelect, ANDplot_enable, plot_enable, gated_plot_enable);

    input [9:0] x1, x2;
    input [8:0] y1, y2;
    input [2:0] colour1 , colour2;
    input backgroundSelect, foregroundSelect, ANDplot_enable, plot_enable;

    output [9:0] oX;
    output [8:0] oY;
    output [2:0] oColour;
    output gated_plot_enable;

    assign oX[0] = (x1[0]) & (~backgroundSelect & foregroundSelect) | (x2[0]) & backgroundSelect & ~foregroundSelect;
    assign oY[0] = (y1[0]) & (~backgroundSelect & foregroundSelect) | (y2[0]) & backgroundSelect & ~foregroundSelect;
    assign oColour[0] = colour1[0] & (~backgroundSelect & foregroundSelect) | (colour2[0]) & backgroundSelect & ~foregroundSelect;

    assign oX[1] = (x1[1]) & (~backgroundSelect & foregroundSelect) | (x2[1]) & backgroundSelect & ~foregroundSelect;
    assign oY[1] = (y1[1]) & (~backgroundSelect & foregroundSelect) | (y2[1]) & backgroundSelect & ~foregroundSelect;
    assign oColour[1] = colour1[1] & (~backgroundSelect & foregroundSelect) | (colour2[1]) & backgroundSelect & ~foregroundSelect;

    assign oX[2] = (x1[2]) & (~backgroundSelect & foregroundSelect) | (x2[2]) & backgroundSelect & ~foregroundSelect;
    assign oY[2] = (y1[2]) & (~backgroundSelect & foregroundSelect) | (y2[2]) & backgroundSelect & ~foregroundSelect;
    assign oColour[2] = colour1[2] & (~backgroundSelect & foregroundSelect) | (colour2[2]) & backgroundSelect & ~foregroundSelect;

    assign oX[3] = (x1[3]) & (~backgroundSelect & foregroundSelect) | (x2[3]) & backgroundSelect & ~foregroundSelect;
    assign oY[3] = (y1[3]) & (~backgroundSelect & foregroundSelect) | (y2[3]) & backgroundSelect & ~foregroundSelect;

    assign oX[4] = (x1[4]) & (~backgroundSelect & foregroundSelect) | (x2[4]) & backgroundSelect & ~foregroundSelect;
    assign oY[4] = (y1[4]) & (~backgroundSelect & foregroundSelect) | (y2[4]) & backgroundSelect & ~foregroundSelect;

    assign oX[5] = (x1[5]) & (~backgroundSelect & foregroundSelect) | (x2[5]) & backgroundSelect & ~foregroundSelect;
    assign oY[5] = (y1[5]) & (~backgroundSelect & foregroundSelect) | (y2[5]) & backgroundSelect & ~foregroundSelect;

    assign oX[6] = (x1[6]) & (~backgroundSelect & foregroundSelect) | (x2[6]) & backgroundSelect & ~foregroundSelect;
    assign oY[6] = (y1[6]) & (~backgroundSelect & foregroundSelect) | (y2[6]) & backgroundSelect & ~foregroundSelect;

    assign oX[7] = (x1[7]) & (~backgroundSelect & foregroundSelect) | (x2[7]) & backgroundSelect & ~foregroundSelect;
    assign oY[7] = (y1[7]) & (~backgroundSelect & foregroundSelect) | (y2[7]) & backgroundSelect & ~foregroundSelect;

    assign oX[8] = (x1[8]) & (~backgroundSelect & foregroundSelect) | (x2[8]) & backgroundSelect & ~foregroundSelect;
    assign oY[8] = (y1[8]) & (~backgroundSelect & foregroundSelect) | (y2[8]) & backgroundSelect & ~foregroundSelect;

    assign oX[9] = (x1[9]) & (~backgroundSelect & foregroundSelect) | (x2[9]) & backgroundSelect & ~foregroundSelect;

    assign gated_plot_enable = ANDplot_enable & plot_enable;

endmodule