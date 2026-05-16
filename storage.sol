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

// Reading varibale of same slot using assembly 

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Storage2 {
    uint128 a = 5;
    uint64 b = 10;
    uint16 c = 15;
    uint8 d = 12;

    function readC() public returns (uint256 rslt) {
        assembly {
            let value := sload(c.slot)

            let shifting := shr(mul(c.offset, 8), value)

            value := and(shifting, 0xFFFF)
            rslt := value
        }
    }

    function writeC (uint256 newValue) public {

assembly {

   let  value := sload(c.slot)
   let mask := not(shl(mul(c.offset,8), 0xFFFF))
   value := and(value , mask)
   let shiftNew := shl(mul(c.offset,8) , newValue)
   value := or(value, shiftNew)
   sstore(c.slot, value)


}

    }
}
