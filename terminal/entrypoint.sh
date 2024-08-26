#! /bin/zsh

cd /var/init

# wait until iamlive cert is mounted
until [ -f /usr/local/share/ca-certificates/ca.pem ]; do
	sleep 5
done

# Update certificates to include cert from iamlive (mounted via docker-compose)
# sh must be linked to busybox for update-ca-certificates to work
# if [ ! -f /usr/sh ]; then
#   ln -s /bin/sh /bin/busybox
# fi

update-ca-certificates

# Remove sh in favor of zsh
# rm /bin/sh

cd /var/app && /bin/zsh
