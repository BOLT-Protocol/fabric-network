# EDIT THIS To Control the Peer Setup
export ORDERER_ADDRESS=54.219.75.228:7050

export FABRIC_LOGGING_SPEC=DEBUG

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_PROFILE_ENABLED=true
export CORE_PEER_TLS_CERT_FILE=${PWD}/crypto-config/peerOrganizations/default.com/peers/devpeer/tls/server.crt
export CORE_PEER_TLS_KEY_FILE=${PWD}/crypto-config/peerOrganizations/default.com/peers/devpeer/tls/server.key
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/crypto-config/peerOrganizations/default.com/peers/devpeer/tls/ca.crt
export CORE_PEER_LOCALMSPID=DefaultMSP
# Admin identity used for commands
export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/default.com/peers/devpeer/msp
export CORE_PEER_ADDRESS=0.0.0.0:7051
export FABRIC_CFG_PATH=${PWD}/bins/peer
export ORDERER_CA=${PWD}/crypto-config/ordererOrganizations/default.com/orderers/orderer.default.com/msp/tlscacerts/tlsca.default.com-cert.pem



# export CORE_PEER_ID=peer0.org1.example.com
# export CORE_PEER_ADDRESS=peer0.org1.example.com:7051
# export CORE_PEER_LISTENADDRESS=0.0.0.0:7051
# export CORE_PEER_CHAINCODEADDRESS=peer0.org1.example.com:7052
# export CORE_PEER_CHAINCODELISTENADDRESS=0.0.0.0:7052
# export CORE_PEER_GOSSIP_BOOTSTRAP=peer0.org1.example.com:7051
# export CORE_PEER_GOSSIP_EXTERNALENDPOINT=peer0.org1.example.com:7051
