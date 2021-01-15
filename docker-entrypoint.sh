#!/bin/sh

DOCKER_SOCKET=/var/run/docker.sock
DOCKER_GROUP=docker

echo "create user with id ${RUN_USER}:${RUN_GROUP}"
addgroup -g $RUN_GROUP rungroup
adduser -u $RUN_USER runuser -G rungroup -D -h /root

if [ -S ${DOCKER_SOCKET} ]; then
    DOCKER_GID=$(stat -c '%g' ${DOCKER_SOCKET})

    delgroup docker
    echo "create docker group with id ${DOCKER_GID}, add user to group"
    addgroup -g ${DOCKER_GID} ${DOCKER_GROUP}
    adduser runuser ${DOCKER_GROUP}
fi

#ln -s /root/.porter /home/runuser/.porter
mkdir /root/.docker
chmod 777 /root/.docker
#ln -s /root/.docker /home/runuser/.docker

if [ -z ${DOCKER_REGISTRY} ] || [ -z ${DOCKER_REGISTRY_USER} ] || [ -z ${DOCKER_REGISTRY_PASS} ]; then
echo "docker login not done, no registry specified (DOCKER_REGISTRY, DOCKER_REGISTRY_USER, DOCKER_REGISTRY_PASS)"
else
echo "$DOCKER_REGISTRY_PASS" | docker login $DOCKER_REGISTRY --username $DOCKER_REGISTRY_USER --password-stdin
chmod 777 /root/.docker/config.json
fi

cat <<EOF > /runcmd.sh
#!/bin/sh

cd $PWD

/root/.porter/porter $*

EOF

chmod 777 /runcmd.sh


su - runuser -c /runcmd.sh
