pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract Wallet {
    /*
     Exception codes:
      100 - message sender is not a wallet owner.
      101 - invalid transfer value.
     */
    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    modifier checkOwnerAndAccept {
        require(msg.pubkey() == tvm.pubkey(), 100);
		tvm.accept();
		_;
	}
    function sendTransactionWithoutFee(address dest, uint128 value) public pure checkOwnerAndAccept {
        dest.transfer(value, true, 0);
    }
    function sendTransactionWithFee(address dest, uint128 value) public pure checkOwnerAndAccept {
        dest.transfer(value, true, 64);
    }
    function sendAllandDestroy(address dest, uint128 value) public pure checkOwnerAndAccept {
        dest.transfer(value, true, 128+32);
    }
}
