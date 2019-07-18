## Setup

### Mac OSX and Linux

1. Follow the setup instructions
   Linux (https://www.lambdatest.com/support/docs/display/TD/Local+Testsing+For+Linux)
   Mac (https://www.lambdatest.com/support/docs/display/TD/Local+Testing+For+MacOS)
   for Lambda Tunnel. Make sure the `LT` binary ends up in your `LT_TUNNEL_PATH`.
   ```
   for example:
   $ export LT_TUNNEL_PATH=/home/username/Downloads/LT_Linux/LT
    ```
2. Create environment variables for your LambdaTest credentials.
   
   ```
   $ export LT_USERNAME=<your LambdaTest username>
   $ export LT_ACCESS_KEY=<your LambdaTest access key>
   
   ```

3. Create environment variables for your WonderProxy credentials.

   ```
   $ export WONDERPROXY_USER=<your WonderProxy username>
   $ export WONDERPROXY_PASS=<your WonderProxy password>
   ```
3. Create environment variables for your tunnel logs path.

   ```
   for example:
   $ export LT_DIR=/home/username/Desktop/tunnels/
   ```
## Create LambdaTest Tunnels

### Mac OSX and Linux

The `lt_tunnel.sh` helper script will create one tunnel for each
WonderProxy server name that you specify as an argument. For example:

```
# creates two tunnels: one for telaviv.wonderproxy.com, and one for
# london.wonderproxy.com
$ ./lt_tunnel.sh telaviv london
```
Running the script adding the wonderproxy server namse

```
$ ./lt_tunnel.sh albuquerque telaviv vancouver
```

## Run the tests (Mac OSX and Linux only)

Please refer the LambdaTest docs (https://www.lambdatest.com/support/docs/getting-started-with-lambdatest-automation/)
To use the different tunnel servers in the test,pass the capability in capability object 
for example:
` tunnel: true `,
`tunnelName: telaviv `


## Close the LambdaTest Tunnels

### Mac OSX and Linux

The `lt_tunnel_kill.sh` helper script will close the tunnel for each
WonderProxy server name that you specify as an argument and will clean up any logs and
output files.

```
# close three tunnels
$ ./lt_tunnel_kill.sh albuquerque telaviv vancouver
```



