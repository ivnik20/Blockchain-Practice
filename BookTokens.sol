pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract BookTokens {

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

    modifier checkTokenOwner(string tokenName) {
        require(msg.pubkey() == fromBookToOwner[tokenName], 100, "Token Access Violation!");
        _;
    }

    struct Token {
        string name;
        string author;
        string genre;
        uint value;
        bool isForSale;
    }

    mapping (string => uint) fromBookToOwner;

    mapping (string => Token) fromNameToToken;

    function createToken(string name, string author, string genre) public checkOwnerAndAccept {
        require(!fromBookToOwner.exists(name), 103, "Such book already exists!");
        fromNameToToken[name]=Token(name, author, genre, 0, false);
        fromBookToOwner[name] = msg.pubkey();
    }

    function GetTokenOwner(string name) public view returns(uint) {
        return fromBookToOwner[name];
    }

    function GetTokenInfo(string name) public view returns(string tokenName, string author, string genre, uint value, bool isForSale) {
        tokenName = fromNameToToken[name].name;
        author = fromNameToToken[name].author;
        genre = fromNameToToken[name].genre;
        value = fromNameToToken[name].value;
        isForSale = fromNameToToken[name].isForSale;
    }

    function PutUpForSale(string name, uint value) public checkOwnerAndAccept checkTokenOwner(name) {
        fromNameToToken[name].value = value;
        fromNameToToken[name].isForSale = true;
    }
}
