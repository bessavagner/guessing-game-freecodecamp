#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

MAIN() {
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
		BEST_GAME=$($PSQL "SELECT min(guesses) FROM games WHERE user_id=$USER_ID")

		echo -e "\nWelcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
	fi
	GAME
}

GAME() {
	SECRET_NUMBER=$(($RANDOM % 1000 + 1))
	GUESS=0
	TRIES=0

	echo -e "\nGuess the secret number between 1 and 1000:"

	while [[ $GUESS != $SECRET_NUMBER ]]
	do
		read GUESS
		# if not integer
		if [[ ! $GUESS =~ ^[0-9]+$ ]]
		then
			echo -e "\nThat is not an integer, guess again:"
		# if correct
		elif [[ $SECRET_NUMBER = $GUESS ]]
		then
			TRIES=$(($TRIES + 1))
			echo -e "\nYou guessed it in $TRIES tries. The secret number was $SECRET_NUMBER. Nice job!"
			#insert into db
			INSERT_GAME_RESULT=$($PSQL "insert into games(user_id, guesses) values($USER_ID, $TRIES)")
		# if greater
		elif [[ $SECRET_NUMBER -gt $GUESS ]]
		then
			TRIES=$(($TRIES + 1))
			echo -e "\nIt's higher than that, guess again:"
		# if lower
		else
			TRIES=$(($TRIES + 1))
      		echo -e "\nIt's lower than that, guess again:"
		fi
	done
}

MAIN
