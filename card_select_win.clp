
;win/lose nodes not yet implemnted
(deffacts win_nodes
     
    (node (name suit_spades)
        (ntype descion)
        (no_node play_greatest)
        (yes_node queen_spades)
        (yes_message "yes the suit is spades")
        (no_message "no the suit is not spades")
    )
   
    (node (name queen_spades)
        (ntype descion)
        (no_node play_greatest)
        (yes_node less_than_queen)
        (yes_message "yes the queen of spades is in play")
        (no_message "no the queen of spades is not in play")
    )

    (node (name less_than_queen)
        (ntype descion)
        (no_node play_greatest)
        (yes_node play_less_than_queen)
        (yes_message "yes you have a spade less than the queen")
        (no_message "no you don't have a spade less than the queen")
    )

    (node (name play_less_than_queen)
        (ntype leaf)
        
    )
    (node (name play_greatest)
        (ntype leaf)
        
    )
)

(defrule win 
    ?node <-(current_node win)
    =>
    (printout t "Decided to attempt to win trick" crlf)
    (assert (current_node suit_spades))
    (retract ?node)
)



(defrule set_less_than_queen_initial "sets up less_than fact if does not exist"
    (declare (salience 30))
    (current_node play_less_than_queen)
    (node (name play_less_than_queen) (ntype leaf))
    (not( less_than ? ))
    ?card <- (player_hand spade ?rank)
    (test (< ?rank 12))
    =>
    (assert (less_than ?rank))
)

(defrule set_less_than_queen "sets less than fact to value less than queen but greatest in hand"
    (declare (salience 30))
    (current_node play_less_than_queen)
    (node (name play_less_than_queen) (ntype leaf))
    ?less <-(less_than ?rank )
    ?card <- (player_hand spade ?rank)
    ?temp <- (player_hand spade ?rank2)
    (test (< ?rank2 12))
    (test (> ?rank2 ?rank ))
    =>
    (retract ?less)
    (assert (less_than ?rank2))
)

(defrule play_less_than_queen "plays card selected previously"
    (declare (salience 10))
    ?node <- (current_node play_less_than_queen)
    (node (name play_less_than_queen) (ntype leaf))
    ?less<-(less_than ?rank )
    ?card <- (player_hand spade ?rank)
    =>
    (play_card spade ?rank ?card)
    (retract ?node  ?less)
    (assert (current_node end))
)


(defrule play_greatest "plays greatest card of suit of trick in hand"
    ?node <-(current_node play_greatest)
    (node (name play_greatest) (ntype leaf))
    (trick suit ?suit)
    ?great <- (player_hand greatest ?suit ?rank)
    ?card <- (player_hand ?suit ?rank)
    =>
    (play_card ?suit ?rank ?card)
    (retract  ?node)
    (assert (current_node end))
)


(defrule suit_spades_yes "check if the suit of the trick is spades"
    (declare (salience 20))
    (current_node suit_spades)
    (node (name suit_spades) (ntype descion))
    (trick suit spade)
    =>
    (assert (answer yes))
)



(defrule queen_spades_yes " checks if queen of spades is still in play"
    (current_node queen_spades)
    (node (name queen_spades) (ntype descion))
    (card spade 12)
    =>
    (assert (answer yes))
)



(defrule less_than_queen_yes "checks if player has a card less than queen of spades"
    (declare (salience 15))
    (current_node less_than_queen)
    (node (name less_than_queen) (ntype descion))
    (player_hand spade ?rank )
    (test (< ?rank 12 ))
    =>
    (assert (answer yes))
)

