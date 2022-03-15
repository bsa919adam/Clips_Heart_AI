(deffunction test1() "cur: yes points:yes lose queen spade:no highheart:no play greatest A club"
    (add_to_hand club 14)
    (add_to_hand spade 11)
    (add_to_hand spade 4)
    (add_to_hand heart 5)
    (add_to_hand heart 9)
    (add_to_hand diamond 10)
    (add_to_hand spade 13)
    (trick club 10 club 5 heart 4)
     (run)
    (readline)
    (reset)

)

(deffunction test2() "cur:yes point:no otherplayerhand: no win suitspades: no play greatest of suit 11 club"
    (add_to_hand club 11)
    (add_to_hand spade 11)
    (add_to_hand spade 4)
    (add_to_hand heart 5)
    (add_to_hand heart 9)
    (add_to_hand diamond 10)
    (add_to_hand spade 13)
    (trick club 9 spade 3 club 12)
    (run)
    (readline)
    (reset)
)
(deffunction test3() "low card no test if test2 was run before lose"
    (add_to_hand club 11)
    (add_to_hand club 5)
    (add_to_hand spade 11)
    (add_to_hand spade 4)
    (add_to_hand heart 5)
    (add_to_hand heart 9)
    (add_to_hand diamond 10)
    (add_to_hand spade 13)
    (trick club 9 spade 3 club 12) ;play jack of clubs
    (run)
    (new_trick)
    (run)
    (trick club 8 ) ;play 5 of clubs
    (run)
    (readline)
    (reset)
)


(deffunction test4 ()  "low card test yes, win, suitspades:no play greatesst "
    (add_to_hand club 5)
    (add_to_hand club 9)  
    (add_to_hand spade 11)
    (add_to_hand spade 4)
    (add_to_hand heart 5)
    (add_to_hand heart 9)
    (add_to_hand diamond 10)
    (add_to_hand spade 13)
    (trick club 7) ;play club 9
    (run)
    (readline)
    (reset)
)

(deffunction test5 ()  "other player hand card test no , win suitspades:no play greatest"
    (add_to_hand spade 12)
    (add_to_hand diamond 12)
    (trick diamond 2) ;play Queen of diamonds
    (run)
    (readline)
    (reset)
)


(deffunction test6 () "other player hand card test no, win suit spades:yes, queen_spades:yes, less than queen:yes"
    (reset)
    (add_to_hand spade 11)
    (add_to_hand spade 4)
    (add_to_hand heart 5)
    (add_to_hand heart 9)
    (add_to_hand diamond 10)
    (add_to_hand spade 13)
    (trick spade 5 spade 9) ;play Jack of spades
    (run)
    (readline)
    (reset)
)

(deffunction test7 () "other player hand card test no, win suit spades:yes, queen_spades:yes, less than queen:no, play greatest"
    (reset)
   
    (add_to_hand heart 5)
    (add_to_hand heart 9)
    (add_to_hand diamond 10)
    (add_to_hand spade 13)
    (trick spade 5 spade 12) ;play King of spades
    (run)
    (readline)
    (reset)
)

(deffunction test8 () "other player hand card test no, win suit spades:yes, queen_spades:no, less than queen:no, play greatest"
    (reset)
    (add_to_hand spade 11)
    (add_to_hand spade 4)
    (add_to_hand heart 5)
    (add_to_hand heart 9)
    (add_to_hand diamond 10)
    (add_to_hand spade 13)
    (add_to_hand spade 12)
    (trick spade 5 spade 8) ;king of spades
    (run)
    (readline)
    (reset)
)

(deffunction test9 () "test play queen spades"
    (reset)
    (add_to_hand spade 11)
    (add_to_hand spade 4)
    (add_to_hand heart 5)
    (add_to_hand heart 9)
    (add_to_hand diamond 10)
    (add_to_hand spade 13)
    (add_to_hand spade 12)
    (trick spade 14 spade 8) ;play queen of spades
    (run)
    (readline)
    (reset)
)

(deffunction test10 () "test the play first, plays 10 of diamonds"
    (reset)
    (add_to_hand spade 11)
    (add_to_hand spade 4)
    (add_to_hand heart 5)
    (add_to_hand heart 9)
    (add_to_hand diamond 10)
    (add_to_hand spade 13)
    (add_to_hand spade 12)
    (trick)
    (run)
    (readline)
    (reset)

)

(deffunction test11 () "test one card in hand play first"
    (reset)
    (add_to_hand diamond 11)
    (trick)
    (run)
    (readline)
    (reset)
)

(deffunction test12 () "test plays two of clubs "

    (reset)
    (add_to_hand spade 11)
    (add_to_hand spade 4)
    (add_to_hand heart 5)
    (add_to_hand heart 9)
    (add_to_hand diamond 10)
    (add_to_hand spade 13)
    (add_to_hand spade 12)
    (add_to_hand club 2)
    (trick)
    (run)
    (readline)
    (reset)
)