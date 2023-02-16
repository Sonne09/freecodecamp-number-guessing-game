#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo "Enter your username:"
read USERNAME

USERNAME_AVAILABLE=$($PSQL "SELECT username FROM users WHERE username = '$USERNAME'")
GAMES_PLAYED=$($PSQL "SELECT count(*) FROM users INNER JOIN games USING(user_id) WHERE username = '$USERNAME'")
BEST_GAME=$($PSQL "SELECT MIN(number_of_guesses) FROM users INNER JOIN games USING(user_id) WHERE username = '$USERNAME'")

# if new user insert into users table
if [[ -z $USERNAME_AVAILABLE ]]
  then
    INSERT_USER=$($PSQL"INSERT INTO users(username) VALUES('$USERNAME')")
    echo "Welcome, $USERNAME! It looks like this is your first time here."
  
  #if user already existing
  else
    echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

# generating random number
RANDOM_NUMBER=$(( RANDOM % 1000 + 1 ))
GUESS=1
echo "Guess the secret number between 1 and 1000:"
# Loop until the user guesses the correct number
while read NUM 
  do
    # if user input is not an integer
    if [[ ! $NUM =~ ^[0-9]+$ ]]
      then
        echo "That is not an integer, guess again:"
      # if user guess is equal to random number
      else
        if [[ $NUM -eq $RANDOM_NUMBER ]] 
          then
            break;
          else
            # if user guess is greater random number
            if [[ $NUM -gt $RANDOM_NUMBER ]]
              then
               echo "It's lower than that, guess again:"
              # if user input is lower than higher number
              elif [[ $NUM -lt $RANDOM_NUMBER ]]
                then
                  echo "It's higher than that, guess again:"
            fi
        fi
    fi
  GUESS=$(( $GUESS+1 ))
done

if [[ $GUESS == 1 ]]
  then
    echo "You guessed it in $GUESS tries. The secret number was $RANDOM_NUMBER. Nice job!"
  else
    echo "You guessed it in $GUESS tries. The secret number was $RANDOM_NUMBER. Nice job!"
fi

USER_ID=$($PSQL "SELECT user_id FROM users WHERE username = '$USERNAME'")
INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(number_of_guesses, user_id) VALUES($GUESS, $USER_ID)")
  