#!/bin/bash/
Welcome_screen (){
    echo "Hello Welcome to Annorion ATM services"
    echo "How may I help you?"
    sleep 0.5
    echo "1. Check my balance"
    echo "2. Withdraw money"
    echo "3. Pay bills"
    echo "0. End Application"
}
#Welcome_screen
input_file="atm_sheet.txt"

# Check if the column already exists
if ! awk -F ',' 'NR==1 { for (i=1; i<=NF; i++) if ($i == "Electric_bills") exit 0; exit 1 }' "$input_file"; then
    # Add the column header to the file
    sed -i '1s/$/,Electric_bills/' "$input_file"
    echo "Added new column."
else
    echo "202 OK"
    column4=4
    awk -F ',' -v col="$column4" 'NR>1 {$col = $col - 30} 1' OFS=',' "$input_file" > temp && mv temp "$input_file" 
    #awk -F ',' 'BEGIN { OFS="," } NR > 1 { $NF = $NF + 30 } 1' "$input_file" > tmpfile && mv tmpfile "$input_file"
fi

if ! awk -F ',' 'NR==1 { for (i=1; i<=NF; i++) if ($i == "Meter_id") exit 0; exit 1 }' "$input_file"; then
    sed -i '1s/$/,Meter_id/' "$input_file"
    echo "meter id column added"
else
    echo "202 OK"
fi

condition=false

