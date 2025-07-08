cd "$(dirname "$0")"

bin/mqtt-client --cert cert.pem --host localhost --sni "niossl.test" "$@"
