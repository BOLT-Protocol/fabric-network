# EDIT THIS To Control the Peer Setup
export ORDERER_ADDRESS=54.219.75.228:7050

export FABRIC_LOGGING_SPEC=info

export CORE_PEER_TLS_ENABLED=true

export CORE_PEER_LOCALMSPID=DefaultMSP

# Admin identity used for commands
export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/default.com/users/Admin@default.com/msp

export FABRIC_CFG_PATH=${PWD}/bins/peer
