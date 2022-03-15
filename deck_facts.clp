
;Jack =11
;Queen =12
;King = 13
;Ace =14
(deftemplate node 
    (slot name)
    (slot ntype)
    (slot yes_node)
    (slot no_node)
	(slot yes_message (type STRING) (default "yes"))
	(slot no_message (type STRING)  (default "no"))
    
)

(deffacts card_pool "cards in deck"
	(card club 2)
	(card club 3)
	(card club 4)
	(card club 5)
	(card club 6)
	(card club 7)
	(card club 8)
	(card club 9)
	(card club 10)
	(card club 11)
	(card club 12)
	(card club 13)
	(card club 14)
	(card spade 2)
	(card spade 3)
	(card spade 4)
	(card spade 5)
	(card spade 6)
	(card spade 7)
	(card spade 8)
	(card spade 9)
	(card spade 10)
	(card spade 11)
	(card spade 12)
	(card spade 13)
	(card spade 14)
	(card heart 2)
	(card heart 3)
	(card heart 4)
	(card heart 5)
	(card heart 6)
	(card heart 7)
	(card heart 8)
	(card heart 9)
	(card heart 10)
	(card heart 11)
	(card heart 12)
	(card heart 13)
	(card heart 14)
	(card diamond 2)
	(card diamond 3)
	(card diamond 4)
	(card diamond 5)
	(card diamond 6)
	(card diamond 7)
	(card diamond 8)
	(card diamond 9)
	(card diamond 10)
	(card diamond 11) 
	(card diamond 12)
	(card diamond 13)
	(card diamond 14)

	(game count spade 13 )
	(game count heart 13 )
	(game count diamond 13 )
	(game count club 13 )


	(game lowest club 2)
	(game lowest heart 2)
	(game lowest spade 2)
	(game lowest diamond 2)

	(game highest club 14)
	(game highest heart 14)
	(game highest spade 14)
	(game highest diamond 14)


	(player_hand least club 15) ; insatntiate to 15 so any valid value is smaller
	(player_hand least heart 15)
	(player_hand least spade 15)
	(player_hand least diamond 15)


	(player_hand greatest club 1) ; insatntiate to 1 so any valid value is smaller
	(player_hand greatest heart 1)
	(player_hand greatest spade 1)
	(player_hand greatest diamond 1)

	(player_hand count club 0) ;count in players hand instatiedted to 0
	(player_hand count heart 0)
	(player_hand count diamond 0)
	(player_hand count spade 0)

	

)
(deffunction remove_card (?num ?suit ?rank) "used for cards played in trick after you play"
	(assert (trick ?num ?suit ?rank))
)
(defrule check_out_of_suit "sets fact declaring the other person is out of a suit"
	(declare (salience 100))
	(trick ?num ?suit ?rank)
	(not (other_player ?num ?suit))
	(trick suit ?suit1)
	(test (neq ?suit ?suit1))
	=>
	(assert(other_player ?num ?suit))
)
(deffunction add_to_hand (?suit ?rank )  "adds card of suit and rank to hand"
	
	(assert (player_hand ?suit ?rank))
	(assert (increment ?suit))
	(run)
	
)
;after calling play_card most cases fact for card should be retracted
(deffunction play_card (?suit ?rank ?card) "prinout card to play with relpacing rank for face cards"
	(retract ?card)
    (if (eq 11 ?rank)
    then 
        (bind ?rank "Jack")
    else

        (if (eq 12 ?rank)
        then
            (bind ?rank "Queen")
        else
            (if (eq 13 ?rank)
            then
                (bind ?rank "King")
            else
                (if (eq 14 ?rank)
                then
                    (bind ?rank "Ace")
                )
            )    
        )
    )
	(assert (decrement ?suit))
    (printout t "play card " ?rank " of " ?suit "s" crlf)
)
(defrule dec_hand_count "decrements player hand count"
	(declare (salience 99))
	?dec <- (decrement ?suit)
	?hand_c <- (player_hand count ?suit ?count)
	=>
	(retract ?dec ?hand_c)
	(assert (player_hand count ?suit (- ?count 1)))

)
(defrule inc_hand_count "decrements player hand count"
	(declare (salience 99))
	?inc <- (increment ?suit)
	?hand_c <- (player_hand count ?suit ?count)
	=>
	(retract ?inc ?hand_c)
	(assert (player_hand count ?suit (+ ?count 1)))

)

(defrule hearts_broken_rule "lets player know hearts had been broken so hearts can be played first"
	(declare (salience 99))
	(trick ? heart ?)
	(not ( game hearts_broken))
	=>
	(assert (game hearts_broken))
)
(defrule player_hand_least_reset "resets and retriggers least when greatest card is removed"
	(declare (salience 99))
	?least<-(player_hand least ?suit ?rank)
	(not (player_hand ?suit ?rank))
	(test (<> ?rank 15))
	=>
	(retract ?least)
	(assert (player_hand least ?suit 15))
)
(defrule player_hand_least_rule "sets the least card of every suit in players hand as a fact"
	(declare (salience 99))
	(player_hand ?suit ?rank)
	?least <-(player_hand least ?suit ?rank2)
	(test (< ?rank ?rank2))
	=>
	(assert (player_hand least ?suit ?rank))
	(retract ?least)
)
(defrule player_hand_greatest_reset "resets and retriggers greatest when greatest card is removed"
	(declare (salience 99))
	?great<-(player_hand greatest ?suit ?rank)
	(not (player_hand ?suit ?rank))
	(test (<> ?rank 1))
	=>
	(retract ?great)
	(assert (player_hand greatest ?suit 1))
)

