USER=caserver
PW=caserverpw
SERVER_HOST=localhost:7054
AFFILIATION=''
while getopts ':u:p:a:' o; do
    case $"${o}" in
        u)
            USER=$OPTARG
            ;;
        p)
            PW=$OPTARG
            ;;
        a)
            AFFILIATION=$OPTARG
            ;;
        *)
            # usage
            ;;
    esac
done

export FABRIC_CA_CLIENT_TLS_CERTFILES=$PWD/ca/tls-ca/crypto/ca-cert.pem
# TODO: caserver
source $PWD/ca/setclient.sh caserver admin

fabric-ca-client register -d --id.name $USER --id.secret $PW --id.affiliation $AFFILIATION --id.type admin -u https://$SERVER_HOST
