#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
test() {
if [[ ! $1 ]]
then 
  echo Please provide an element as an argument.
else 
  if [[ $1 =~ ^[0-9]+$ ]] 
  then
    insert_by_num $1
  else
    if [[ ${#1} = 1 || ${#1} = 2 ]]
    then
      insert_by_symbol $1
    else 
      insert_by_name $1
    fi
  fi
fi
}
insert_by_num() {
  # TEST=$($PSQL "SELECT ")
  NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$1")
  if [[ ! -z $NAME ]]
  then
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$1")
  TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$1")
  TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID")
  ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$1")
  MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$1")
  BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$1")
  echo "The element with atomic number $1 is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  else
    echo "I could not find that element in the database."
  fi
}
insert_by_symbol() {
  NAME=$($PSQL "SELECT name FROM elements WHERE symbol='$1'")
  if [[ ! -z $NAME ]]
  then
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1'")
  TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID")
  ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($1). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  else
    echo "I could not find that element in the database."
  fi
}
insert_by_name() {
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name='$1'")
  if [[ ! -z $SYMBOL ]]
  then
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$SYMBOL'")
  TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID")
  ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  echo "The element with atomic number $ATOMIC_NUMBER is $1 ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $1 has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  else
    echo "I could not find that element in the database."
  fi
}
test $1
