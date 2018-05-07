#!/bin/bash


POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

# setting up for more options in case I think of the
case $key in
    -f|--file)
    file="$2";
    shift 2;
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

echo "allowing SSH from file:"
echo file  = "${EXTENSION}"

echo "for security group: "
group=$(<${file})
echo ${group}

if [ ! -z ${group} ]; then
    address=$(curl v4.ifconfig.co | awk '{ print $0 "/32" }')
    echo  "${address} "
    aws ec2 authorize-security-group-ingress --group-id "${group}"  --protocol tcp --port 22 --cidr ${address}
else
    echo "Error: No security group found."
fi