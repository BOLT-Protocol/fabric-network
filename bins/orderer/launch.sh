#  Launches the orderer
#  You may override orderer properties in this file

# Change the logging leve to the desired level
export FABRIC_CFG_PATH=${PWD}/bins/orderer
export FABRIC_LOGGING_SPEC=WARNING
export ORDERER_GENERAL_BOOTSTRAPFILE=${PWD}/artefacts/default-genesis.block
export ORDERER_GENERAL_LOCALMSPDIR=${PWD}/crypto-config/ordererOrganizations/default.com/users/Admin@default.com/msp
export ORDERER_GENERAL_TLS_PRIVATEKEY=${PWD}/crypto-config/ordererOrganizations/default.com/orderer.default.com/tls/server.key
export ORDERER_GENERAL_TLS_CERTIFICATE=${PWD}/crypto-config/ordererOrganizations/default.com/orderer.default.com/tls/server.crt
orderer