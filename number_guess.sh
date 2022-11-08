#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

MAIN() {
	echo -e "\n======== Number Guessing Game ========\n"
	echo -e "Enter your username:"
	read USERNAME

	USER_ID=$($PSQL "SELECT user_id FROM users WHERE name='$USERNAME'")

	# if new user
	if [[ -z $USER_ID ]]
	then
		# insert new user
		INSERT_USER_RESULT=$($PSQL "INSERT INTO users(name) values('$USERNAME')")
		# get user id
		USER_ID=$($PSQL "SELECT user_id FROM users WHERE name='$USERNAME'")

		echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."

	# if user already exists
	else
		# games played
		GAMES_PLAYED=$($PSQL "SELECT count(user_id) FROM games WHERE user_id=$USER_ID")
		# best game
		BEST_SCORE=$($PSQL "SELECT min(guesses) FROM games WHERE user_id=$USER_ID")

		echo -e "\nWelcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GUESS guesses."
	fi
}

MAIN
