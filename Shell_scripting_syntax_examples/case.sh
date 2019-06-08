
#!/bin/bash 
echo "Please talk to me...."

while :
do

read input_string
case $input_string in
     hello)
          echo "Hello yourself!"
;;
bye)
    echo "See you again!"
    break;
    ;;
*)   echo "Sorry I don't understand "
     ;;
esac

echo 
echo "That's all folks!"

done 
