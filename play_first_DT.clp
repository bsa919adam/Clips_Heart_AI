
(deffacts play_first_nodes "nodes used when playing first card in trick"
    (node (name 2_clubs)
        (ntype descion)
        (yes_node play_2_clubs)
        (no_node hand_survey)
        (yes_message "yes you have the two of clubs")
        (no_message "no you don't have the two of clubs")
    )
    (node (name hand_survey)
        (ntype descion)
        (yes_node play_highest_suit)
        (no_node play_lowest_setup)
        (yes_message "choose to play a high card")
        (no_message "choose to play a low card")
    )
    (node (name play_highest_suit)
        (ntype leaf)
    )
    (node (name play_lowest) 
        (ntype leaf)
    )

)

(defrule 2_clubs "checks if player has 2 of clubs in hand then plays it"
    (declare (salience 30))
    ?node <-(current_node 2_clubs)
    (node (name 2_clubs) (ntype descion))
    ?card <- (player_hand club 2)
    =>
    (play_card club 2 ?card)
    (retract ?node)
    (assert (current_node end))
)




(defrule hand_survey_yes "chooses to play card to get rid of high card or just play a low card"
    (current_node hand_survey)
    (node (name hand_survey) (ntype descion))
    (player_hand count ?suit~heart&spade ?hand_count~0)
    (c_count ?suit ?c_count)
    (test (<= ?hand_count (div ?c_count 3) ))
    (not (other_player ? ?suit))
    =>
    (assert (answer yes)) 
    (assert (play ?suit))
)

(defrule play_highest_suit "play highest card of a given suit"
    ?node <-(current_node play_highest_suit)
    (node (name play_highest_suit) (ntype leaf))
    ?play <- (play ?suit)
    (player_hand greatest ?suit ?rank)
    ?card <-(player_hand ?suit ?rank)
    =>
    (play_card ?suit ?rank ?card)
    (retract ?node)
    (assert (current_node end))
)

(defrule intial_score "sets up score varialble for all cards in hand"
    (declare (salience 75))
    ?node <-(current_node play_lowest_setup)
    (node (name play_lowest) (ntype leaf))
    (player_hand ?suit ?rank)
    (or
        (test (neq ?suit heart))
        (game hearts_broken)
    )
    (not (player_hand score ?suit ?rank ?score))
    =>
    (assert (player_hand score ?suit ?rank 0))
)
(defrule play_lowest_setup_end "prevents score from repeating when scores removed later"
    (declare (salience 70))
    ?node <-(current_node play_lowest_setup)
    (node (name play_lowest) (ntype leaf))
    =>
    (retract ?node)
    (assert (current_node play_lowest))
)

(defrule play_lowest1 "play lowest card of suit that is meeting requirments"
    (declare (salience 30))
    
    ?score_ref <- (player_hand score ?suit ?rank 0)
    ?card <- (player_hand ?suit ?rank)
    ?node <-(current_node play_lowest)
    (node (name play_lowest) (ntype leaf))
    =>
    (assert (player_hand score ?suit ?rank 1))
    (retract ?score_ref)
)
  
(defrule play_lowest2 "adds one to score if have less of that suit than are in play"
    (declare (salience 30))
    ?score_ref <- (player_hand score ?suit ?rank ?score)
    (not (low 2 ?suit ?rank))
    (test (> ?score 0))
    (game count ?suit ?count2)
    (player_hand count ?suit ?count)  
    (test (> ?count2 ?count))
    =>
    (assert (player_hand score ?suit ?rank (+ ?score 1)))
    (retract ?score_ref)
    (assert (low 2 ?suit ?rank))
)
  
(defrule play_lowest3 "adds two to score if lowest of suit in game "
    (declare (salience 30))
    ?score_ref <- (player_hand score ?suit ?rank ?score)
    (test (> ?score 0))
    (game lowest ?suit ?rank)
    (not (low 3 ?suit ?rank))
   
    =>
    (assert (player_hand score ?suit ?rank (+ ?score 2)))
    (retract ?score_ref)
    (assert (low 3 ?suit ?rank))
)
(defrule play_lowest_heart_penalty "adds a point to all none hearts cards score"
    (declare (salience 30))
    ?score_ref <- (player_hand score ?suit ?rank ?score)
    (test (neq ?suit heart))
    (test (> ?score 0))
    
    (not (low 4 ?suit ?rank))
    
    =>
    (assert (player_hand score ?suit ?rank (+ ?score 1)))
    (retract ?score_ref)
    (assert (low 4 ?suit ?rank))
)

(defrule play_lowest_lowest_suit "adds a point if the card is the lowest of a suit in hand"
    (declare (salience 30))
    ?score_ref <- (player_hand score ?suit ?rank ?score)
    (test (> ?score 0))
    (player_hand least ?suit ?rank)
    (not (low 5 ?suit ?rank))
    
    =>
    (assert (player_hand score ?suit ?rank (+ ?score 1)))
    (retract ?score_ref)
    (assert (low 5 ?suit ?rank))
)

 
(defrule play_lowest_queen_spades_play "checks if queen of spades can be played safley"
    (declare (salience 40))
    ?score_ref <- (player_hand score spade 12 ?score)
    (card spade 13|14)   
    (game count spade ?count)
    (not (low queen))
    (test (< ?count 3))
    (other_player ?num1 spade)
    (other_player ?num2 spade)
    (test (< ?num1 ?num2))   
    =>
    (assert (player_hand score spade 12 (+ ?score 9)))
    (assert (low queen))   
)

(defrule play_lowest_queen_spades_penalty "penalizes queen of spades"
    (declare (salience 30))
    ?score_ref <- (player_hand score ?suit ?rank ?score)
    (test (> ?score 0))
    (or
        (test (neq ?suit spade)) 
        (test(neq ?rank 12))
    )
    (not (low 6 ?suit ?rank))
    
    =>
    (assert (player_hand score ?suit ?rank (+ ?score 3)))
    (retract ?score_ref)
    (assert (low 6 ?suit ?rank))
)
(defrule select_highest_score "selects the highest scoring card to play"
    (declare (salience 20))
    ?score_ref1<- (player_hand score ?suit1 ?rank1 ?score1)
    ?score_ref2<- (player_hand score ?suit2 ?rank2 ?score2)
    (or
        (test (neq ?suit1 ?suit2))
        (test (neq ?rank1 ?rank2))
    )
    =>
    (if (> ?score1 ?score2)
        then
        (retract ?score_ref2)
    else
        (retract ?score_ref1)
    
    )
)

(defrule play_lowest_default "plays any card incase play_lowest fails to fire"
    (declare (salience -1))
    ?score<-(player_hand score ?suit ?rank ?)
   
   
    ?card <- (player_hand ?suit ?rank)
    ?node <-(current_node play_lowest)
    (node (name play_lowest) (ntype leaf))
    
    =>
    (play_card ?suit ?rank ?card)
    (retract ?node ?score)
    (assert (current_node end))
)
 (defrule clean_up_low "removes low values"
    (declare (salience -5))
    ?low<-(low $?)
    =>
    (retract ?low)

 )
