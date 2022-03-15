# Adam Shirley
# bsa919adam@csu.fullerton.edu
## Hearts AI using Clips Inference Engine

### TO start 
1. Exectute (batch loader.bat) to load facts and rules
2. Use (add_card ?suit ?rank) to declare what your hand is
3. If you have two of clubs execute (trick) if not then wait for other to play and then use trick(?suit ?rank ...), its important to note trick takes all of the cards at once as well as the fact that the cards need to be entered in the order played
4. After it tell you what card to play if any other player still needs ot play you use the following
    (remove_card 1 ?suit ?rank)
    (remove_card 2 ?suit ?rank)
    (remove_card 3 ?suit ?rank)
    (run)
    (new_trick)
    (run) 
    again please note order is important and that you only need to imput the card of the people that played after you and were not included in the original trick call
5. Now you continue to play out the gem in the same pattern till the game is over, to reset for a new round use:
   (reset)

   To run demo.bat with pauses in between each card being played use (batch* demo.bat)