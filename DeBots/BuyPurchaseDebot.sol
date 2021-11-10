pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import "base/Terminal.sol";
import "base/Menu.sol";
import "IShoppingList.sol";
import "Structs.sol";
import "BaseDebot.sol";

contract DebotForBuy is BaseDebot {

    uint private purchaseId;

    function _menu() internal override {
        string sep = '----------------------------------------';
        Menu.select(
            format(
                "You have {} unpaid and {} paid purchases in the amount of {}",
                    m_summary.unpaid,
                    m_summary.paid,
                    m_summary.resultCost
            ),
            sep,
            [
                MenuItem("Pay for the purchase","",tvm.functionId(buy)),
                MenuItem("Show purchases list","",tvm.functionId(showPurchases)),
                MenuItem("Delete purchase","",tvm.functionId(deletePurchase))
            ]
        );
    }

    function buy(uint32 index) public {
        Terminal.input(tvm.functionId(buy_), "Enter purchase id:", false);
    }

    function buy_(string value) public {
        (uint256 id, ) = stoi(value);
        purchaseId = id;
        Terminal.input(tvm.functionId(buy__), "Enter purchase cost:", false);
    }

    function buy__(string value) public view {
        (uint256 price, ) = stoi(value);
        optional(uint256) pubkey = 0;
        IShoppingList(m_address).buy{
                abiVer: 2,
                extMsg: true,
                sign: true,
                pubkey: pubkey,
                time: uint64(now),
                expire: 0,
                callbackId: tvm.functionId(onSuccess),
                onErrorId: tvm.functionId(onError)
            }( uint(purchaseId),  uint(price));
    }
}