while [ "$condition" = false ]; do
    Welcome_screen
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
    # Add depositing money to the menu
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
        echo "1. Electric Bills"
        echo "2. Hospital Bills"
        echo "3. DsTv Bills"
        echo "0. Go back"
        sleep 1
        read -p "Enter a 1,2 or 3 for the kind of bill: " bill_num
        if [ "$bill_num" -eq 1 ]; then
            echo "Please wait...!"
            column5=5
            read -p "Enter your meter id to pay the bill: " Meter_id
            # Add the fact that the ID must begin with EC and it must have an eight digit number to it
            # If the len of the ID is not up to 10, then the user must type it again or the first menu should appear
            # But if it is then proceed with the account number
            # Also provided the ID doesnt exist, we must ask the user if he wishes to provide his own ID
            # If yes then we must ask him for the ID then ask him for the account number
            # If the account number exist, proceed to payment and add the ID for future reference
            # If not, then tell the user that the account number doesnt exist then go back to the menu
            # 
            if awk -F ',' -v col="$column5" -v Meter_id="$Meter_id" '$col == Meter_id' atm_sheet.txt | grep -q "$Meter_id"; then
                read -p "Enter your account number: " account_num
                id_row=$(awk -F ',' -v col="$column5" -v Meter_id="$Meter_id" '$col == Meter_id' atm_sheet.txt)
                acct=$(echo "$id_row" | awk -F ',' '{print $2}')
                ECG_bill=$(echo "$id_row" | awk -F ',' '{print $4}')
                balance=$(echo "$id_row" | awk -F ',' '{print $3}')
                name=$(echo "$id_row" | awk -F ',' '{print $1}')
                if [ "$account_num" -eq "$acct" ] && [ "$ECG_bill" -lt 0 ]; then
                    echo "$name you owe GHS$ECG_bill of electricity bill"
                    read -p "How much do you wish to pay: " bill_amt
                    
                    let "cash = $ECG_bill + $bill_amt"
                    sleep 1
                    echo "Deducting from your account"
                    let "left = $balance - $bill_amt"
                    echo "Done !"
                    sleep 0.5
                    sed -i "s/$balance/$left/" atm_sheet.txt
                    sed -i "s/$ECG_bill/$cash/" atm_sheet.txt
                    echo "Your account balance is GHS$left"
                    # Add a situation where if the amount the person wants to pay is greater than the bill
                    # In this situation, say the bill is 30 and the amount to pay is 50, in this situation,
                    # An if statement saying if
                elif [ "$account_num" -eq "$acct" ] && [ "$ECG_bill" -ge 0 ]; then
                    echo "You dont have any outstanding bill to pay"
                
                elif [ "$account_num" -ne "$acct" ] && [ "$ECG_bill" -lt 0 ]; then
                    sleep 2
                    echo "This Meter ID $Meter_id is not associated with this account number but do you wish to proceed and pay the Electric bill?"
                    echo "This person owes GHS$ECG_bill of electricity bill."
                    read -p "Enter yes or no: " ans2
                    if [ "$ans2" = "yes" ]; then
                        read -p "How much do you wish to pay: " bill_amt
                        cc=2
                        result=$(awk -F ',' -v col="$cc" -v account_num="$account_num" '$col == account_num' atm_sheet.txt)
                        balance=$(echo "$result" | awk -F ',' '{print $3}')
                        sleep 1
                        echo "Deducting from your account please wait...!"
                        let "cah = $balance + $bill_amt"
                        sleep 3
                        echo "Done !"
                        sed -i "s/$balance/$cah/" atm_sheet.txt
                        sleep 1
                        echo "Paying the bill for Meter ID $Meter_id"
                        let "ec = $ECG_bill - $bill_amt"
                        sed -i "s/$ECG_bill/$ec/" atm_sheet.txt
                        sleep 2
                        echo "Your account balance is GHS$cah"
                        echo "Done !"
                        
                    elif [ "$ans2" = "no" ]; then
                        echo "Electric bill payment unsuccessfull"
                        echo "No deduction was done"
                    fi
                elif [ "$account_num" -ne "$acct" ] && [ "$ECG_bill" -ge 0 ]; then
                    sleep 2
                    echo "This Meter ID $Meter_id doesnt have any outstanding bill to pay"
                else
                    echo "This account number $account_num does not exist in our database !!!"
                fi
            
            else 
                echo "This Meter ID $Meter_id does not exist in our database."
                condition3=false
                
                read -p "Would you like to provide the Meter ID to us yes or no: " ans4
                if [ "$ans4" = "yes" ]; then
                    sleep 1
                    echo "Note meter ids starts with EC followed by the eight digit number"
                    sleep 1
                    echo "The system will reject any meter id that does not follow this rule"
                    sleep 2
                    while [ "$condition3" = false ]; do
                        read -p "Please enter your meter id: " meter
                        if [[ ! "$meter" =~ ^EC ]]; then
                            echo "The meter ID must start with EC"
                            ((attempt++))
                            condition3=false
                            if [ "$attempt" -gt 2 ]; then
                                echo "You have reached your maximum attempt"
                                sleep 2
                                echo "Going back to the menu"
                                condition3=true
                            fi
                        else
                            echo "This is a valid meter id"
                            sleep 2
                            read -p "Would you like to pay in your own account yes or no: " ans5
                            if [ "$ans5" = "yes" ]; then
                                read -p "Please enter your account number: " account_num
                                column2=2
                                if awk -F ',' -v col="$column2" -v account_num="$account_num" '$col == account_num' atm_sheet.txt | grep -q "$account_num"; then
                                    read -p "How much do you wish to pay: " bill_amt
                                    result=$(awk -F ',' -v col="$column2" -v account_num="$account_num" '$col == account_num' atm_sheet.txt)
                                    balance=$(echo "$result" | awk -F ',' '{print $3}')
                                    ECG_bill=$(echo "$result" | awk -F ',' '{print $4}')
                                    idm=$(echo "$result" | awk -F ',' '{print $5}')
                                    name=$(echo "$result" | awk -F ',' '{print $1}')
                                    sleep 1
                                    echo "Deducting from your account please wait...!"
                                    let "cah = $balance - $bill_amt"
                                    sleep 3
                                    echo "Done !"
                                    sed -i "s/$balance/$cah/" atm_sheet.txt
                                    sleep 1
                                    echo "Paying the bill for Meter ID $meter"
                                    let "ec = $ECG_bill + $bill_amt"
                                    sed -i "s/$ECG_bill/$ec/" atm_sheet.txt
                                    sed -i "s/$idm/$meter/" atm_sheet.txt
                                    sleep 2
                                    echo "Your account balance is GHS$cah"
                                    echo "Done !"
                                    break
                                else
                                    echo "This account is invalid or not found"
                                fi
                            else
                                echo "Sorry to see you go"
                                
                            fi
                        fi
                    done
                    condition=false
                else
                    echo "Going back to the main menu"
                fi

            fi
        elif [ "$bill_num" -eq 2 ]; then
            echo "Coming out soon"
        elif [ "$bill_num" -eq 0 ]; then
            condition=false
        fi


        condition=false
    # Add create an account option
    elif [ "$num" -eq 0 ]; then
        echo "Quitting application..."
            echo "Have a nice day !!"
        sleep 2
        condition=true
    else
        echo "Invalid input"
        condition=false
        continue
        
    fi
done


exit