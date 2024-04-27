#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games;")
# Creating the loop

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $YEAR != 'year' ]]
then

# Insert data to the teams table

TEAM_ID_W=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
TEAM_ID_O=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

if [[ -z $TEAM_ID_W ]]
  then 
 INSERT_WINNER_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
  #echo Inserted into teams: $WINNER  
 elif [[ -z $TEAM_ID_O ]]
   then
 INSERT_OPPONENT_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
 # echo Inserted into teams: $OPPONENT     
fi   

fi
done

# When you are done with adding the data to the teams table then you go to the games table
# so we need 2 while loops
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $YEAR != 'year' ]]
then

TEAM_ID_W=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
TEAM_ID_O=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")


INSERT_TO_GAMES_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals)
 VALUES($YEAR, '$ROUND', $TEAM_ID_W, $TEAM_ID_O, $WINNER_GOALS, $OPPONENT_GOALS)")

# if [[ $INSERT_TO_GAMES_RESULT = 'INSERT 0 1' ]]
#  then
#  echo Inserted $($PSQL "SELECT COUNT(game_id) FROM games") games(s)
# fi

fi
done