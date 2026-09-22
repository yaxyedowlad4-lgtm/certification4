#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

ELEMENT_INFO=$($PSQL "
SELECT elements.atomic_number, elements.name, elements.symbol,
       properties.atomic_mass,
       properties.melting_point_celsius,
       properties.boiling_point_celsius,
       types.type
FROM elements
JOIN properties USING(atomic_number)
JOIN types USING(type_id)
WHERE elements.atomic_number::text = '$1'
   OR elements.symbol = '$1'
   OR elements.name = '$1'
")

if [[ -z $ELEMENT_INFO ]]
then
  echo "I could not find that element in the database."
  exit
fi

IFS='|' read ATOMIC_NUMBER NAME SYMBOL MASS MELTING_POINT BOILING_POINT TYPE <<< "$ELEMENT_INFO"

echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
