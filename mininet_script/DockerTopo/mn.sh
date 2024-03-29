#!/bin/bash

ip=$(sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $2)
from_switch=$1
to_switch=$2
container_name=$3

image_name=$container_name

sudo docker exec -i $from_switch bash <<EOF
echo "$ip"
docker container stop $container_name
docker commit $container_name $image_name
docker save $image_name | gzip > ${image_name}.tar.gz
rsync -r -e ssh /root/${image_name}.tar.gz root@$ip:/root/
rm ${image_name}.tar.gz
docker container rm ${container_name}
exit
EOF

echo "\nContainer $1 off and $2 is now start\n"

sudo docker exec -i $to_switch bash <<EOF
gunzip -c ${image_name}.tar.gz | docker load

exit
EOF
