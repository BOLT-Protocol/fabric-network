#!/bin/bash

source scriptUtils.sh

function createDefaultOrg() {

  infoln "Enroll the CA admin"
  mkdir -p crypto-config/peerOrganizations/default.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/crypto-config/peerOrganizations/default.com/
  #  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
  #  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-default --tls.certfiles ${PWD}/crypto-config/fabric-ca/defaultOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-default.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-default.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-default.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-default.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/crypto-config/peerOrganizations/default.com/msp/config.yaml

  infoln "Register devpeer"
  set -x
  fabric-ca-client register --caname ca-default --id.name devpeer --id.secret devpeerpw --id.type peer --tls.certfiles ${PWD}/crypto-config/fabric-ca/defaultOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register user1"
  set -x
  fabric-ca-client register --caname ca-default --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/crypto-config/fabric-ca/defaultOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register user2"
  set -x
  fabric-ca-client register --caname ca-default --id.name user2 --id.secret user2pw --id.type client --tls.certfiles ${PWD}/crypto-config/fabric-ca/defaultOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register the org admin"
  set -x
  fabric-ca-client register --caname ca-default --id.name defaultAdmin --id.secret defaultAdminpw --id.type admin --tls.certfiles ${PWD}/crypto-config/fabric-ca/defaultOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  mkdir -p crypto-config/peerOrganizations/default.com/peers/devpeer
  
  infoln "Generate the devpeer msp"
  set -x
  fabric-ca-client enroll -u https://devpeer:devpeerpw@localhost:7054 --caname ca-default -M ${PWD}/crypto-config/peerOrganizations/default.com/peers/devpeer/msp --csr.hosts "devpeer.default.com, $1" --tls.certfiles ${PWD}/crypto-config/fabric-ca/defaultOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/crypto-config/peerOrganizations/default.com/msp/config.yaml ${PWD}/crypto-config/peerOrganizations/default.com/peers/devpeer/msp/config.yaml

  infoln "Generate the devpeer certificates"
  set -x
  fabric-ca-client enroll -u https://devpeer:devpeerpw@localhost:7054 --caname ca-default -M ${PWD}/crypto-config/peerOrganizations/default.com/peers/devpeer/tls --enrollment.profile tls --csr.hosts "devpeer.default.com, localhost, $1" --tls.certfiles ${PWD}/crypto-config/fabric-ca/defaultOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/crypto-config/peerOrganizations/default.com/peers/devpeer/tls/tlscacerts/* ${PWD}/crypto-config/peerOrganizations/default.com/peers/devpeer/tls/ca.crt
  cp ${PWD}/crypto-config/peerOrganizations/default.com/peers/devpeer/tls/signcerts/* ${PWD}/crypto-config/peerOrganizations/default.com/peers/devpeer/tls/server.crt
  cp ${PWD}/crypto-config/peerOrganizations/default.com/peers/devpeer/tls/keystore/* ${PWD}/crypto-config/peerOrganizations/default.com/peers/devpeer/tls/server.key

  mv ${PWD}/crypto-config/peerOrganizations/default.com/peers/devpeer/msp/keystore/* ${PWD}/crypto-config/peerOrganizations/default.com/peers/devpeer/msp/keystore/priv_sk

  mkdir -p ${PWD}/crypto-config/peerOrganizations/default.com/msp/tlscacerts
  cp ${PWD}/crypto-config/peerOrganizations/default.com/peers/devpeer/tls/tlscacerts/* ${PWD}/crypto-config/peerOrganizations/default.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/crypto-config/peerOrganizations/default.com/tlsca
  cp ${PWD}/crypto-config/peerOrganizations/default.com/peers/devpeer/tls/tlscacerts/* ${PWD}/crypto-config/peerOrganizations/default.com/tlsca/tlsca.default.com-cert.pem

  mkdir -p ${PWD}/crypto-config/peerOrganizations/default.com/ca
  cp ${PWD}/crypto-config/peerOrganizations/default.com/peers/devpeer/msp/cacerts/* ${PWD}/crypto-config/peerOrganizations/default.com/ca/ca.default.com-cert.pem

  rm -rf ${PWD}/crypto-config/peerOrganizations/default.com/peers/devpeer/tls/tlscacerts/*
  rm -rf ${PWD}/crypto-config/peerOrganizations/default.com/peers/devpeer/tls/signcerts/*

  mkdir -p crypto-config/peerOrganizations/default.com/users
  mkdir -p crypto-config/peerOrganizations/default.com/users/User1@default.com
  mkdir -p crypto-config/peerOrganizations/default.com/users/User2@default.com

  infoln "Generate the user1 msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-default -M ${PWD}/crypto-config/peerOrganizations/default.com/users/User1@default.com/msp --tls.certfiles ${PWD}/crypto-config/fabric-ca/defaultOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/crypto-config/peerOrganizations/default.com/msp/config.yaml ${PWD}/crypto-config/peerOrganizations/default.com/users/User1@default.com/msp/config.yaml

  infoln "Generate the user2 msp"
  set -x
  fabric-ca-client enroll -u https://user2:user2pw@localhost:7054 --caname ca-default -M ${PWD}/crypto-config/peerOrganizations/default.com/users/User2@default.com/msp --tls.certfiles ${PWD}/crypto-config/fabric-ca/defaultOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/crypto-config/peerOrganizations/default.com/msp/config.yaml ${PWD}/crypto-config/peerOrganizations/default.com/users/User2@default.com/msp/config.yaml

  mkdir -p crypto-config/peerOrganizations/default.com/users/Admin@default.com

  infoln "Generate the org admin msp"
  set -x
  fabric-ca-client enroll -u https://defaultAdmin:defaultAdminpw@localhost:7054 --caname ca-default -M ${PWD}/crypto-config/peerOrganizations/default.com/users/Admin@default.com/msp --tls.certfiles ${PWD}/crypto-config/fabric-ca/defaultOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/crypto-config/peerOrganizations/default.com/msp/config.yaml ${PWD}/crypto-config/peerOrganizations/default.com/users/Admin@default.com/msp/config.yaml
  mv ${PWD}/crypto-config/peerOrganizations/default.com/users/Admin@default.com/msp/signcerts/cert.pem ${PWD}/crypto-config/peerOrganizations/default.com/users/Admin@default.com/msp/signcerts/Admin@default.com-cert.pem
  mv ${PWD}/crypto-config/peerOrganizations/default.com/users/Admin@default.com/msp/keystore/* ${PWD}/crypto-config/peerOrganizations/default.com/users/Admin@default.com/msp/keystore/priv_sk
}

function createAsusOrg() {

  infoln "Enroll the CA admin"
  mkdir -p crypto-config/peerOrganizations/asus.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/crypto-config/peerOrganizations/asus.com/
  #  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
  #  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-asus --tls.certfiles ${PWD}/crypto-config/fabric-ca/asusOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-asus.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-asus.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-asus.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-asus.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/crypto-config/peerOrganizations/asus.com/msp/config.yaml

  infoln "Register peer0"
  set -x
  fabric-ca-client register --caname ca-asus --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/crypto-config/fabric-ca/asusOrg/tls-cert.pem
  { set +x; } 2>/dev/null
  
  infoln "Register peer1"
  set -x
  fabric-ca-client register --caname ca-asus --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/crypto-config/fabric-ca/asusOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register peer2"
  set -x
  fabric-ca-client register --caname ca-asus --id.name peer2 --id.secret peer2pw --id.type peer --tls.certfiles ${PWD}/crypto-config/fabric-ca/asusOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register user1"
  set -x
  fabric-ca-client register --caname ca-asus --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/crypto-config/fabric-ca/asusOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register user2"
  set -x
  fabric-ca-client register --caname ca-asus --id.name user2 --id.secret user2pw --id.type client --tls.certfiles ${PWD}/crypto-config/fabric-ca/asusOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register the org admin"
  set -x
  fabric-ca-client register --caname ca-asus --id.name org2admin --id.secret org2adminpw --id.type admin --tls.certfiles ${PWD}/crypto-config/fabric-ca/asusOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  mkdir -p crypto-config/peerOrganizations/asus.com/peers
  mkdir -p crypto-config/peerOrganizations/asus.com/peers/peer0.asus.com

  infoln "Generate the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-asus -M ${PWD}/crypto-config/peerOrganizations/asus.com/peers/peer0.asus.com/msp --csr.hosts "peer0.asus.com, $1" --tls.certfiles ${PWD}/crypto-config/fabric-ca/asusOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/crypto-config/peerOrganizations/asus.com/msp/config.yaml ${PWD}/crypto-config/peerOrganizations/asus.com/peers/peer0.asus.com/msp/config.yaml

  infoln "Generate the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-asus -M ${PWD}/crypto-config/peerOrganizations/asus.com/peers/peer0.asus.com/tls --enrollment.profile tls --csr.hosts "peer0.asus.com, localhost, $1" --tls.certfiles ${PWD}/crypto-config/fabric-ca/asusOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/crypto-config/peerOrganizations/asus.com/peers/peer0.asus.com/tls/tlscacerts/* ${PWD}/crypto-config/peerOrganizations/asus.com/peers/peer0.asus.com/tls/ca.crt
  cp ${PWD}/crypto-config/peerOrganizations/asus.com/peers/peer0.asus.com/tls/signcerts/* ${PWD}/crypto-config/peerOrganizations/asus.com/peers/peer0.asus.com/tls/server.crt
  cp ${PWD}/crypto-config/peerOrganizations/asus.com/peers/peer0.asus.com/tls/keystore/* ${PWD}/crypto-config/peerOrganizations/asus.com/peers/peer0.asus.com/tls/server.key

  mv ${PWD}/crypto-config/peerOrganizations/asus.com/peers/peer0.asus.com/msp/keystore/* ${PWD}/crypto-config/peerOrganizations/asus.com/peers/peer0.asus.com/msp/keystore/priv_sk

  mkdir -p ${PWD}/crypto-config/peerOrganizations/asus.com/msp/tlscacerts
  cp ${PWD}/crypto-config/peerOrganizations/asus.com/peers/peer0.asus.com/tls/tlscacerts/* ${PWD}/crypto-config/peerOrganizations/asus.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/crypto-config/peerOrganizations/asus.com/tlsca
  cp ${PWD}/crypto-config/peerOrganizations/asus.com/peers/peer0.asus.com/tls/tlscacerts/* ${PWD}/crypto-config/peerOrganizations/asus.com/tlsca/tlsca.asus.com-cert.pem

  mkdir -p ${PWD}/crypto-config/peerOrganizations/asus.com/ca
  cp ${PWD}/crypto-config/peerOrganizations/asus.com/peers/peer0.asus.com/msp/cacerts/* ${PWD}/crypto-config/peerOrganizations/asus.com/ca/ca.asus.com-cert.pem

  infoln "Generate the peer1 msp"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca-asus -M ${PWD}/crypto-config/peerOrganizations/asus.com/peers/peer1.asus.com/msp --csr.hosts "peer1.asus.com, $1" --tls.certfiles ${PWD}/crypto-config/fabric-ca/asusOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/crypto-config/peerOrganizations/asus.com/msp/config.yaml ${PWD}/crypto-config/peerOrganizations/asus.com/peers/peer1.asus.com/msp/config.yaml

  infoln "Generate the peer1-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:8054 --caname ca-asus -M ${PWD}/crypto-config/peerOrganizations/asus.com/peers/peer1.asus.com/tls --enrollment.profile tls --csr.hosts "peer1.asus.com, localhost, $1" --tls.certfiles ${PWD}/crypto-config/fabric-ca/asusOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/crypto-config/peerOrganizations/asus.com/peers/peer1.asus.com/tls/tlscacerts/* ${PWD}/crypto-config/peerOrganizations/asus.com/peers/peer1.asus.com/tls/ca.crt
  cp ${PWD}/crypto-config/peerOrganizations/asus.com/peers/peer1.asus.com/tls/signcerts/* ${PWD}/crypto-config/peerOrganizations/asus.com/peers/peer1.asus.com/tls/server.crt
  cp ${PWD}/crypto-config/peerOrganizations/asus.com/peers/peer1.asus.com/tls/keystore/* ${PWD}/crypto-config/peerOrganizations/asus.com/peers/peer1.asus.com/tls/server.key
 
  mv ${PWD}/crypto-config/peerOrganizations/asus.com/peers/peer1.asus.com/msp/keystore/* ${PWD}/crypto-config/peerOrganizations/asus.com/peers/peer1.asus.com/msp/keystore/priv_sk

  infoln "Generate the peer2 msp"
  set -x
  fabric-ca-client enroll -u https://peer2:peer2pw@localhost:8054 --caname ca-asus -M ${PWD}/crypto-config/peerOrganizations/asus.com/peers/peer2.asus.com/msp --csr.hosts "peer2.asus.com, $1" --tls.certfiles ${PWD}/crypto-config/fabric-ca/asusOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/crypto-config/peerOrganizations/asus.com/msp/config.yaml ${PWD}/crypto-config/peerOrganizations/asus.com/peers/peer2.asus.com/msp/config.yaml

  infoln "Generate the peer2-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer2:peer2pw@localhost:8054 --caname ca-asus -M ${PWD}/crypto-config/peerOrganizations/asus.com/peers/peer2.asus.com/tls --enrollment.profile tls --csr.hosts "peer2.asus.com, localhost, $1" --tls.certfiles ${PWD}/crypto-config/fabric-ca/asusOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/crypto-config/peerOrganizations/asus.com/peers/peer2.asus.com/tls/tlscacerts/* ${PWD}/crypto-config/peerOrganizations/asus.com/peers/peer2.asus.com/tls/ca.crt
  cp ${PWD}/crypto-config/peerOrganizations/asus.com/peers/peer2.asus.com/tls/signcerts/* ${PWD}/crypto-config/peerOrganizations/asus.com/peers/peer2.asus.com/tls/server.crt
  cp ${PWD}/crypto-config/peerOrganizations/asus.com/peers/peer2.asus.com/tls/keystore/* ${PWD}/crypto-config/peerOrganizations/asus.com/peers/peer2.asus.com/tls/server.key

  mv ${PWD}/crypto-config/peerOrganizations/asus.com/peers/peer2.asus.com/msp/keystore/* ${PWD}/crypto-config/peerOrganizations/asus.com/peers/peer2.asus.com/msp/keystore/priv_sk

  mkdir -p crypto-config/peerOrganizations/asus.com/users
  mkdir -p crypto-config/peerOrganizations/asus.com/users/User1@asus.com
  mkdir -p crypto-config/peerOrganizations/asus.com/users/User2@asus.com

  infoln "Generate the user1 msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-asus -M ${PWD}/crypto-config/peerOrganizations/asus.com/users/User1@asus.com/msp --tls.certfiles ${PWD}/crypto-config/fabric-ca/asusOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/crypto-config/peerOrganizations/asus.com/msp/config.yaml ${PWD}/crypto-config/peerOrganizations/asus.com/users/User1@asus.com/msp/config.yaml

  infoln "Generate the user2 msp"
  set -x
  fabric-ca-client enroll -u https://user2:user2pw@localhost:8054 --caname ca-asus -M ${PWD}/crypto-config/peerOrganizations/asus.com/users/User2@asus.com/msp --tls.certfiles ${PWD}/crypto-config/fabric-ca/asusOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/crypto-config/peerOrganizations/asus.com/msp/config.yaml ${PWD}/crypto-config/peerOrganizations/asus.com/users/User2@asus.com/msp/config.yaml

  mkdir -p crypto-config/peerOrganizations/asus.com/users/Admin@asus.com

  infoln "Generate the org admin msp"
  set -x
  fabric-ca-client enroll -u https://org2admin:org2adminpw@localhost:8054 --caname ca-asus -M ${PWD}/crypto-config/peerOrganizations/asus.com/users/Admin@asus.com/msp --tls.certfiles ${PWD}/crypto-config/fabric-ca/asusOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/crypto-config/peerOrganizations/asus.com/msp/config.yaml ${PWD}/crypto-config/peerOrganizations/asus.com/users/Admin@asus.com/msp/config.yaml
  mv ${PWD}/crypto-config/peerOrganizations/asus.com/users/Admin@asus.com/msp/signcerts/cert.pem ${PWD}/crypto-config/peerOrganizations/asus.com/users/Admin@default.com/msp/signcerts/Admin@asus.com-cert.pem
  mv ${PWD}/crypto-config/peerOrganizations/asus.com/users/Admin@asus.com/msp/keystore/* ${PWD}/crypto-config/peerOrganizations/asus.com/users/Admin@asus.com/msp/keystore/priv_sk
}

function createOrderer() {

  infoln "Enroll the CA admin"
  mkdir -p crypto-config/ordererOrganizations/default.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/crypto-config/ordererOrganizations/default.com
  #  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
  #  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles ${PWD}/crypto-config/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/crypto-config/ordererOrganizations/default.com/msp/config.yaml

  infoln "Register orderer"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/crypto-config/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register the orderer admin"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/crypto-config/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  mkdir -p crypto-config/ordererOrganizations/default.com/orderers
  mkdir -p crypto-config/ordererOrganizations/default.com/orderers/orderer.default.com

  infoln "Generate the orderer msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/crypto-config/ordererOrganizations/default.com/orderers/orderer.default.com/msp --csr.hosts "orderer.default.com, localhost, $1" --tls.certfiles ${PWD}/crypto-config/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/crypto-config/ordererOrganizations/default.com/msp/config.yaml ${PWD}/crypto-config/ordererOrganizations/default.com/orderers/orderer.default.com/msp/config.yaml

  infoln "Generate the orderer-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/crypto-config/ordererOrganizations/default.com/orderers/orderer.default.com/tls --enrollment.profile tls --csr.hosts "orderer.default.com, localhost, $1" --tls.certfiles ${PWD}/crypto-config/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/crypto-config/ordererOrganizations/default.com/orderers/orderer.default.com/tls/tlscacerts/* ${PWD}/crypto-config/ordererOrganizations/default.com/orderers/orderer.default.com/tls/ca.crt
  cp ${PWD}/crypto-config/ordererOrganizations/default.com/orderers/orderer.default.com/tls/signcerts/* ${PWD}/crypto-config/ordererOrganizations/default.com/orderers/orderer.default.com/tls/server.crt
  cp ${PWD}/crypto-config/ordererOrganizations/default.com/orderers/orderer.default.com/tls/keystore/* ${PWD}/crypto-config/ordererOrganizations/default.com/orderers/orderer.default.com/tls/server.key

  mkdir -p ${PWD}/crypto-config/ordererOrganizations/default.com/orderers/orderer.default.com/msp/tlscacerts
  cp ${PWD}/crypto-config/ordererOrganizations/default.com/orderers/orderer.default.com/tls/tlscacerts/* ${PWD}/crypto-config/ordererOrganizations/default.com/orderers/orderer.default.com/msp/tlscacerts/tlsca.default.com-cert.pem

  mkdir -p ${PWD}/crypto-config/ordererOrganizations/default.com/msp/tlscacerts
  cp ${PWD}/crypto-config/ordererOrganizations/default.com/orderers/orderer.default.com/tls/tlscacerts/* ${PWD}/crypto-config/ordererOrganizations/default.com/msp/tlscacerts/tlsca.default.com-cert.pem

  mkdir -p ${PWD}/crypto-config/ordererOrganizations/default.com/ca
  cp ${PWD}/crypto-config/ordererOrganizations/default.com/orderers/orderer.default.com/msp/cacerts/* ${PWD}/crypto-config/ordererOrganizations/default.com/ca/ca.default.com-cert.pem


  mkdir -p crypto-config/ordererOrganizations/default.com/users
  mkdir -p crypto-config/ordererOrganizations/default.com/users/Admin@default.com

  infoln "Generate the admin msp"
  set -x
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M ${PWD}/crypto-config/ordererOrganizations/default.com/users/Admin@default.com/msp --tls.certfiles ${PWD}/crypto-config/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/crypto-config/ordererOrganizations/default.com/msp/config.yaml ${PWD}/crypto-config/ordererOrganizations/default.com/users/Admin@default.com/msp/config.yaml

}
