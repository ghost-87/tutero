# tutero

Flutter app like Trello

## Getting Started

As not allowed to use any packages from pub.dev, draggable widget were difficult for me. 
I have given the functionalities where the cards can be rearranged among the available boards by going thorugh them one by one. Please follow the arrows available in each card and below notes how to use them.
Cards can be reorganized horizontally / vertically. 
This application will delete all data once refreshed.

## Points to Follow

1) There are Boards, each capable of creating their own cards.
2) Each cards will have their own set of icons for their functionalities.
2.1) " < " will move the card to adjacent left board.
2.3) " > " will move the card to adjacent right board.
2.1) " ^ " will move the card to one index above in its current board.
2.1) " v " will move the card to one index below in its current board.

3) you can delete and add the cards and boards both. 
3.1) a new card can be added from the " + " icon in the board itself.
3.2) a new board can be added via the floating button widget available in bottom right.

