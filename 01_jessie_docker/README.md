# ondevice daemon in a plain debian docker container

# on the device side

Ok, let's get started. Fire up a temporary docker container:

    docker run --rm -ti debian:jessie /bin/bash

In it, install the core requirements (`curl` to download the install script and `openssh-server` as SSH server)

    apt-get update && apt-get -y install curl openssh-server

In order to connect to it via SSH, add a user andstart the SSH server

    adduser --gecos 'some user' myuser
    /etc/init.d/ssh start

Everything set up? Then let's fetch the ondevice client software:

    curl -sSL https://repo.ondevice.io/install_deb.sh | bash -e

Once that's installed, let's switch to our newly created user:

    su - myuser

From now on, everything is done as `myuser`

Run `ondevice setup` and enter the API keys that's been generated for your account  

    $ ondevice setup
    User: ...
    Api-Key: ...


Time to start the ondevice daemon

```bash
$ ondevice daemon
# ... and get the new device's ID
$ ondevice status
Device:
  ID: hello.abcdef
Client:
  version: 0.2.6
```

Ok, so our new device's ID is `hello.abcdef` (yours will be different. copy it somewhere, we'll need that later)

Keep the device terminal running (the docker container will be destroyed as soon as you exit it - we've specified the `--rm` flag after all)

### on the client

Open a new terminal on the client and install `ondevice` again (using the `install_deb.sh` line) if you haven't done so already

    $ ondevice ssh myuser@abcdef
    Password:
    myuser@aojkafasd ~ $ 

(you could use `myuser@hello.abcdef` here, but you don't need to use the qualified notation for your own devices)

That's basically it. Now you can do everything SSH has to offer.
The only difference to running SSH directly is the `ondevice ` prefix and the different host names.

- Running a command and exit: `ondevice ssh user@device ps -ef | grep ondevice`  
  (`grep` will actually run locally in the above example)
- Port forwarding: `ondevice ssh user@device -L 1234:localhost:80`
- Proxy: `ondevice ssh user@device -D 1080`  
  Now set your browser's SOCKS proxy to `localhost:1080` and you'll browse the web as if you were on the device's network
- rsync: `ondevice rsync user@device:/etc/motd /tmp/motd`
- ...


Further steps
-------------

- Have a look at `ondevice help`
- device properties are perfect for automated tasks. Just write a cron script that periodically runs `ondevice list --json --props`, run your target script on devices that lack a certain identifying property (using `ondevice ssh`) and if that script ran successfully, add the identifying propery for that device (`ondevice device <devId> set foo=bar`)  

