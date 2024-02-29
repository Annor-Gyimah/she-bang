#!/bin/bash/
echo "Hello Welcome to Annorion ATM services"
echo "How may I help you?"
sleep 0.5
echo "1. Check my balance"
echo "2. Withdraw money"
echo "3. Pay bills"
echo "0. End Application"
condition=false

while [ "$condition" = false ]; do
    read -p "Enter a number to begin operation: " num
    if [ "$num" -eq 1 ]; then
        condition=true
        condition1=false
        while [ "$condition1" = false ]; do
            read -p "Enter your account number: " account_num
            column=2
            if awk -F ',' -v col="$column" -v account_num="$account_num" '$col == account_num' atm_sheet.txt | grep -q "$account_num"; then
                
                result=$(awk -F ',' -v col="$column" -v account_num="$account_num" '$col == account_num' atm_sheet.txt)
                name=$(echo "$result"  | awk -F ',' '{print $1}')
                balance=$(echo "$result" | awk -F ',' '{print $3}')
                echo "Account name $name with number $account_num your account balance is GHS$balance"
                condition1=true
            else
                ((attempt++))
                condition1=false
                if [ "$attempt" -gt 3 ] ; then
                    echo "You have reached the maximum attempt"
                    sleep 2
                    echo "Please the account number '$account_num' was not found"
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
                        echo "Generating your account number for you please wait..."
                        sleep 2
                        account=$(python3 gen_digits.py)
                        echo "Your account number is $account"
                        echo "$first,$account,$money" >> atm_sheet.txt
                        sleep 1
                        echo "Done!, it was nice doing business with you."
                        break
                
                    else
                        echo "Sorry you couldnt be with us. You can always come back later and create an account."
                        sleep 1
                        echo "Have a nice day"
                        condition1=true
                        
                    fi
                fi
                
            fi
        done
        condition=false
    elif [ "$num" -eq 2 ]; then
        sleep 1
        echo "please wait"!!
        sleep 1
        condition2=false
        while [ "$condition2" = false ] ; do
            column=2
            read -p "Please enter your account number to proceed: " account_num
            if awk -F ',' -v col="$column" -v account_num="$account_num" '$col == account_num' atm_sheet.txt | grep -q "$account_num"; then
                sleep 2
                echo "Verifying.....!"
                sleep 1
                result=$(awk -F ',' -v col="$column" -v account_num="$account_num" '$col == account_num' atm_sheet.txt)
                balance=$(echo $result | awk -F ',' '{print $3}')
                read -p "Please enter the amount to withdraw: " amt
                sleep 1
                amt=${amt##+(0)}
                let "left = $balance - $amt"
                column_3=3
                if [ "$amt" -lt "$balance" ] && [ "$left" -gt 20 ]; then
                    sed -i "s/$balance/$left/" atm_sheet.txt
                    sleep 1
                    echo "Your remaining balance is $left"
                    condition2=true
                elif [ "$amt" -eq "$balance" ]; then
                    sleep 1
                    echo "Please you can't withdraw this amount. Try a lesser amount than $amt"
                    sleep 1
                    condition2=false
                elif [ "$balance" -eq 20 ] && [ "$amt" -lt 20 ]; then
                    sleep 1
                    echo "Please GHS20 is the minimum amount and you cant withdraw less than the inital amount."
                    condition2=true
                elif [ "$balance" -eq 20 ] && [ "$amt" -gt 20 ]; then
                    echo "Please GHS20 is the minimum amount and you dont have enough funds to withdraw this amount $amt"
                    condition2=true
                fi

            else
                echo "Please the account number '$account_num' was not found"
                sleep 2
                echo "Would you like to create an account with us?"
                read -p "Enter yes or no: " ans
                if [ "$ans" = "yes" ] ; then
                    echo "Please fill out the details as they come up"
                    sleep 1
                    read -p "Enter your first name: " first
                    echo "Saving 1 2 3..."
                    sleep 2
                    # Add the condition where the amount of money put inside is not less than GHS20
                    read -p "Enter the amount of money you want to deposit: " money
                    echo "Saving 1 2 3..."
                    sleep 2
                    echo "Generating your account number for you please wait..."
                    sleep 2
                    account=$(python3 gen_digits.py)
                    echo "Your account number is $account"
                    echo "$first,$account,$money" >> atm_sheet.txt
                    sleep 1
                    echo "Done!, it was nice doing business with you."
                    break
            
                else
                    echo "Sorry you couldnt be with us. You can always come back later and create an account."
                    sleep 1
                    echo "Have a nice day"
                    break
                fi
                condition2=true    

            fi

        done
        condition=false    
    elif [ "$num" -eq 3 ]; then
        echo "This feature will arrive soon"
        sleep 1
        condition=false
    elif [ "$num" -eq 0 ]; then
        echo "Quitting application..."
        sleep 3
        condition=true
    else
        echo "Invalid input"
        condition=false
        continue
        
    fi
done


exit