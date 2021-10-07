#!/bin/zsh
cert_list=$(echo '' | openssl s_client -showcerts -connect "$1" > /dev/null 2>&1| sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p')
printf "\n"
delimiter="-----END CERTIFICATE-----"
string=$cert_list$delimiter
myarray=()
while [[ $string ]]; do
  myarray+=( ${string%%"$delimiter"*} )
  string=${string#*"$delimiter"}
done
for value in ${myarray[@]}
do
	echo "$value-----END CERTIFICATE-----" | openssl x509 -noout -text | grep "Subject: " 
	echo -n '    '
	echo "$value-----END CERTIFICATE-----" | openssl x509 -noout -text | grep "Signature Algorithm" | uniq
	printf "\n"
done