## Get Started

產生 block, channel
`sh ./gen-test.sh`

開 orderer
`sh ./docker/launch.sh -O bolt.com -M OrdererMSP -p 7050 -n orderer0 -t orderer`
`sh ./docker/launch.sh -O bolt.com -M OrdererMSP -p 8050 -n orderer1 -t orderer`
`sh ./docker/launch.sh -O bolt.com -M OrdererMSP -p 9050 -n orderer2 -t orderer`

開 peer
`sh ./docker/launch.sh -O bolt.com -M BoltMSP -p 7051 -n devpeer -t peer -d 5000`
`sh ./docker/launch.sh -O example.com -M Org1MSP -p 8051 -n org1 -t peer -d 6000`

<br>
---
<br>

> TODO: 以下檔案 IP 位置要改 

- `configtx.yaml`
- `first-network.json`
- `bins/peer/set-env.sh`

### 啟動初始 Peer 與 Orderer 並建立資料

`./start-base.sh`

或手動執行
***
***step1. 產生初始檔案***
**使用 CA**
或
1. orderer, peer crypto 資料

    ```./gen-crypto.sh all```
2.  產生 genesis.block, 初始 channel

    ```./gen-genesis-channeltx.sh```

***step2. 開啟節點***
1. ./bins/orderer/launch.sh &
2. ./bins/peer/launch.sh &

初始 peer 加入 channel
./bins/peer/join-channel.sh

killall peer
killall orderer

### Chaincode
> 測試(!資料為寫死的) 

**before started**
- install Golang on env
- Clone fabcar https://github.com/hyperledger/fabric-samples/tree/release-1.2/fabcar to folder

**Install chaincode**
1. `./bins/peer/package_cc.sh` 打包檔案至設定位置
2. `./bins/peer/install_cc.sh` 安裝 chaincode 
3. `./bins/peer/query_installed_cc.sh` 查詢已安裝 chaincide
4. `./bins/peer/approve_cc.sh -c {3.查詢到的結果} -C ${channal} -n {chaincode name} -s {Sequence} -v {chaincode version}` 節點 驗證  chaincode
5. `./bins/peer/check_commit_cc.sh ~~~各種參數` 檢查可 commit 的 chaincode，如果是 ture 再往下
6. `./bins/peer/commit_cc.sh  ~~~各種參數` commit chaicode
7. `./bins/peer/query_committed_cc.sh  ~~~各種參數` 查詢 channel chaincode 資訊

## CA
設定 ca/.env
$CSR_HOST 本地 IP/Domain

***step1. 開啟 root CA***

`cd ca && docker-compose -f docker-compose-tls-ca.yaml up -d`
會在 ca/tls-ca 下產生 root ca 相關檔案

***step2. Enroll Admin***
`./ca/enroll.sh -u <USER> -p <PASSWORD>` 裡面用到的 USER 和 PW 要和 step1 的 server 相同

`./ca/affiliation_add.sh <aff name>` 創建組織
***step3. Register***
`./ca/register.sh -u <USER> -p <PASSWORD> -a <AFFILIATION>` 登入用戶(此時不會產生檔案，要step4後才會)

```
./ca.register.sh -u bolt-admin -p pw -a blot
```


***step4. Enroll User***
`./ca/identity_list.sh` 查看哪些用戶可以 Enroll

`./ca/enroll.sh -u <USER> -p <PASSWORD> -a <AFFILIATION>` USER 為上方查到的 name
```
./ca.enroll.sh -u bolt-admin -p pw -a blot
```

### 產生 orderer
修改 configtx.yaml `MSPDir`
修改 bins/orderer/launch.sh

### 產生 Genesis/block
### 產生 Channel tx
./gen-genesis.channeltx.sh