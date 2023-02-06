#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# If argument exists
if [[ $1 ]]
then
  # If argument is a number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
  # Check if element exists in database
    SR_ELM_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$1")
    # If element does not exists
    if [[ -z $SR_ELM_NAME ]]
    then
      echo I could not find that element in the database.
    # If element exists
    else
      # get the info
      SR_ELM_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$1")
      SR_EL_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$1")
      SR_ELM_TYPE=$($PSQL "SELECT	t.type FROM types t INNER JOIN properties p USING (type_id) WHERE p.atomic_number=$1")
      SR_ELM_ATOMIC_MASS=$($PSQL "SELECT	atomic_mass FROM properties WHERE atomic_number=$1")
      SR_ELM_MELTING_POINT=$($PSQL "SELECT	melting_point_celsius FROM properties WHERE atomic_number=$1")
      SR_ELM_BOILING_POINT=$($PSQL "SELECT	boiling_point_celsius FROM properties WHERE atomic_number=$1")
      
       # print the result
      echo "The element with atomic number $1 is $SR_ELM_NAME ($SR_EL_SYMBOL). It's a $SR_ELM_TYPE, with a mass of $SR_ELM_ATOMIC_MASS amu. $SR_ELM_NAME has a melting point of $SR_ELM_MELTING_POINT celsius and a boiling point of $SR_ELM_BOILING_POINT celsius."
    fi

  # If argument is a character/string
  elif [[ $1 =~ ^[a-zA-Z]*$ ]]
  then
    # Check if element exists in database
    SR_ELM_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1' OR name='$1'")
    # If element does not exists
    if [[ -z $SR_ELM_ATOMIC_NUMBER ]]
    then
      echo I could not find that element in the database.
    # If element exists
    else
      # get the info
      SR_ELM_NAME=$($PSQL "SELECT name FROM elements WHERE symbol='$1' OR name='$1'")
      SR_EL_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol='$1' OR name='$1'")
      SR_ELM_TYPE=$($PSQL "SELECT	t.type FROM types t INNER JOIN properties p USING (type_id) INNER JOIN elements e USING (atomic_number) WHERE e.name='$1' OR e.symbol='$1'")
      SR_ELM_ATOMIC_MASS=$($PSQL "SELECT	atomic_mass FROM properties INNER JOIN elements e USING (atomic_number) WHERE e.name='$1' OR e.symbol='$1'")
      SR_ELM_MELTING_POINT=$($PSQL "SELECT	melting_point_celsius FROM properties INNER JOIN elements e USING (atomic_number) WHERE e.name='$1' OR e.symbol='$1'")
      SR_ELM_BOILING_POINT=$($PSQL "SELECT	boiling_point_celsius FROM properties INNER JOIN elements e USING (atomic_number) WHERE e.name='$1' OR e.symbol='$1'")

      # print the result
      echo "The element with atomic number $SR_ELM_ATOMIC_NUMBER is $SR_ELM_NAME ($SR_EL_SYMBOL). It's a $SR_ELM_TYPE, with a mass of $SR_ELM_ATOMIC_MASS amu. $SR_ELM_NAME has a melting point of $SR_ELM_MELTING_POINT celsius and a boiling point of $SR_ELM_BOILING_POINT celsius."
    fi
  else
    # If the argument is not valid
    echo -e "\nPlease enter a valid option\n"
  fi
else
  # If there is no argument
  echo Please provide an element as an argument.
fi