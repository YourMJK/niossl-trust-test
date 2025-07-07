cd "$(dirname "$0")"

CERT=cert.pem KEY=key.pem bin/server serve "$@"
