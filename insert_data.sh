#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != year ]]
  then
    #get TEAM_NAME
    TEAM_NAME1=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    # if not found
    if [[ -z $TEAM_NAME1 ]]
    then
      # insert TEAM_NAME
      INSERT_TEAM_NAME1=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_TEAM_NAME1 == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $WINNER
      fi
      # get new team_id
      TEAM_NAME1=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi

    #LINE BELOW IS FOR DEBUGGING
    #echo "$TEAM_NAME1 NAME 1"

    #get TEAM_NAME
    TEAM_NAME2=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    # if not found
    if [[ -z $TEAM_NAME2 ]]
    then
      # insert TEAM_NAME
      INSERT_TEAM_NAME2=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_TEAM_NAME2 == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $OPPONENT
      fi
      # get new team_id
      TEAM_NAME2=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi
    
    #LINE BELOW IS FOR DEBUGGING
    #echo "$TEAM_NAME2 NAME 2"

    # insert game data
    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', '$TEAM_NAME1', '$TEAM_NAME2', '$WINNER_GOALS', '$OPPONENT_GOALS')")
  fi
done