(defrule player_hand_greatest_rule "sets the greatest card of every suit in players hand as a fact"
	(declare (salience 99))
	(player_hand ?suit ?rank)
	?greatest <-(player_hand greatest ?suit ?rank2)
	(test (> ?rank ?rank2))
	=>
	(assert (player_hand greatest ?suit ?rank))
	(retract ?greatest)
)

(defrule low_card_update "updates the lowest card in game when lowest card no longer in deck or hand"
    (declare (salience 99))
    ?low <- (game lowest ?suit ?rank)
    (not (card ?suit ?rank ))
    (not (player_hand ?suit ?rank))
    (or 
        (card ?suit ?rank2) 
        (player_hand ?suit ?rank2)
    )
    =>
    (assert (game lowest ?suit ?rank2))
    (retract ?low)

)
(defrule low_card_update2 "sets the lowest card to the lowest"
    (declare (salience 99))
    ?low <- (game lowest ?suit ?rank)
    (or    
        (card ?suit ?rank2)  
        (player_hand ?suit ?rank2)
    )
    (test(< ?rank2 ?rank) )
    =>
    (retract ?low)
    (assert (game lowest ?suit ?rank2))
)

(defrule remove-deck "removes card from pool when in hand or played during trick"
	(declare (salience 99))
	(or
		(player_hand ?suit ?rank)
		(trick ? ?suit ?rank)
		(discard ?suit ?rank)
	)
	?c_count<-(game count ?suit ?num)
	?rem <- (card ?suit ?rank)
	=>
	(assert (game count ?suit (- ?num 1)))
	(retract ?rem ?c_count)

)

(defrule clean_discard "removes discarded card facts after they are used"
	(declare (salience 90))
	?card <- (discard ? ?)
	=>
	(retract ?card)
)
;player is player 
;player3 is the player to the left of player
;player2 is to the left of player 3
;player1 is to the left of player 2
;odering for convince of ($lenght ?played)/(1 + (place card played)= player number
(deffunction trick ($?played)
	(if (= (length$ ?played) 0)
		then
		(assert (current_node 2_clubs))
		(printout t "First Node" crlf)

	else
		(bind ?suit_p  (nth$ 1 $?played))
		(bind ?rank (nth$ 2 $?played))
		(assert (trick suit ?suit_p)) ;set suit of trick
		(assert  (trick ( div (length$ ?played) 2) ?suit_p ?rank)) ;first card played
		(bind ?greatest ?rank)
		(if (> (length$ ?played) 2)
			then
			(bind ?suit  (nth$ 3 $?played))
			(bind ?rank (nth$ 4 $?played))
			(bind ?player ( div (length$ ?played) 3)) ;playaer number
			(assert (trick ?player ?suit ?rank)) ;second card played
			(if (> ?rank ?greatest)
				then
				(bind ?greatest ?rank)
			)
			(if (not(eq  ?suit ?suit_p)) 
				then
				(assert (other_player ?player ?suit_p)) ;
			)
			(if (= (length$ ?played) 6)
				then
				(bind ?suit (nth$ 5 $?played))
				(bind ?rank (nth$ 6 $?played))
				(assert (trick 1 ?suit ?rank)) ;always player 1
				(if (> ?rank ?greatest)
					then
					(bind ?greatest ?rank)
				
				)
				(if (not(eq  ?suit ?suit_p)) 
				then
				(assert (other_player 1 ?suit_p)) ;
			)
			
			)
		)
		;assert first node of descion tree for cards already played
		(assert (current_node current_suit))
		(assert (trick greatest ?greatest))
	)
	(run) ;commented out for testing purposes
)
(defrule trick_reset "resets trick cards played at end of round"
	(declare (salience 100))
	?card_played <- (trick  ? ?suit ?rank) 
	(round_over true)
	=>
	(assert (discard ?suit ?rank))
	(retract ?card_played)
)
(defrule trick_properties_reset "resets trick properties at end of round"
	(declare (salience 100))
	?card_played <- (trick   ? ?) 
	(round_over true)
	=>
	(retract ?card_played)
)
(defrule node_reset "retracts any current nodes"
	(declare (salience 100))
	?current_node <- (current_node ?)
	(round_over true)
	=>
	(retract ?current_node)
)



(defrule round_reset "resets values for current round for the next"
	(declare (salience 100))
	?round <- (round_over true)
	
	=>
	(retract  ?round)

)
(deffunction  new_trick () "used when the round is over to trigger reset rules"
	(assert (round_over true))
	
 )

 (defrule play_queen_spades_immediate "plays the queen of spades imediatley from hand if can be played safely"
	(declare (salience 105) )
	(trick ?num spade 13 | 14)	
	?card<-(player_hand spade 12)
	?node <- (current_node ?)
	=>
	(play_card spade 12 ?card)
	(retract  ?node)
	(assert (current_node end))
	
 )

 (defrule default_no "answers no when no answer is coming"
	(declare (salience -100))
	(current_node ?node&~end)
	(node (name ?node) (ntype descion))	
	(not (answer ?))
	=>
	(assert (answer no))

 )

(defrule new_trick_auto "calls new trick when previous is over"
	(current_node end)
	=>
	(new_trick)

)