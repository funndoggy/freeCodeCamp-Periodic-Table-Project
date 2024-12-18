#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ $1 ]]
then
  # find element based on atomic number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    # query table information
    ELEMENT_INFO=$($PSQL "SELECT name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius
                                FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id)
                                WHERE elements.atomic_number = $1")
    if [[ -z $ELEMENT_INFO ]]
    then
      echo I could not find that element in the database.
    else
      echo "$ELEMENT_INFO" | while read NAME BAR SYMBOL BAR TYPE BAR MASS BAR MELTING_POINT BAR BOILING_POINT
      do
          echo "The element with atomic number $1 is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      done
    fi
  else
    # determine if the entry is a symbol
    ELEMENT_INFO=$($PSQL "SELECT atomic_number, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius
                                FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id)
                                WHERE elements.symbol = '$1'")
    if [[ $ELEMENT_INFO ]]
    then
      # read values for output
      echo "$ELEMENT_INFO" | while read NUMBER BAR NAME BAR TYPE BAR MASS BAR MELTING_POINT BAR BOILING_POINT
      do
        echo "The element with atomic number $NUMBER is $NAME ($1). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      done

    else
     # check for element name
     ELEMENT_INFO=$($PSQL "SELECT atomic_number, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius
                                FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id)
                                WHERE elements.name = '$1'")
      if [[ $ELEMENT_INFO ]]
      then
      # read values for output
        echo "$ELEMENT_INFO" | while read NUMBER BAR SYMBOL BAR TYPE BAR MASS BAR MELTING_POINT BAR BOILING_POINT
        do
          echo "The element with atomic number $NUMBER is $1 ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $1 has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
        done

      else
        echo I could not find that element in the database.
      fi
    fi

  fi
else
  echo -e "Please provide an element as an argument."
fi
