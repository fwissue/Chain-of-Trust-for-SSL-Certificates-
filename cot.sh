#!/bin/sh
vi cert.txt
vi bundle.txt
cat bundle.txt | awk 'split_after==1{n++;split_after=0}
   /-----END CERTIFICATE-----/ {split_after=1}
   {if(length($0) > 0) print > "bundle" n+1 ".pem"}'

lcnt=`ls bundle*.pem | wc -l`
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

if [ $c_akid == ${b_skid[1]} ]
       then
         echo "Cert is matching Bundle1"
       else
         echo "Cert is not maching bundle1"
       fi

if [ ${b_skid[$lcnt]} == ${b_akid[$lcnt]} ]
   then
      echo "Root Cert found in Bundle"$lcnt
   else
     echo "No root cert found in Bundle"$lcnt
fi
for ((i=1; i<$lcnt; i++))
    do
      if [ ${b_akid[$i]} == ${b_skid[$i+1]} ]
       then
        echo "Bundle"$i "is matching bundle"$(($i+1))
      else
        echo "Bundle"$i " is not matching bundle"$(($i+1))
      fi
    done