#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --no-align --tuples-only -c"

echo -e "\n\n~~~~~ Je Mange une Orange Boutique and Spa ~~~~~\n\n"
echo -e "Welcome to Je Mange une Orange Boutique and Spa.\n"

# until customer enters a valid service id
while [[ -z $SERVICE_TYPE ]] 
do  
  # DISPLAY_SERVICES "\nThat is not a valid option. Please try again."
  echo -e "How may I assist you today?\n"
  
  # Display available services
  echo "$($PSQL "SELECT service_id, name FROM services;")" | while IFS="|" read SERVICE_ID SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done

  # Have customer select service

  read SERVICE_ID_SELECTED
  SERVICE_TYPE="$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED;")"

  if [[ -z $SERVICE_TYPE ]]
  then
    echo -e "\nThat is not a valid option."
  fi
done

# Get customer phone number
echo -e "\nPlease enter your phone number"
read CUSTOMER_PHONE

# Get customer name
CUSTOMER_NAME="$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE';")"

# If not in database
if [[ -z $CUSTOMER_NAME ]]
then
  # Get customer name
  echo -e "Please enter your name"
  read CUSTOMER_NAME

  # Enter phone, name into database
  RESULT_INSERT_CUSTOMER="$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME');")"
fi

# Get customer id
CUSTOMER_ID="$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';")"
    
# Get service time
echo -e "Please enter what time you would like your appointment"
read SERVICE_TIME

# Insert appointment into appointment table
RESULT_INSERT_APPOINTMENT="$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")"

# Output confirmation message
echo -e "I have put you down for a $SERVICE_TYPE at $SERVICE_TIME, $CUSTOMER_NAME."