
export FABRIC_CA_CLIENT_TLS_CERTFILES=$PWD/ca/tls-ca/crypto/ca-cert.pem
# TODO
export FABRIC_CA_CLIENT_HOME=$PWD/ca/client/caserver/admin

fabric-ca-client affiliation add $1