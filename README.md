ondevice.io docker demo
=======================

We've provided an easy-to-use docker image for you to try out ondevice.io.  
The only things you need are docker and an internet connection.

There are two sides to each ondevice tunnel: the device and the client.

The device daemon (started by calling `ondevice daemon`) usually keeps running
in the background of the systems you want access to, waiting for clients to
connect.

We'll start by starting an `ondevice daemon` and then using `ondevice ssh` to
connect to it.  
You can run both on the same system if you like, but the whole point of ondevice.io
is being able to reach your devices from anywhere :)


But let's get started (for further information go to [ondevice.io][0])

## Device side

We'll create a temporary docker container for the device:

    docker run --rm -ti ondevice/demo

It's basically a fresh debian install with curl and openssh-server installed,
as well as a freshly created `user` account that's been configured with the
ondevice.io credentials for the `hello` account.

Before you can continue, the entrypoint script will ask you to set a password for
`user`.  
Choose one that's not too weak, since everybody with access to the `hello` ondevice.io
account will be able to connect to your device's SSH server.

Optional:  
If you already have an ondevice.io account (creating one just takes a few minutes)
or want a little privacy, run `ondevice setup` to re-authenticate with the ondevice.io
servers.

Run `ondevice daemon`.

After one or two seconds, run

```bash
$ ondevice status
Device:
  ID: hello.abcdef
Client:
  version: 0.2.6
```

Note the device ID (the user name prefix is optional) and keep that container running.  
In our example, the device ID is `abcdef`. We'll need that ID in order to connect to the device.

### on the client

On the client you can use the same `ondevice/demo` docker image (it'll ask you for a password again,
but on the client that's not really important).

Once you got the prompt, you're ready to connect to your device (replace `abcdef` with your random device ID):

    $ ondevice ssh user@abcdef
    Password:
    myuser@aojkafasd ~ $ 

That's basically it. Now you can do everything SSH has to offer.  
The only difference to running SSH directly is the `ondevice ` prefix and device IDs instead of host names.

Some stuff you might wanna try out:

- Running a command and exit: `ondevice ssh user@device ps -ef | grep ondevice`  
  (`grep` will actually run locally in the above example)
- Port forwarding: `ondevice ssh user@device -L 1234:localhost:80`
- Proxy: `ondevice ssh user@device -D 1080`  
  Now set your browser's SOCKS proxy to `localhost:1080` and you'll browse the web as if you were on the device's network
- rsync: `ondevice rsync user@device:/etc/motd /tmp/motd`
- ...


Further steps
-------------

- [Create your own ondevice.io account][1]
- Install it on your systems:
  - on debian based systems, we provide a simple installer that can be invoked by running:  
    `curl -sSL https://repo.ondevice.io/install_deb.sh | bash -e`
  - on other systems, use Python3's `pip`:  
    `pip3 install ondevice`
- Have a look at `ondevice help`


[0]: https://ondevice.io/
[1]: https://ondevice.io/signup
