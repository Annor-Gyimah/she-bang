#!/bin/bash
#
#echo "Hello world, I am excited learning shell scripting" 

#read -p "Enter a password" pass
#if [ "$pass" -ge 70 ] ; then 
#echo "You got first class"

#elif [ "$pass" -ge 60 ] && [ "$pass" -lt 70 ] ; then
#echo "You got second class brilla"

#elif  [ "$pass" -ge 50 ] && [ "$pass" -lt 60 ] ; then
#echo "You got pass waben paa"

#else
#echo "Wo y3 Einsten"
#fi
# echo "Welcome to a guessing game"
# read -p "Enter a magic number" num
# for i in 1 2 3 4 5; do 
# echo "Guessing the number in $i"
# done
# if [ "$num" -ge 1 ] && [ "$num" -lt 5 ] ; then
# let "ans = 5 - $num"
# echo "The number is $ans"
# #elif ["$num" -ge 2] && ["$num" -lt 4] ; then
# #ans = 4 - $num
# #echo "The number is $ans"
# #elif ["$num" -ge 3] && ["$num" -lt 3] ; then
# #ans = 3- $num
# #echo "The number is $ans"
# else
# echo "The number is 0"
# fi

#!/bin/bash
echo "This is my first quiz"
#rm -r "MyData"
#mkdir "MyData"

< Kumasi.txt head > "dta.txt" 
< Kumasi.txt tail >> "dta.txt"
echo "Number of lines is" > "tta.txt"; wc -l "dta.txt" >> "tta.txt"; 
echo "Number of characters are" >> "tta.txt"; wc -c "dta.txt" >> "tta.txt";
echo "Number of words are" >> "tta.txt"; wc -w "dta.txt" >> "tta.txt";
mv "dta.txt" "MyData"; mv "tta.txt" "MyData";
cd "MyData"; ls -l | wc -l > "tta1.txt";
echo "it was fun doing this exercise"

FILENAME="/home/gyimah/BASH/Kumasi.txt"
while IFS=: read -r  line; do
echo "$line"
done < $FILENAME

# FILENAME="/etc/passwd"
# while IFS=: read -r username password userid groupid comment homedir cmdshell
# do
#  echo "$username, $userid, $comment $homedir"
# done < $FILENAME
# if [ "$username" == "gyimah" ] ; then
# echo "yes baby"
# fi
exit
