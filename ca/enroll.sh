USER=tls-ca-admin
PW=tls-ca-adminpw
SERVER_HOST=localhost:7054

while getopts ':u:p:s:' o; do
    case $"${o}" in
        u)
            USER=$OPTARG
            ;;
        p)
            PW=$OPTARG
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
export FABRIC_CA_CLIENT_HOME=$PWD/ca/users/$USER

fabric-ca-client enroll -d -u https://$USER:$PW@$SERVER_HOST