
(deffacts win_lose_tirck_DT "nodes for win or not DT"
    (node (name current_suit)
        (ntype descion)
        (no_node cant_win) 
        (yes_node points)
        (yes_message "Has current suit of trick")
        (no_message "Does not have current suit of trick")
    )
    (node (name points)
        (ntype descion)
        (yes_node lose)
        (no_node last_to_play)
        (yes_message "Yes points have been played this trick")
        (no_message "No points have been played yet this trick")
    )

    (node (name last_to_play)
        (ntype descion)
        (no_node other_player_hand)
        (yes_node play_greatest)
        (yes_message "yes player is playing last")
        (no_message "no player is not playing last")
    )

    (node (name other_player_hand)
        (ntype descion)
        (yes_node low_card)
        (no_node win)
        (yes_message "yes at least one player that has not played yet is out of the current suit")
        (no_message "no player that has not played yet has shown that they are out of the current suit")
    )
    (node (name low_card)
        (ntype descion)
        (yes_node win)
        (no_node lose)
        (yes_message "yes have low card to play next trick")
        (no_message "no do not have low card to play next trick")
    )
    
    (node (name lose)
        (ntype leaf)
    )
    (node (name win)
        (ntype leaf)
    )
    (node (name cant_win)
        (ntype leaf)
    )
)

(defrule process_yes_branch
    (declare (salience 10))
    ?node <- (current_node ?name)
    (node (name ?name)
    (ntype descion)
    (yes_node ?yes_branch)
    (yes_message ?message)
    )
    ?answer <- (answer yes)
    =>
    (printout t ?message crlf)
    (retract ?node ?answer)
    (assert (current_node ?yes_branch))
)

(defrule process_no_branch
    (declare (salience 10))
    ?node <- (current_node ?name)
    (node (name ?name)
    (ntype descion)
    (no_node ?no_branch)
    (no_message ?message)
    )
    ?answer <- (answer no)
    =>
    (printout t ?message crlf)
    (retract ?node ?answer)
    (assert (current_node ?no_branch))
)

(defrule current_suit_node_yes "checks if player has a card of current suit"
    (declare (salience 20))
    (current_node current_suit)
    (node (name current_suit) (ntype descion))
    (trick greatest ?great)
    (trick suit ?suit)
    (player_hand ?suit ?rank)
   
    =>    
    (assert (answer yes))
     
) 

(defrule points_node_yes "checks whether any point cards have been played in trick"
    (declare (salience 20))
    (current_node points)
    (node (name points) (ntype descion))
    (or
        (trick ? heart ?)
        (trick ? spade 12)
    )
    =>
    (assert (answer yes))    
)

(defrule last_to_play_yes "checks if player is last to play"
    (current_node last_to_play)
    (node (name last_to_play) (ntype descion))
    (trick 1 ? ?)
    (trick 2 ? ?)
    (trick 3 ? ?)
    =>
    (assert (answer yes))
)

(defrule other_player_hand_yes "yes if some player has not played and is known to have none of the current suit"
    (declare (salience 20))
    (current_node other_player_hand)
    (node (name other_player_hand) (ntype descion))
    (trick suit ?suit)
    (other_player ?num ?suit)
    (card ?suit ?)
    (not ( trick ?num ? ?))
    =>
    (assert (answer yes))
)

(defrule low_card_heart_yes " checks special case of hearts to make sure hearts are already broken and low heart ot play next trick"
    (declare (salience 25))
    (current_node low_card)
    (node (name low_card ) (ntype descion))
    (player_hand heart ?rank)
    (game lowest heart ?rank)
    (game hearts_broken)
    
    =>
    (assert (answer yes))
)
(defrule low_card_yes "checks for a low card to play next trick"
    (declare (salience 20))
    (current_node low_card)
    (node (name low_card ) (ntype descion))
    (player_hand ?suit ?rank)
    (game lowest ?suit ?rank)
    (test (not(eq ?suit heart)))
    
    =>
    (assert (answer yes))
)

