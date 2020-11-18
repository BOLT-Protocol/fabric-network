rm artefacts/*   2> /dev/null
rm -rf temp      2> /dev/null
rm *.block       2> /dev/null
rm -rf crypto-config        2> /dev/null
rm -rf bins/orderer/ledger
rm -rf bins/peer/ledger

killall peer
killall orderer
echo "Done."