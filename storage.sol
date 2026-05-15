//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Storage{

uint256 x;
uint256 y = 59;
uint256 z = 939;

function getA() public view returns(uint256) {
uint256 result;
assembly {

      result:= sload(x.slot)

}
return result;

}

function setA(uint256 val) public{

    assembly{
       sstore(x.slot , val)
    }
}

function getSLotValue(uint256 slotNumber) public view returns(uint256){
uint256 result;
    assembly {
        result := sload(slotNumber)
    }
    return result;
}
} 