USER=caserver
PW=caserverpw

while getopts ':u:p:' o; do
    case $"${o}" in
        u)
            USER=$OPTARG
            ;;
        p)
            PWD=$OPTARG
            ;;
        s)
            SERVER_HOST=$OPTARG
            ;;
        *)
            # usage
            ;;
    esac
done

export FABRIC_CA_CLIENT_TLS_CERTFILES=$PWD/ca/tls-ca/crypto/ca-cert.pem
source $PWD/ca/setclient.sh caserver admin

fabric-ca-client identity list