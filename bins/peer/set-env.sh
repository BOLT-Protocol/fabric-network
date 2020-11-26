# EDIT THIS To Control the Peer Setup
export ORDERER_ADDRESS=10.110.200.53:7050

export FABRIC_LOGGING_SPEC=debug

# export CORE_PEER_LOCALMSPID=DefaultMSP
export CORE_PEER_LOCALMSPID=BoltMSP

# Admin identity used for commands
export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/bolt.com/users/Admin@default.com/msp
# export CORE_PEER_MSPCONFIGPATH=${PWD}/ca/client/bolt/bolt-admin/msp

export FABRIC_CFG_PATH=${PWD}/bins/peer
