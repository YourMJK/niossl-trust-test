cd "$(dirname "$0")"

bin/client --cert cert.pem --sni "niossl.test" "$@"
