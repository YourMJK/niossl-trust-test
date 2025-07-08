Minimal example for `TLSConfiguration.additionalTrustRoots` issue with [swift-nio-ssl](https://github.com/apple/swift-nio-ssl), **see https://github.com/apple/swift-nio-ssl/issues/46#issuecomment-3042689554**

## MQTT example
**NOTE:** This only works with a corresponding MQTT broker (e.g. [mosquitto](https://github.com/eclipse-mosquitto/mosquitto)) that was setup with the certificate and private key in this repo.

If you have `mosquitto` installed locally (`$ brew install mosquitto`), you can use `startMQTTBroker.sh` to start an MQTT broker with a matching configuration'

### Build
`$ make mqtt-client`

### Run
``` sh
$ startMQTTBroker.sh &             # Needs mosquitto installed
$ startMQTTClient.sh               # Client with certificate in TLSConfiguration.trustRoots
$ startMQTTClient.sh --additional  # Client with certificate in TLSConfiguration.additionalTrustRoots
$ bin/mqtt-client -h               # For all available options
```

## HTTP example
**NOTE:** I couldn't get [async-http-client](https://github.com/swift-server/async-http-client) to work with the root certificates generate by [my `openssl` command in the Makefile](Makefile#L28-L32).

That's why, when using the certificate in this repo, the client will always throw an error  
`Trust failed: “niossl.test” certificate is not permitted for this usage` when started without `--additional`.  
Maybe this can fixed using a different certificate chain.

**But the MQTT example is fully working in demonstrating the issue.**

### Build
`$ make server client`

### Run
``` sh
$ startServer.sh &
$ startClient.sh               # Client with certificate in TLSConfiguration.trustRoots
$ startClient.sh --additional  # Client with certificate in TLSConfiguration.additionalTrustRoots
$ bin/client -h                # For all available options
```
