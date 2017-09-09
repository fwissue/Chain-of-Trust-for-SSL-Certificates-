#!/bin/sh
######
# Version 0.1 
# Check Cert/Bundle/Root with linked akid/skid based on RFC5280
# Version 0.2
# Check root cert without akid
# Version 0.3
# Check multiple root certs
# Version 0.4
# Put all cert in bundle in correct order
#
#  @ Michael Liu
# Script is for demostration only, still need polished.
# Feel free to modify it 
######

vi cert.txt
vi bundle.txt
openssl x509 -in cert.txt -issuer  -noout
cat bundle.txt | awk 'split_after==1{n++;split_after=0}
   /-----END CERTIFICATE-----/ {split_after=1}
   {if(length($0) > 0) print > "bundle" n+1 ".pem"}'

lcnt=`grep -c "\----END CERTIFICATE-----" bundle.txt`
echo "Total of Certs in Bundle is " $lcnt
for ((i=1; i<=$lcnt; i++))
do 
b_akid[$i]=$(openssl x509 -in bundle$i.pem -text -noout | grep -i "Authority Key" -A1 | tail -n1 | cut -f2-21 -d:)
b_skid[$i]=$(openssl x509 -in bundle$i.pem -text -noout | grep -i "Subject Key" -A1 | tail -n1)
done

c_akid=$(openssl x509 -in cert.txt -text -noout | grep -i "Authority Key" -A1 | tail -n1 | cut -f2-21 -d:)
echo "c_akid" == $c_akid
for ((i=1; i<=$lcnt; i++))
do
echo "b_akid$i" == ${b_akid[$i]}
echo "b_skid$i" == ${b_skid[$i]}
done

#find multiple root certs
r=0
for ((i=1; i<=$lcnt; i++))
   do
     if [ "${b_akid[$i]}" == "" ]
       then
             r=$(($r+1))
     fi
   done
for ((i=1; i<=$lcnt; i++))
  do
    if [ "${b_akid[$i]}" != "" ]
     then
       if [ ${b_akid[$i]} == ${b_skid[$i]} ]
         then
           r=$(($r+1))
           echo "root matched" ${b_akid[$i]}
         fi
     fi
  done

if [ $r -gt 1 ]
  then
    echo "you have multiple root certs"
    exit 1
fi

#find root cert
for ((i=1; i<=$lcnt; i++))
 do 
   if [ "${b_akid[$i]}" == "" ] || [ ${b_akid[$i]} == ${b_skid[$i]} ]
   then
#     echo "================"
#     echo "Root cert is "${b_skid[$i]}
     B_akid[$lcnt]=${b_akid[$i]}
     B_skid[$lcnt]=${b_skid[$i]}
   fi
done

if [ "${B_skid[$lcnt]}" == "" ]
  then
    echo "No root cert found"
    exit
fi

for ((j=$lcnt; j>=1; j--))
  do 
   for ((i=1; i<=$lcnt; i++))
    do
     if [ "${b_akid[$i]}" == "" ] 
      then
        continue
      elif [ ${B_skid[$j]} == ${b_akid[$i]} ]
        then
          p=$(($j-1))
          #echo "p" $p
          #echo "i" $i
          #echo ${b_akid[$i]}
          #echo ${b_skid[$i]}
          B_skid[$p]=${b_skid[$i]}
          B_akid[$p]=${b_akid[$i]}
          break
      fi
    done
  done

echo "================"
echo "c_akid = " $c_akid
for ((i=1; i<=$lcnt; i++))
do 
echo "B_akid$i" = ${B_akid[$i]}
echo "B_skid$i" = ${B_skid[$i]}
done

p=$c_akid
pflag=0
for ((i=1; i<=$lcnt; i++))
 do 
   if [ "${B_skid[$i]}" == "" ]
   then 
    continue
  elif [ ${B_skid[$i]} == $p ]
   then
     p=${B_akid[$i]}
     pflag=$(($pflag+1))
  fi
 done

echo $pflag
if [ "$pflag" -eq "$lcnt" ]
  then
    echo "Cert, Bundle and Root are matching"
  else
    echo "Cert, Bundle and Root are NOT matching"
fi
