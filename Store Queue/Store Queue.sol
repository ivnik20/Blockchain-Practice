pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;
contract StoreQueue {
    string [] queue;
    constructor() public {

        require(tvm.pubkey() != 0, 101);

        require(msg.pubkey() == tvm.pubkey(), 102);

        tvm.accept();
    }

	modifier checkOwnerAndAccept {
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
		_;
	}

    modifier checkArrayEmpty {
        require(!queue.empty());
        _;
    }

    function pop_front() private{
        for(uint i=0;i<queue.length-1;i++){
            queue[i]=queue[i+1];
        }
        queue.pop();
    }

    function AddCustomer(string customer) public checkOwnerAndAccept returns (string[]) {
        queue.push(customer);
        return queue;
    }

    function CallNext() public checkOwnerAndAccept checkArrayEmpty returns (string[]) {
        pop_front();
        return queue;
    }
}
