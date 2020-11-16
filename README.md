***啟動初始 Peer 與 Orderer 並建立資料***
./start-base.sh

***step1. 產生初始檔案***

1. orderer, peer crypto 資料

    ```./gen-crypto.sh all```
2.  產生 genesis.block, 初始 channel

    ```./gen-genesis-channeltx.sh```

***step2. 開啟節點 ***
1. ./bins/orderer/launch.sh
2. ./bins/peer/launch.sh &