(deffacts lose_nodes 
    (node (name play_queen_spades) ;checks for queen of spades
        (ntype descion)
        (yes_node end)
        (no_node play_high_heart)
        (no_message "don't have queen of spades")
    )
    (node (name play_high_heart)
        (ntype descion)
        (yes_node play_high_heart_act)
        (no_node play_greatest_least_suit)
        (no_message "don't have high heart to play")
        (yes_message "play high heart card")
    )
    (node (name play_greatest_least_suit) ;plays the highest card of the suit player has the least of in hand
        (ntype leaf)
    )

    (node (name less_than_trick_greatest)
        (ntype descion)
        (yes_node play_greatest_least_than_trick)
        (no_node play_greatest) ;already exist in lose DT
        (yes_message "yes you have a card less than the tricks greatest card")
        (no_message "no you don' have a card less than the tricks greatest card")
    )
    (node (name play_greatest_least_than_trick)  ;plays the highest card that is less than the greatest card played in trick
        (ntype leaf)
    )
    
    (node (name play_high_heart_act)
        (ntype leaf)
    )
)
(defrule lose
    ?node <-(current_node lose)
    =>
    (printout t "Decided to attempt to lose trick" crlf)
    (assert (current_node less_than_trick_greatest))
    (retract ?node)
)

(defrule play_high_heart_act "plays highest heart in hand"
    ?node <- (current_node play_high_heart_act)
    (player_hand greatest heart ?rank)
    ?card <- (player_hand heart ?rank)
    =>
    (play_card heart ?rank ?card)
    (retract ?node)
    (assert (current_node end))

)

(defrule cant_win 
    ?node <- (current_node cant_win)
    =>
    (printout t "Can't win the trick" crlf)
    (assert (current_node play_queen_spades))
    (retract ?node)
)
(defrule play_queen_spades "plays queen of spades if in hand"
    ?node <- (current_node play_queen_spades)
    (node (name play_queen_spades) (ntype descion))
    ?card <- (player_hand spade 12)
    =>
    (play_card spade 12 ?card )
    (retract ?node)
    (assert (current_node end))
)

(defrule play_high_heart "plays highest heart if greater than greatest or 8"
    ?node  <- (current_node play_high_heart)
    (node (name play_high_heart) (ntype descion))
    ?card <- (player_hand heart ?rank)
    (player_hand greatest heart ?rank)
    (game highest heart ?rank2)
    (or 
        (test (>= ?rank ?rank2))
        (test (= ?rank 9))
        (test (= ?rank 10))
        (test (= ?rank 11))
        (test (= ?rank 12))
        (test (= ?rank 13))
        (test (= ?rank 14))
    )
    =>
    (assert (answer yes))
    
)
(defrule play_greatest_least_suit_initial
    (declare (salience 30))
    ?node<- (current_node play_greatest_least_suit)
    (node (name play_greatest_least_suit) (ntype leaf)) 
    (not (least_count ?))
    (player_hand ?suit ?rank)
    =>
    (assert (least_count ?suit))
 )
(defrule play_greatest_least_suit_setup "set least to whichever suit player has least of in hand"
    (declare (salience 30))
    ?node<- (current_node play_greatest_least_suit)
    (node (name play_greatest_least_suit) (ntype leaf)) 
    ?least <-(least_count ?suit)
    (player_hand count ?suit ?count)
    (player_hand count ?suit2 ?count2)
    (test (<> ?count2 0))
    (test(< ?count2 ?count))
    =>
    (retract ?least)
    (assert (least_count ?suit2))
)

(defrule play_greatest_least_suit "plays the highest card of the suit the player has the least of in hand"
    (declare (salience 20))
    ?node<- (current_node play_greatest_least_suit)
    (node (name play_greatest_least_suit) (ntype leaf)) 
    ?least <-(least_count ?suit)
    (player_hand greatest ?suit ?rank)
    ?card <- (player_hand ?suit ?rank)
    =>
    (play_card ?suit ?rank ?card)
    (retract ?node ?least)
    (assert (current_node end))
)

(defrule less_than_trick_greatest "checks if player has a card less than the greatest card already played in the trick"
    ?node <- (current_node less_than_trick_greatest)
    (node (name less_than_trick_greatest ) (ntype descion))
    (trick greatest ?rank)
    (trick suit ?suit)
    (player_hand ?suit ?rank2)
    (test (< ?rank2 ?rank))
    =>
    (assert(answer yes))    
)

(defrule play_greatest_least_than_trick_setup "setsup the comparsion to find the highest card that is less than the greatest card played in trick"
    (declare (salience 30))
    ?node <- (current_node play_greatest_least_than_trick)
    (node (name play_greatest_least_than_trick) (ntype leaf))
    (trick suit ?suit)
    (player_hand ?suit ?rank)
    (trick greatest ?rank_trick)
    (test (< ?rank ?rank_trick))
    =>
    (assert (playable ?rank))

)

(defrule play_greatest_least_than_trick_choose "selects the card that is greatest and less than the greatest card of the suit"
    (declare (salience 25))
    ?node <- (current_node play_greatest_least_than_trick)
    (node (name play_greatest_least_than_trick) (ntype leaf))
    (trick suit ?suit)
    ?less <- (playable ?rank1)
    (playable ?rank2)    
    (test (> ?rank2 ?rank1))
    =>
    (retract ?less)
)

(defrule play_greatest_least_than_trick "plays the selected card"
    (declare (salience 20))
    ?node <- (current_node play_greatest_least_than_trick)
    (node (name play_greatest_least_than_trick) (ntype leaf))
    (trick suit ?suit)
    ?play <- (playable ?rank)
    ?card <- (player_hand ?suit ?rank)
    =>
    (play_card ?suit ?rank ?card)
    (retract ?node)
    (assert (current_node end))
)

