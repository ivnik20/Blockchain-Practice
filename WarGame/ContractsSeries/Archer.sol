
/**
 * This file was generated by TONDev.
 * TONDev is a part of TON OS (see http://ton.dev).
 */
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "WarUnit.sol";

contract Archer is WarUnit{
constructor (BaseStation baseStation) WarUnit(baseStation) public Accept{
    uint attackPoints = 3;
    uint defencePoints = 1;
}
     function GetAttackPoints() override external Accept returns(uint){
        return attackPoints;
    }

}