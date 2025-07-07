cd "$(dirname "$0")"

bin/mqtt-client --cert cert.pem --sni "niossl.test" "$@"
