pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import "base/Terminal.sol";
import "base/Menu.sol";
import "IShoppingList.sol";
import "Structs.sol";
import "AInitDebot.sol";

contract BaseDebot is AInitDebot {
    
    function _menu() virtual internal override {
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
                MenuItem("Show purchases list","",tvm.functionId(showPurchases)),
                MenuItem("Delete purchase","",tvm.functionId(deletePurchase))
            ]
        );
    }

    function showPurchases(uint32 index) public view {
        optional(uint256) none;
        IShoppingList(m_address).getPurchaseList{
            abiVer: 2,
            extMsg: true,
            sign: false,
            pubkey: none,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(showPurchases_),
            onErrorId: 0
        }();
    }

    function showPurchases_( Purchase[] purchases ) public {

        if (purchases.length > 0 ) {
            Terminal.print(0, "Your shopping list:");

            for (Purchase purchase: purchases) {
                
                if (purchase.isBought) {
                    Terminal.print(0, format(
                        "{} \"{}\":\n Amount: {}\nCost: {}\nCreated at time: {}",
                        purchase.id,
                        purchase.name, 
                        purchase.amount,  
                        purchase.cost,
                        purchase.createdAt)
                    );
                } else {
                    Terminal.print(0, format(
                        "{} \"{}\":\n Amount: {}\nThis purchase still unpaid\nCreated at time: {}",
                        purchase.id,
                        purchase.name, 
                        purchase.amount,  
                        purchase.createdAt)
                    );
                }
            }

        } else {
            Terminal.print(0, "You have no purchases yet");
        }

        _menu();
    } 

    function deletePurchase(uint32 index) public {
        if ((m_summary.paid != 0) || (m_summary.unpaid != 0)) {
            Terminal.input(tvm.functionId(deletePurchase_), "Enter purchase id", false);
        } else {
            Terminal.print(0, "You have no purchases yet");
            _menu();
        }
    }

    function deletePurchase_(string value) public view {
        (uint256 id, bool status) = stoi(value);
        optional(uint256) pubkey = 0;
        IShoppingList(m_address).removePurchase{
                abiVer: 2,
                extMsg: true,
                sign: true,
                pubkey: pubkey,
                time: uint64(now),
                expire: 0,
                callbackId: tvm.functionId(onSuccess),
                onErrorId: tvm.functionId(onError)
            }(uint(id));
    }
}
