#!/bin/sh

chmod 777 /var/run/docker.sock

addgroup -g $RUN_GROUP rungroup
adduser -u $RUN_USER runuser -G rungroup -D

ln -s /root/.porter /home/runuser/.porter

cat <<EOF > /runcmd.sh
#!/bin/sh

cd $PWD

/root/.porter/porter $*

EOF

chmod 777 /runcmd.sh


su - runuser -c /runcmd.sh
