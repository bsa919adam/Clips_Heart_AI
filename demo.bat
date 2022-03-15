(reset)
(add_to_hand spade 8)
(add_to_hand diamond 8)
(add_to_hand heart 14)
(add_to_hand heart 9)
(add_to_hand spade 11)
(add_to_hand club 10)
(add_to_hand club 12)
(add_to_hand heart 2)
(add_to_hand heart 13)
(add_to_hand heart 10)
(add_to_hand club 5)
(add_to_hand diamond 13)
(add_to_hand spade 13)

(readline)

(trick club 2 club 11 spade 14)  ;win play first next

(readline)

(trick)
(remove_card 1 club 14)
(remove_card 2 club 13)
(remove_card 3 heart 12)
(run)
(new_trick)
(run)

(readline)

(trick club 9 club 7 heart 5) ; play 10 clubs win

(readline)

(trick)
(remove_card 1 heart 6)
(remove_card 2 heart 3)
(remove_card 3 diamond 10)
(run)
(new_trick)
(run)

(readline)

(trick spade 5 spade 4)
(remove_card 1 spade 12)
(run)
(new_trick)
(run)

(readline)

(trick club 8 club 6 diamond 7)

(readline)

(trick diamond 2 diamond 11 diamond 3)

(readline)

(trick)
(remove_card 1 diamond 14)
(remove_card 2 diamond 12)
(remove_card 3 spade 10)
(run)
(new_trick)
(run)

(readline)

(trick heart 4 heart 11 spade 9)

(readline)

(trick diamond 4 spade 7) ;look ahead should play the  6 win probaby then play 4 to get rid play first play1 has 5 and 9
(remove_card 1 diamond 9)
(run)
(new_trick)
(run)

(readline)

(trick diamond 5 diamond 6 spade 6)

(readline)

(trick club 4 spade 3)
(remove_card 1 heart 8)
(run)
(new_trick)
(run)

(readline)

(trick club 3 spade 2)
(remove_card 1 heart 7)
(run)
(new_trick)
(run)
