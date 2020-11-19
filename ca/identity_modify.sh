USER=caserver

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
source $PWD/ca/setclient.sh caserver admin

fabric-ca-client identity modify $USER --attrs 'hf.Revoker=true,admin=true:ecert'