#!/bin/bash



echo "Hello world!"

# focal="0" a="0" b="0" c="0"

# focal="18" a="0.02504" b="-0.06883" c="0.01502"
# focal="24" a="0.0203" b="-0.06514" c="0.04768"
# focal="29" a="0.00854" b="-0.01505" c="-0.00639"
# focal="35" a="-0.01582" b="0.04918" c="-0.05313"
# focal="41" a="-0.00694" b="0.02694" c="-0.03595"
# focal="46" a="-0.01908" b="0.07131" c="-0.08927"
# focal="55" a="-0.00098" b="0.01803" c="-0.04704"

# echo ` echo "-0.00098,0.01803,-0.04704" | awk -F, '{ print $3 }' `

# v="24.0 mm"
# echo `echo "$v" | cut -d "." -f1`

# exit 0



l1855["18"]="0.02504,-0.06883,0.01502"
l1855["24"]="0.0203,-0.06514,0.04768"
l1855["29"]="0.00854,-0.01505,-0.00639"
l1855["35"]="-0.01582,0.04918,-0.05313"
l1855["41"]="-0.00694,0.02694,-0.03595"
l1855["46"]="-0.01908,0.07131,-0.08927"
l1855["55"]="-0.00098,0.01803,-0.04704"

v=28

a=0; b=0; c=0; pFocal=0

for K in "${!l1855[@]}";do 
    if [ "$K" -le "$v"  ]; then
        # saving last focal value
        pFocal=$K
        
    else 
        # focal value greater than $K use previous
        break
    fi
done

echo "$pFocal to be used"

# lens=( "${l1855[@]}" )


a=` echo "${l1855[$pFocal]}" | awk -F, '{ print $1 }' `
b=` echo "${l1855[$pFocal]}" | awk -F, '{ print $2 }' `
c=` echo "${l1855[$pFocal]}" | awk -F, '{ print $3 }' `


echo "a=$a, b=$b, c=$c"
# echo ${l1855[$v]}
exit 0


v=45

# if [ (( $v -ge "45" ) && (( $v -l "50" )) ]
# then
#     echo "45-50"
# fi

# exit 0

if [ $v -le "46" ] 
then
    focal="46" a="-0.01908" b="0.07131" c="-0.08927"
elif [ $v -le "55" ]
then    
    focal="55" a="-0.00098" b="0.01803" c="-0.04704"
fi

echo "$focal $a $b $c"


