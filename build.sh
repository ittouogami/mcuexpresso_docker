IPADDRESS=$(ip addr show $( netstat -rn | grep UG | awk -F' ' '{print $8}') \
    | grep -o 'inet [0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+' \
    | grep -o [0-9].*)
docker image build \
    --rm \
    --build-arg IP=${IPADDRESS} \
    --build-arg IDE_VER=11.3.0_5222 \
    --build-arg SDK_VER=aaa \
    --no-cache \
    -t mcuxpresso .
