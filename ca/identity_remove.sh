USER=tls-ca-admin

while getopts ':u:c:' o; do
    case $"${o}" in
        u)
            USER=$OPTARG
            ;;
        c)
            ID=$OPTARG
            ;;
        *)
            # usage
            ;;
    esac
done

export FABRIC_CA_CLIENT_TLS_CERTFILES=$PWD/ca/tls-ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$PWD/ca/client/$USER

fabric-ca-client identity remove $ID