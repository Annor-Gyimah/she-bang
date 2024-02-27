#!/bin/bash/

echo "Hello Welcome Annorion ATM services"
echo "How may I help you"
sleep 1
echo "1. Check my balance"
echo "2. Withdraw money"
echo "3. Pay bills"
condition=false

while [ "$condition" = false ]; do
    read -p "Enter a number to begin operation: " num
    if [ "$num" -eq 1 ]; then
        condition=true
        read -p "Enter your account number: " account_num
        column=2
        if awk -F ',' -v col="$column" -v account_num="$account_num" '$col == account_num' atm_sheet.txt | grep -q "$account_num"; then
            result=$(awk -F ',' -v col="$column" -v account_num="$account_num" '$col == account_num' atm_sheet.txt)
            name=$(echo "$result"  | awk -F ',' '{print $1}')
            balance=$(echo "$result" | awk -F ',' '{print $3}')
            echo "Account name $name with number $account_num your account balance is GHS $balance"
        else
            echo "Please the account number '$account_num' is not found"
            echo "Would you like to create an account with us?"
            read -p "Enter yes or no: " ans
            if [ "$ans" = "yes" ] ; then
                echo "Please fill out the details as they come up"
                sleep 1
                read -p "Enter your first name: " first
                echo "Saving 1 2 3..."
                sleep 2
                read -p "Enter the amount of money you want to deposit: " money
                echo "Saving 1 2 3..."
                sleep 2
                echo "Generating your account name for you please wait..."
                sleep 2
                account=$(python3 gen_digits.py)
                echo "$first,$account,$money" >> atm_sheet.txt
                sleep 1
                echo "Done!, it was nice doing business with you."
                condition=false
            elif [ "$ans" = "no" ]; then
                echo "Sorry you couldnt be with us. You can always come back later and create an account."
                sleep 1
                echo "Have a nice day"
                condition=false
            else
                echo "Invalid response."
                sleep 1
                echo "Have a nice day"
                condtion=false
            fi
        fi
    else
        echo "Invalid input"
        condition=false
        continue
        
    fi
done
#awk -F ',' '$1 == "Kofi"' atm_sheet.txt
# FILENAME="/home/gyimah/BASH/atm_sheet.txt"
# while IFS= read -r line || [ -n "$line" ]; do
#  awk -F ',' '$1 == "Kofi"' atm_sheet.txt
#  #echo "$line
# done <$FILENAME

exit