pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;
contract taskslist {
    struct task {
        string title;
        uint createTime;
        bool isDone;
    }

    uint256 numberOfTasks=0;

    mapping (int8 => task) tasksArray;

    int8 firstAvaliableID=0;

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

    function AddTask (string title) public checkOwnerAndAccept{
        task currentTask;
        currentTask.title = title;
        currentTask.createTime = now;
        currentTask.isDone = false;
        tasksArray[firstAvaliableID]=currentTask;
        firstAvaliableID++;
        numberOfTasks++;
    }

    function GetNumberOfTasks () public checkOwnerAndAccept returns(uint){
        return numberOfTasks;
    }

    function GetListOfTasks () public checkOwnerAndAccept returns (mapping (int8 => task)){
        return tasksArray;
    }

    function GetTask(int8 key) public checkOwnerAndAccept returns (task){
        return tasksArray[key];
    }

    function DeleteTask(int8 key) public checkOwnerAndAccept{
        delete tasksArray[key];
        numberOfTasks--;
    }

    function MarkAsDone(int8 key) public checkOwnerAndAccept{
        tasksArray[key].isDone = true;
        numberOfTasks--;
    }
}
