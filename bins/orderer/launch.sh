#  Launches the orderer
#  You may override orderer properties in this file

# Change the logging leve to the desired level
export FABRIC_CFG_PATH=${PWD}/bins/orderer
export FABRIC_LOGGING_SPEC=DEBUG
export ORDERER_GENERAL_BOOTSTRAPFILE=${PWD}/artefacts/default-genesis.block
export ORDERER_GENERAL_LOCALMSPDIR=${PWD}/crypto-config/ordererOrganizations/default.com/orderers/orderer.default.com/msp
export ORDERER_GENERAL_TLS_PRIVATEKEY=${PWD}/crypto-config/ordererOrganizations/default.com/orderers/orderer.default.com/tls/server.key
export ORDERER_GENERAL_TLS_CERTIFICATE=${PWD}/crypto-config/ordererOrganizations/default.com/orderers/orderer.default.com/tls/server.crt
export ORDERER_GENERAL_TLS_ROOTCAS=${PWD}/crypto-config/ordererOrganizations/default.com/orderers/orderer.default.com/tls/ca.crt
export ORDERER_GENERAL_LISTENADDRESS=0.0.0.0
export ORDERER_GENERAL_LISTENPORT=7050
export ORDERER_GENERAL_TLS_ENABLED=true
export ORDERER_GENERAL_LOCALMSPID=OrdererMSP
orderer

# - FABRIC_LOGGING_SPEC=DEBUG
# #- ORDERER_GENERAL_GENESISMETHOD=file
# #- ORDERER_GENERAL_GENESISFILE=/var/hyperledger/orderer/orderer.genesis.block
# - ORDERER_GENERAL_LOCALMSPDIR=/var/hyperledger/orderer/msp
# enabled TLS