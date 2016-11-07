#!/bin/bash -e
#
# start the SSH server, the ondevice daemon and an interactive bash shell

/etc/init.d/ssh start

# su - user -c 'ondevice daemon'
echo
echo ondevice.io demo container
echo --------------------------
echo

if ! [ -f /home/user/.pwdChanged ]; then
	cat <<EOF
Thanks for giving ondevice.io a try.

This docker image gives you a quick and easy way to try out ondevice.io.
It's preconfigured with credentials for the 'hello' ondevice.io user.

But since anybody has access to the 'hello' user, we'll have to ask you
to set a password for this docker container's user (not necessary on the client side):

EOF

	if passwd user; then
		touch /home/user/.pwdChanged
	else
		echo >&2
		echo "=========================================" >&2
		echo "= Password change failed. You won't be able to log into this device," >&2
		echo "= but can still use it as a client." >&2
		echo "=========================================" >&2
	fi
fi

cat <<EOF



If you want to use different credentials, run
  ondevice setup

To run in device mode:
- start the daemon using 'ondevice daemon'
- wait 1 or 2 seconds and run 'ondevice status' to get the device ID

And on the client:
- ondevice ssh user@<deviceId>

Have fun, and if you have any questions, contact us at info@ondevice.io.
EOF

su - user -s /bin/bash
