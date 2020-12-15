## Get Started

> TODO: 以下檔案 IP Address 要改 

- `configtx.yaml` => Orderer Address
- `first-network.json` => Peer Address
- `bins/peer/set-env.sh`  => Orderer Address


### 啟動初始 Peer 與 Orderer 並建立資料

`./start-base.sh`

或手動執行
***
***step1. 產生初始檔案***

1. orderer, peer crypto 資料
    1.1
    ```./gen-crypto.sh all```
    
    1.2 with ca
    ```./gen-crypto-ca.sh up```
    
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
