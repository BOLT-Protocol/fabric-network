USER=org1_user1
PW=userpw
SERVER_HOST=localhost:7054

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
export FABRIC_CA_CLIENT_HOME=$PWD/ca/users/tls-ca-admin

fabric-ca-client register -d --id.name $USER --id.secret $PW --id.type peer -u https://$SERVER_HOST