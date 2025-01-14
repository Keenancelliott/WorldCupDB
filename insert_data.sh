#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "truncate teams, games restart identity")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
if [[ $YEAR != year ]] 
then 
# Get team IDs
WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
if [[ -z $WINNER_ID ]]
then 
# Insert winning team 
INSERT_WINNING=$($PSQL "insert into teams(name) values('$WINNER')")
# Get new winner ID
WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
fi 
if [[ -z $OPPONENT_ID ]]
then
# Insert opponent
INSERT_OPPONENT=$($PSQL "insert into teams(name) values('$OPPONENT')")
# Get new opponent ID
OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
fi
INSERT_GAME=$($PSQL "insert into games(year,round,winner_goals,opponent_goals,winner_id,opponent_id)
values($YEAR,'$ROUND',$WINNER_GOALS,$OPPONENT_GOALS, $WINNER_ID,$OPPONENT_ID)")
fi
done


